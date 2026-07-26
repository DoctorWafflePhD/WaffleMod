SMODS.Atlas {
    key = "wafflemod_arcadeAtlas",
    path = "arcades.png",
    px = 71,
    py = 95,
}

SMODS.ConsumableType {
    key = "wafflemod_arcade",
    default = "c_wafflemod_pacman",
    secondary_colour = HEX("403B87"),
    primary_colour = HEX("B270D3"),
    collection_rows = { 5, 5 },
    shop_rate = 0,
    select_card = "consumeables"
}

SMODS.UndiscoveredSprite {
    key = "wafflemod_arcade",
    atlas = "wafflemod_arcadeAtlas",
    pos = { x = 0, y = 0 }
}

local function addArcadeHint(info_queue)
    WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.arcade_cabinets.enabled)
    if next(SMODS.find_card("j_perkeo")) then
        info_queue[#info_queue + 1] = { key = 'wafflemod_arcade_hint_perkeo', set = 'Other', config = {} }
    else
        info_queue[#info_queue + 1] = { key = 'wafflemod_arcade_hint', set = 'Other', config = {} }
    end
end

local doHeldEffects = WaffleMod.config.arcade_cabinets.held_effects

WaffleMod.ArcadeCabinet = SMODS.Consumable:extend {
    set = "wafflemod_arcade",
    atlas = "wafflemod_arcadeAtlas",
    cost = 5,
    keep_on_use = function(self, card)
        return true
    end,
}

-- (Sorted by release date)

-- Asteroids

-- Space Invaders (1979)
WaffleMod.ArcadeCabinet {
    key = "space_invaders",
    pos = { x = 3, y = 0 },
    config = { extra = {
        use_cost = 3,
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        return { vars = { card.ability.extra.use_cost } }
    end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = "0.2",
            blocking = false,
            func = function()
                card:juice_up()
                return true
            end
        }))
        delay(0.2)
        ease_dollars(-card.ability.extra.use_cost)
        SMODS.add_card { set = "Planet", area = G.consumeables }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == "Planet" then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = "0.2",
                blocking = false,
                func = function()
                    SMODS.smart_level_up_hand(card, WaffleMod.getRandomHand("wafflemod_space_invaders_hand"), false)
                    return true
                end
            }))
        end
    end
}

-- Pac-Man (1980)
WaffleMod.ArcadeCabinet {
    key = "pacman",
    pos = { x = 1, y = 0 },
    config = { extra = {
        conv_enhancement = "m_wild",
        use_cost = 3,
        xmult = 1.75,
        suit_cache = {},
        scored_wilds = {},
        num_scored_suits = 0
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.conv_enhancement]
        return { vars = { card.ability.extra.use_cost, card.ability.extra.xmult } }
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted == 1 and WaffleMod.canAfford(card.ability.extra.use_cost)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = "0.2",
            blocking = false,
            func = function()
                card:juice_up()
                return true
            end
        }))
        WaffleMod.flipFunctionCards(G.hand.highlighted, function(c)
            c:set_ability(card.ability.extra.conv_enhancement)
        end)
        delay(0.2)
        ease_dollars(-card.ability.extra.use_cost)
    end,
    calculate = function(self, card, context)
        local extra = card.ability.extra
        if context.before then
            extra.scored_wilds = {}
            extra.num_scored_suits = 0
            extra.suit_cache = {}
        end
        if context.individual and context.cardarea == G.play then
            local isWild = SMODS.has_enhancement(context.other_card, "m_wild")
            if isWild then
                if extra.num_scored_suits < WaffleMod.getSuitCount() and not extra.scored_wilds[context.other_card] then
                    extra.scored_wilds[context.other_card] = true
                    extra.num_scored_suits = extra.num_scored_suits + 1
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
                extra.suit_cache.wildCount = (extra.suit_cache.wildCount or 0) + 1
            elseif not SMODS.has_no_suit(context.other_card) and not extra.suit_cache[context.other_card.base.suit] and extra.num_scored_suits < WaffleMod.getSuitCount() then
                extra.suit_cache[context.other_card.base.suit] = true
                extra.num_scored_suits = extra.num_scored_suits + 1
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end
}

