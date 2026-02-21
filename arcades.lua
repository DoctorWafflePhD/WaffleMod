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

local function addArcadeHint(info_queue)
    WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.arcade_cabinets.enabled)
    if next(SMODS.find_card("j_perkeo")) then
        info_queue[#info_queue + 1] = { key = 'wafflemod_arcade_hint_perkeo', set = 'Other', config = {} }
    else
        info_queue[#info_queue + 1] = { key = 'wafflemod_arcade_hint', set = 'Other', config = {} }
    end
end

-- Asteroids

-- Space Invaders
SMODS.Consumable {
    key = "space_invaders",
    set = "wafflemod_arcade",
    atlas = "wafflemod_arcadeAtlas",
    pos = { x = 2, y = 0 },
    cost = 4,
    config = { extra = {
        use_cost = 3,
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        return { vars = { card.ability.extra.use_cost } }
    end,
    keep_on_use = function(self, card)
        return true
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

-- Pac-Man
SMODS.Consumable {
    key = "pacman",
    set = "wafflemod_arcade",
    atlas = "wafflemod_arcadeAtlas",
    pos = { x = 0, y = 0 },
    cost = 4,
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
    keep_on_use = function(self, card)
        return true
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

-- Dig Dug
SMODS.Consumable {
    key = "dig_dug",
    set = "wafflemod_arcade",
    atlas = "wafflemod_arcadeAtlas",
    pos = { x = 1, y = 0 },
    cost = 4,
    config = { extra = {
        target_enhancement = "m_stone",
        use_cost = 3,
        target_interval = 5,
        cards_needed = 5
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.target_enhancement]
        return { vars = { card.ability.extra.use_cost, card.ability.extra.target_interval, card.ability.extra.cards_needed } }
    end,
    keep_on_use = function(self, card)
        return true
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
        if context.before then
            for _, c in pairs(context.full_hand) do
                if SMODS.has_enhancement(c, "m_stone") then
                    extra.cards_needed = extra.cards_needed - 1
                    if extra.cards_needed <= 0 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        print("make tarot lalalala")
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
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
                                SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                                    card)
                                return true
                            end)
                        }))

                        extra.cards_needed = 2
                    end
                end
            end
        end
    end
}

-- Polybius
SMODS.Consumable {
    key = "polybius",
    set = "Spectral",
    atlas = "wafflemod_arcadeAtlas",
    pos = { x = 3, y = 0 },
    config = { extra = {
        edition = "e_negative",
        use_cost = 6,
        mult = 6
    } },
    loc_vars = function(self, info_queue, card)
        addArcadeHint(info_queue)
        return { vars = { card.ability.extra.use_cost, card.ability.extra.mult } }
    end,
    hidden = true,
    soul_set = "wafflemod_arcade",
    keep_on_use = function(self, card)
        return true
    end,
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
        return G.hand and #G.hand.highlighted == 1 and WaffleMod.canAfford(card.ability.extra.use_cost) and not G.hand.highlighted[1].edition
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
