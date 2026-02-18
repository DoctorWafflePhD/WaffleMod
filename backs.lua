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