-- Dig Dug (February 1982)
WaffleMod.ArcadeCabinet {
    key = "dig_dug",
    pos = { x = 2, y = 0 },
    config = { extra = {
        target_enhancement = "m_stone",
        use_cost = 3,
        target_interval = 3,
        cards_needed = 3
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.target_enhancement]
        return { vars = { card.ability.extra.use_cost, card.ability.extra.target_interval, card.ability.extra.cards_needed } }
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted == 1 and WaffleMod.canAfford(card.ability.extra.use_cost)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = "0.2",
            blocking = false,
            func = function()
                card:juice_up()
                return true
            end
        }))
        WaffleMod.flipFunctionCards(G.hand.highlighted, function(c)
            c:set_ability(card.ability.extra.target_enhancement)
        end)
        delay(0.2)
        ease_dollars(-card.ability.extra.use_cost)
    end,
    calculate = function(self, card, context)
        local extra = card.ability.extra
        if context.individual and SMODS.has_enhancement(context.other_card, "m_stone") then
            extra.cards_needed = math.max(extra.cards_needed - 1, 0)
            if extra.cards_needed <= 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                --print("make tarot lalalala")
                extra.cards_needed = card.ability.extra.target_interval
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    extra = {
                        message = localize('k_plus_tarot'),
                        message_card = card,
                        colour = G.C.PURPLE,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.add_card {
                                        set = 'Tarot',
                                        key_append = 'wafflemod_dig_dug'
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end
                            }))
                        end
                    }
                }
            end
        end
    end
}

-- Joust (July 1982)
WaffleMod.ArcadeCabinet {
    key = "joust",
    pos = {x = 6, y = 0},
    config = { extra = {
        use_cost = 3,
        price = 3 -- egg on vremade uses this terminology, soooo :b
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        return { vars = { card.ability.extra.use_cost, card.ability.extra.price } }
    end,
    can_use = function(self, card)
        local anyCardsWithRankInHand = false
        for i = 1, #G.hand.cards do
            if not SMODS.has_no_rank(G.hand.cards[i]) then
                anyCardsWithRankInHand = true
            end
        end
        return WaffleMod.canAfford(card.ability.extra.use_cost) and anyCardsWithRankInHand
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = "0.2",
            blocking = false,
            func = function()
                card:juice_up()
                local tempId = 15
                local destroyThisCard = nil
                for i = 1, #G.hand.cards do
                    if not SMODS.has_no_rank(G.hand.cards[i]) and tempId >= G.hand.cards[i]:get_id() then
                        tempId = G.hand.cards[i].base.id
                        destroyThisCard = G.hand.cards[i]
                    end
                end
                if destroyThisCard then
                    SMODS.destroy_cards(destroyThisCard)
                end
                return true
            end
        }))
        ease_dollars(-card.ability.extra.use_cost)
    end,
    calculate = function(self, card, context)
        if doHeldEffects then
            if WaffleMod.endOfRoundContext(context) then
                card.ability.extra_value = card.ability.extra_value or 0 + card.ability.extra.price
                card:set_cost()
                return {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            end
        end
    end
}

-- Metro-Cross (May 1985)
WaffleMod.ArcadeCabinet {
    key = "metro_cross",
    pos = { x = 5, y = 0 },
    config = { extra = {
        create_set = "Spectral",
        use_cost = 3,
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        return { vars = { card.ability.extra.use_cost } }
    end,
    can_use = function(self, card)
        return WaffleMod.canAfford(card.ability.extra.use_cost)
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = "0.2",
            blocking = false,
            func = function()
                card:juice_up()
                add_tag(Tag(WaffleMod.selectRandomTag()))
                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                return true
            end
        }))
        ease_dollars(-card.ability.extra.use_cost)
    end,
    calculate = function(self, card, context)
        if context.skip_blind then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = card.ability.extra.create_set,
                            key_append = 'wafflemod_metro_cross'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                    remove = true
                }
            end
        end
    end
}

-- Polybius (???)
WaffleMod.ArcadeCabinet {
    key = "polybius",
    set = "Spectral",
    atlas = "wafflemod_arcadeAtlas",
    pos = { x = 4, y = 0 },
    cost = 10,
    config = { extra = {
        edition = "e_negative",
        use_cost = 6,
        mult = 6
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        info_queue[#info_queue + 1] = { key = 'e_negative_playing_card', set = 'Edition', config = { extra = 1 } }
        return { vars = { card.ability.extra.use_cost, card.ability.extra.mult } }
    end,
    hidden = true,
    soul_set = "wafflemod_arcade",
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = "0.2",
            blocking = false,
            func = function()
                card:juice_up()
                G.hand.highlighted[1]:set_edition("e_negative")
                ease_dollars(-card.ability.extra.use_cost)
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted == 1 and WaffleMod.canAfford(card.ability.extra.use_cost) and
            not G.hand.highlighted[1].edition
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.edition and context.other_card.edition.key == "e_negative" then
            return { mult = card.ability.extra.mult }
        end
    end,
    in_pool = function()
        return WaffleMod.config.arcade_cabinets.enabled
    end
}
