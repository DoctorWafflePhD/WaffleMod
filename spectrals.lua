SMODS.Atlas {
    key = "wafflemod_spectralAtlas",
    path = "spectrals.png",
    px = 71,
    py = 95,
}

WaffleMod.SealSpectral = SMODS.Consumable:extend {
    set = "Spectral",
    atlas = "wafflemod_spectralAtlas",
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal(card.ability.extra.seal, nil, true)
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}

-- Egregore
SMODS.Consumable {
    key = "egregore",
    set = "Spectral",
    atlas = "wafflemod_spectralAtlas",
    pos = { x = 2, y = 0 },
    config = {
        max_highlighted = 1,
        extra = {
            seal = "wafflemod_ivory"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal(card.ability.extra.seal, nil, true)
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}

-- Mammon
WaffleMod.SealSpectral {
    key = "mammon",
    set = "Spectral",
    atlas = "wafflemod_spectralAtlas",
    config = {
        max_highlighted = 1,
        extra = {
            seal = "wafflemod_copper"
        }
    },
}

-- Psychopomp
SMODS.Consumable {
    key = "psychopomp",
    set = "Spectral",
    atlas = "wafflemod_spectralAtlas",
    pos = { x = 3, y = 0 },
    config = {
        max_highlighted = 1,
        extra = {
            seal = "wafflemod_ebony"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal(card.ability.extra.seal, nil, true)
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
}

-- Ritual
SMODS.Consumable {
    key = "ritual",
    set = "Spectral",
    atlas = "wafflemod_spectralAtlas",
    config = {
        extra = {
            odds = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    pos = { x = 1, y = 0 },
    use = function(self, card, area)
        local used_tarot = card

        local cardsThatGetEnhanced = {}

        -- use animation
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))

        -- Determine which cards get enhanced
        local numSelected = 1
        for i = 1, #G.hand.cards do
            if pseudorandom('ritualRng') < G.GAME.probabilities.normal / card.ability.extra.odds then
                cardsThatGetEnhanced[numSelected] = G.hand.cards[i]
                numSelected = numSelected + 1
            end
        end

        --print(#cardsThatGetEnhanced)

        for i = 1, #cardsThatGetEnhanced do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    cardsThatGetEnhanced[i]:flip()
                    play_sound('card1', percent)
                    cardsThatGetEnhanced[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        for i = 1, #cardsThatGetEnhanced do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local randomEnhancementToApply = pseudorandom_element(G.P_CENTER_POOLS["Enhanced"])
                    cardsThatGetEnhanced[i]:set_ability(randomEnhancementToApply.key)
                    --assert(SMODS.change_base(_card, _suit.key))
                    return true
                end
            }))
        end

        for i = 1, #cardsThatGetEnhanced do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    cardsThatGetEnhanced[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    cardsThatGetEnhanced[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        -- Unlucky!
        -- Just for feedback that it's not bugged
        if #cardsThatGetEnhanced == 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = used_tarot,
                        backdrop_colour = G.C.SECONDARY_SET.Spectral,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
}

-- Syzygy
WaffleMod.SealSpectral {
    key = "syzygy",
    set = "Spectral",
    atlas = "wafflemod_spectralAtlas",
    config = {
        max_highlighted = 1,
        extra = {
            seal = "wafflemod_viridian"
        }
    },
}