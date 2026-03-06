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
        return {vars = {(G.GAME.probabilities.normal or 1), self.config.extra.odds}}
    end,
    calculate = function (self, back, context)
        if context.create_shop_card then
            
            local isJoker = context.set == "Joker"

            if isJoker then
                local rollToReplace = SMODS.pseudorandom_probability(back, "waffleDeckJokerRng", 1, self.config.extra.odds)
                if rollToReplace then
                   --print("replaced a joker")
                    return{
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
local function makePerishable(card)
    card.ability.eternal = false
    if card.ability.set == "Joker" then
        card:add_sticker("perishable", true)
    end
end
SMODS.Back {
    key = "blighted",
    atlas = "wafflemod_deckAtlas",
    pos = {x = 2, y = 0},
    config = {
        vouchers = {"v_clearance_sale"},
        extra = {
            debuffed_sales_needed = 4,
            joker_slot_gain = 1
        }
    },
    loc_vars = function (self, info_queue)
        local remaining = self.config.extra.debuffed_sales_needed
        if G.GAME then
            remaining = remaining - (G.GAME.debuffed_joker_sales or 0) % remaining
        end
        return {vars = {
            self.config.extra.joker_slot_gain, self.config.extra.debuffed_sales_needed, remaining
        }}
    end,
    calculate = function (self, back, context)
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
function CardArea.emplace(self, card)
    if self == G.pack_cards or self == G.shop_jokers or (self == G.jokers and not card:is_rarity(4)) and WaffleMod.getCurrentBack() == "b_wafflemod_blighted" then
        makePerishable(card)
    end
    emplaceRef(self, card)
end


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
-- Patchwork update hook (this disables the rightmost joker)
local updateRef = Game.update
function Game:update(dt)
    
    if WaffleMod.usingBack("b_wafflemod_juryrigged") and G.jokers and G.jokers.cards then
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