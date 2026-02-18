SMODS.Atlas {
    key = "wafflemod_sleeveAtlas",
    path = "xmod/sleeves.png",
    px = 73,
    py = 95,
}

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
