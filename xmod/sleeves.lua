SMODS.Atlas {
    key = "wafflemod_sleeveAtlas",
    path = "xmod/sleeves.png",
    px = 73,
    py = 95,
}

-- Waffle Sleeve
CardSleeves.Sleeve {
    key = "waffle",
    atlas = "wafflemod_sleeveAtlas",
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            odds = 5,
            discount = 2
        }
    },
    loc_vars = function(self, info_queue)
        local key, vars
        if self.get_current_deck_key() == "b_wafflemod_waffle" then
            key = self.key .. "_alt"
            vars = { self.config.extra.discount }
        else
            key = self.key
            vars = { (G.GAME.probabilities.normal or 1), self.config.extra.odds }
        end
        return { key = key, vars = vars }
    end,
    calculate = function(self, sleeve, context)
        if context.create_shop_card and self.get_current_deck_key() ~= "b_wafflemod_waffle" then
            local isJoker = context.set == "Joker"

            if isJoker then
                local rollToReplace = SMODS.pseudorandom_probability(back, "waffleSleeveJokerRng", 1,
                    self.config.extra.odds)
                if rollToReplace then
                    return {
                        shop_create_flags = {
                            set = "wafflemod_jokers"
                        }
                    }
                else
                end
            else
            end
        elseif context.modify_shop_card and self.get_current_deck_key() == "b_wafflemod_waffle" then
            --print("modify context with waffle sleeve and deck")

            local card = context.card

            if (card.config.center.pools or {}).wafflemod_jokers then
                --print("lower cost")
                card.cost = math.max(card.cost - (sleeve.config.extra.discount or 2), 0)
            end
        end
    end
}

-- Blighted Sleeve
CardSleeves.Sleeve {
    key = "blighted",
    atlas = "wafflemod_sleeveAtlas",
    pos = { x = 1, y = 0 },
    config = {
        extra = {
            debuffed_sales_needed = 4,
            joker_slot_gain = 1,
            money = 5
        }
    },
    loc_vars = function(self, info_queue)
        local key, vars
        if self.get_current_deck_key() == "b_wafflemod_blighted" then
            key = self.key .. "_alt"
            vars = { self.config.extra.money }
        else
            key = self.key
            local remaining = self.config.extra.debuffed_sales_needed
            if G.GAME then
                remaining = remaining - (G.GAME.debuffed_joker_sales or 0) % remaining
            end
            vars = {
                self.config.extra.joker_slot_gain, self.config.extra.debuffed_sales_needed, remaining
            }
        end
        return { key = key, vars = vars }
    end,
    calculate = function(self, sleeve, context)
        if context.selling_card and context.card.debuff and context.card.ability.set == "Joker" then
            if WaffleMod.getCurrentBack() == "b_wafflemod_blighted" then
                G.E_MANAGER:add_event(Event {
                    func = function()
                        ease_dollars(self.config.extra.money)
                        return true
                    end
                })
            else
                G.GAME.debuffed_joker_sales = (G.GAME.debuffed_joker_sales or 0) + 1
                if G.GAME.debuffed_joker_sales % self.config.extra.debuffed_sales_needed == 0 then
                    if G.jokers then
                        G.jokers.config.card_limit = G.jokers.config.card_limit + self.config.extra.joker_slot_gain
                        if G.deck and G.deck.cards and G.deck.cards[1] then
                            return {
                                message_card = G.deck.cards[1],
                                message = localize('k_upgrade_ex')
                            }
                        end
                    end
                end
            end
        end
    end
}
local emplaceRef = CardArea.emplace
function CardArea.emplace(self, card, flipped)
    if G.GAME and G.GAME.selected_sleeve == "sleeve_wafflemod_blighted" and (self == G.pack_cards or self == G.shop_jokers or (self == G.jokers and not card:is_rarity(4))) then
        WaffleMod.blightedMakePerishable(card)
    end
    emplaceRef(self, card, flipped)
end

-- Hunting Sleeve
CardSleeves.Sleeve {
    key = "hunting",
    atlas = "wafflemod_sleeveAtlas",
    pos = { x = 2, y = 0 },
    config = { extra = {
        joker = "j_wafflemod_trophy_hunters_tricorn",
        voucher = "v_wafflemod_hunting_license",
        bonus_edition = "e_polychrome"
    } },
    loc_vars = function(self, info_queue)
        local key, vars
        if self.get_current_deck_key() == "b_wafflemod_hunting" then
            key = self.key .. "_alt"
            vars = { localize { key = self.config.extra.voucher, set = "Voucher" }, localize { key = self.config.extra.bonus_edition, set = "Edition" } }
        else
            key = self.key
            vars = { localize { key = self.config.extra.voucher, set = "Voucher" } }
        end
        if not WaffleMod.config.boss_jokers.enabled then
            key = "sleeve_wafflemod_hunting_disabled"
        end
        return { key = key, vars = vars }
    end,
    apply = function(self, back)
        if WaffleMod.config.boss_jokers.enabled then
            if self.get_current_deck_key() == "b_wafflemod_hunting" then
                delay(0.4)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local joker = SMODS.add_card({ key = self.config.extra.joker, edition = self.config.extra.bonus_edition })
                        joker:start_materialize()
                        return true
                    end
                }))
            else
                G.GAME.used_vouchers[self.config.extra.voucher] = true
                G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        Card.apply_to_run(nil, G.P_CENTERS[self.config.extra.voucher])
                        return true
                    end
                }))
            end
        end
    end
}
