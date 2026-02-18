SMODS.Atlas {
    key = "blinds",
    path = "blind_chips.png",
    px = 34,
    py = 34,
    atlas_table = "ANIMATION_ATLAS"
}

-- The Axe
SMODS.Blind {
    key = "axe",
    loc_txt = {
        name = "The Axe",
        text = {
            "Discards cost $3"
        }
    },
    atlas = "blinds",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 1 },
    boss = { min = 3 },
    boss_colour = HEX('645B3D'),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.pre_discard then
                G.E_MANAGER:add_event(Event {
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        ease_dollars(-3)
                        WaffleMod.juiceBlindWithSound()
                        return true
                    end
                })
                --  blind.triggered = true
                --- return true
            end
        end
    end
}

-- The Gate
SMODS.Blind {
    boss_colour = HEX("8F7EA0"),
    key = "gate",
    loc_txt = {
        name = "The Gate",
        text = {
            "Played cards lose",
            "their enhancements"
        }
    },
    boss = { min = 2 },
    atlas = "blinds",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 2 },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.before then
                for i = 1, #G.play.cards do
                    local thisCard = G.play.cards[i]

                    local isEnhanced = false

                    local enhancements = SMODS.get_enhancements(thisCard)

                    for _, has in pairs(enhancements) do
                        if has then
                            print("enhanced")
                            isEnhanced = true
                        end
                    end

                    if isEnhanced then
                        blind.triggered = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                thisCard:juice_up()
                                return true
                            end,
                            blocking = false
                        }))
                        thisCard:set_ability('c_base', nil, true)
                        --delay(0.02)
                    end
                end

                if blind.triggered then
                    WaffleMod.juiceBlindWithSound()
                    -- delay(0.4)
                end
            end
        end
    end
}

-- The Tail
SMODS.Blind {
    key = "tail",
    boss_colour = HEX("89AF7D"),
    loc_txt = {
        name = "The Tail",
        text = {
            "Decrease rank of",
            "played cards by 1"
        }
    },
    boss = { min = 1 },
    atlas = "blinds",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 3 },
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.before then
                WaffleMod.flipFunctionCards(G.play.cards, function(card)
                    SMODS.modify_rank(card, -1)
                end)
                blind.triggered = true
                delay(0.2)
                if blind.triggered then
                    WaffleMod.juiceBlindWithSound()
                end
                delay(0.4)
            end
        end
    end
}
