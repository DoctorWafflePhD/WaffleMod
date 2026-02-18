    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local didActivate = false
            for _, playedCard in pairs(context.scoring_hand) do
                if SMODS.has_enhancement(playedCard, card.ability.extra.target_enhancement) then
                    didActivate = true
                    playedCard:set_ability('c_base', nil, true)
                    playedCard:set_seal(card.ability.extra.seal, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            playedCard:juice_up()
                            return true
                        end
                    }))

                end
            end
            if didActivate then
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MONEY,
                }
            end
        end
    end