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
                G.E_MANAGER:add_event(Event{
                    func = function ()
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
    if self == G.pack_cards or self == G.shop_jokers or (self == G.jokers and not card:is_rarity(4)) and G.GAME.selected_sleeve == "b_wafflemod_blighted" then
        WaffleMod.blightedMakePerishable(card)
    end
    emplaceRef(self, card, flipped)
end
