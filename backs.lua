----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas {
    key = "wafflemod_deckAtlas",
    path = "decks.png",
    px = 71,
    py = 95,
}

-- Waffle Deck
SMODS.Back {
    key = "waffle",
    atlas = "wafflemod_deckAtlas",
    pos = { x = 0, y = 0 },
    unlocked = true,
    config = {
        extra = {
            odds = 5
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { (G.GAME.probabilities.normal or 1), self.config.extra.odds } }
    end,
    calculate = function(self, back, context)
        if context.create_shop_card then
            local isJoker = context.set == "Joker"

            if isJoker then
                local rollToReplace = SMODS.pseudorandom_probability(back, "waffleDeckJokerRng", 1,
                    self.config.extra.odds)
                if rollToReplace then
                    --print("replaced a joker")
                    return {
                        shop_create_flags = {
                            set = "wafflemod_jokers"
                        }
                    }
                else
                    -- print("chance failed")
                end
            else
                --print("not joker")
            end
        end
    end
}

-- Blighted Deck
SMODS.Back {
    key = "blighted",
    atlas = "wafflemod_deckAtlas",
    pos = { x = 2, y = 0 },
    config = {
        vouchers = { "v_clearance_sale" },
        extra = {
            debuffed_sales_needed = 4,
            joker_slot_gain = 1
        }
    },
    loc_vars = function(self, info_queue)
        local remaining = self.config.extra.debuffed_sales_needed
        if G.GAME then
            remaining = remaining - (G.GAME.debuffed_joker_sales or 0) % remaining
        end
        return {
            vars = {
                self.config.extra.joker_slot_gain, self.config.extra.debuffed_sales_needed, remaining
            }
        }
    end,
    calculate = function(self, back, context)
        -- if context.modify_shop_card and context.card.ability.set == "Joker" then
        --     makePerishable(context.card)
        -- end
        -- if context.open_booster and G.pack_cards and G.pack_cards.cards then
        --     for _, card in pairs(G.pack_cards.cards) do
        --         if card.ability.set == "Joker" then
        --             makePerishable(card)
        --         end
        --     end
        -- end
        if context.selling_card then
            if context.card.debuff and context.card.ability.set == "Joker" then
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
function CardArea.emplace(self, card, ...)
    if G.GAME and WaffleMod.getCurrentBack() == "b_wafflemod_blighted" and (self == G.pack_cards or self == G.shop_jokers or (self == G.jokers and not card:is_rarity(4))) then
        WaffleMod.blightedMakePerishable(card)
    end
    emplaceRef(self, card, ...)
end

-- Hunting Deck
SMODS.Back {
    key = "hunting",
    config = {
        extra = {
            voucher = "v_wafflemod_hunting_license",
            joker = "j_wafflemod_trophy_hunters_tricorn"
        },
    },
    loc_vars = function(self, info_queue)
        local key
        if WaffleMod.config.boss_jokers.enabled then
            key = "b_wafflemod_hunting"
        else
            key = "b_wafflemod_hunting_disabled"
        end
        return { key = key }
    end,
    atlas = "wafflemod_deckAtlas",
    pos = { x = 3, y = 0 },
    unlocked = true,
    apply = function(self, back) -- IK config alone can be used for the voucher & joker but this is for the configuration check functionality
        if WaffleMod.config.boss_jokers.enabled then

            G.GAME.used_vouchers[self.config.extra.voucher] = true
            G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
            G.E_MANAGER:add_event(Event({ -- Adding back objects of any type from a deck MUST be done within an event
                func = function()
                    Card.apply_to_run(nil, G.P_CENTERS[self.config.extra.voucher])
                    return true
                end
            }))

            delay(0.4)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.GAME.selected_sleeve ~= "sleeve_wafflemod_hunting" then -- THT creation if matching sleeve is used is handled in sleeves.lua
                    local joker = SMODS.add_card({key = self.config.extra.joker, no_edition = true})
                    joker:start_materialize()
                end
                return true
            end
        }))

        end
    end
}

-- Patchwork Deck
local juryRiggedDebuffedJokerCount = 1 -- Defined here for access in later hook
SMODS.Back {
    key = "patchwork",
    atlas = "wafflemod_deckAtlas",
    pos = { x = 1, y = 0 },
    config = {
        joker_slot = 1,
        debuffed_slots = juryRiggedDebuffedJokerCount
    },
    unlocked = true,
    loc_vars = function(self, info_queue)
        return { vars = { self.config.joker_slot, self.config.debuffed_slots } }
    end
}
-- Patchwork update hook (this disables the rightmost joker when using the deck)
local updateRef = Game.update
function Game:update(dt)
    if WaffleMod.usingBack("b_wafflemod_patchwork") and G.jokers and G.jokers.cards then
        local jokerCards = G.jokers.cards

        for i = 1, #jokerCards do
            if i > #jokerCards - juryRiggedDebuffedJokerCount then
                SMODS.debuff_card(jokerCards[i], true, "juryRiggedDebuff")
            else
                SMODS.debuff_card(jokerCards[i], false, "juryRiggedDebuff")
            end
        end
    end


    return updateRef(self, dt)
end
