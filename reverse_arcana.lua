SMODS.Atlas {
    key = "wafflemod_rxAtlas",
    path = "reverse_arcana.png",
    px = 71,
    py = 95,
}

local function rxBadge(self, card, badges)
    badges[#badges + 1] = create_badge(localize('k_wafflemod_tarot_rx'),
        G.C.SECONDARY_SET.Tarot, G.C.WHITE,
        1.2)
end

local numReversed = 5
local replaceChance = 1 / (20 * numReversed)
local soulRate = 0
local replaceChance = 1

local reverseDictionary = {

    -- Upright -> Rx
    c_fool = "c_wafflemod_fool_rx",
    c_magician = "c_wafflemod_magician_rx",
    c_high_priestess = "c_wafflemod_high_priestess_rx",
    c_wheel_of_fortune = "c_wafflemod_wheel_of_fortune_rx",
    c_temperance = "c_wafflemod_temperance_rx",

    -- Rx -> Upright
    c_wafflemod_fool_rx = "c_fool",
    c_wafflemod_magician_rx = "c_magician",
    c_wafflemod_high_priestess_rx = "c_high_priestess",
    c_wafflemod_wheel_of_fortune_rx = "c_wheel_of_fortune",
    c_wafflemod_temperance_rx = "c_temperance"

}

-- 0 - The Fool?
SMODS.Consumable {
    key = "fool_rx",
    set = "Tarot",
    atlas = "wafflemod_rxAtlas",
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.reverse_arcana.enabled)
    end,
    hidden = true,
    set_card_type_badge = rxBadge,
    soul_rate = soulRate,
    soul_set = 'Tarot',
    use = function(self, card, area, copier)
        local cardsToReverse = {}

        local function getCardsInArea(area)
            if area and area.cards then
                for _, consumable in pairs(area.cards) do
                    local consumableKey = consumable.config.center.key
                    local getReversed = reverseDictionary[consumableKey]

                    if getReversed then
                        consumable.config.tempTurnIntoThisPlease = getReversed
                        table.insert(cardsToReverse, consumable)
                    end
                end
            end
        end

        getCardsInArea(G.consumeables)
        getCardsInArea(G.pack_cards)

        WaffleMod.flipFunctionCards(cardsToReverse, function(consumable)
            consumable:set_ability(consumable.config.tempTurnIntoThisPlease)
            consumable.config.tempTurnIntoThisPlease = nil
        end)
    end,
    can_use = function(self, card)
        local function checkAreaForTarot(area)
            if area and area.cards then
                for _, consumable in pairs(area.cards) do
                    if consumable.config.center.set == "Tarot" and consumable ~= card then
                        return true
                    end
                end
            end
        end
        return checkAreaForTarot(G.consumeables) or checkAreaForTarot(G.pack_cards)
    end,
}

-- I - The Magician?
-- TODO: probably find a different effect for this, not too happy w/it
SMODS.Consumable {
    key = "magician_rx",
    set = "Tarot",
    atlas = "wafflemod_rxAtlas",
    pos = { x = 1, y = 0 },
    config = { extra = {
        repetitions_added = 1,
        max_highlighted = 2,
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS['m_lucky']
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.reverse_arcana.enabled)
        return { vars = { card.ability.extra.repetitions_added, card.ability.extra.max_highlighted } }
    end,
    set_card_type_badge = rxBadge,
    hidden = true,
    soul_rate = soulRate,
    soul_set = 'Tarot',
    use = function(self, card, area, copier)
        for _, v in pairs(G.hand.highlighted) do
            v:juice_up()
            v.ability.perma_repetitions = (v.ability.perma_repetitions or 0) + 1
        end
        play_sound('timpani')
    end,
    can_use = function(self, card)
        if G.hand and G.hand.highlighted then
            local numSelected = #G.hand.highlighted
            if numSelected > 0 and numSelected <= card.ability.extra.max_highlighted then
                for _, v in pairs(G.hand.highlighted) do
                    if not SMODS.has_enhancement(v, "m_lucky") then
                        return false
                    end
                end
                return true
            else
                return false
            end
        else
            return false
        end
    end,
    in_pool = function(self, args)
        return WaffleMod.isEnhancementInDeck("m_lucky")
    end
}

-- II - The High Priestess?
SMODS.Consumable {
    key = "high_priestess_rx",
    set = "Tarot",
    atlas = "wafflemod_rxAtlas",
    pos = { x = 2, y = 0 },
    config = { extra = {
        levels = 3
    } },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.reverse_arcana.enabled)
        local locVar
        do
            if WaffleMod.isCardInCollection(card) then
                locVar = localize("ph_most_played")
            else
                locVar = localize(WaffleMod.getMostPlayedHand(), 'poker_hands')
            end
        end
        return { vars = { locVar, card.ability.extra.levels } }
    end,
    set_card_type_badge = rxBadge,
    hidden = true,
    soul_rate = soulRate,
    soul_set = 'Tarot',
    use = function(self, card, area, copier)
        local mostPlayed = WaffleMod.getMostPlayedHand()
        SMODS.smart_level_up_hand(card, mostPlayed, false, card.ability.extra.levels)
    end,
    can_use = function(self, card)
        return true
    end
}

-- X - Wheel of Fortune?
SMODS.Consumable {
    key = "wheel_of_fortune_rx",
    set = "Tarot",
    atlas = "wafflemod_rxAtlas",
    pos = { x = 10, y = 0 },
    config = { extra = { odds = 4 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_negative', set = 'Edition', config = { extra = 1 } }
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
            'wafflemod_wheel_rx_activate')
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.reverse_arcana.enabled)
        return { vars = { numerator, denominator } }
    end,
    set_card_type_badge = rxBadge,
    hidden = true,
    soul_rate = soulRate,
    soul_set = 'Tarot',
    use = function(self, card, area, copier)
        -- Determine if the 1 in 6 activated
        if SMODS.pseudorandom_probability(card, 'wafflemod_wheel_rx_activate', 1, card.ability.extra.odds) then
            -- Choose between adding negative (true) or destroying (false)
            local goodThing = pseudorandom('wafflemod_wheel_rx_goodorbad') < 0.5

            -- Get valid destructible jokers
            local destructible_jokers = {}
            for _, joker in pairs(G.jokers.cards) do
                if not SMODS.is_eternal(joker, card) and not joker.getting_sliced then
                    table.insert(destructible_jokers, joker)
                end
            end

            -- If we're adding negative (or if no jokers can be destroyed!)
            if goodThing or #destructible_jokers == 0 then
                local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
                local eligible_card = pseudorandom_element(editionless_jokers, 'wafflemod_wheel_rx_selection')
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        eligible_card:set_edition("e_negative", true)
                        return true
                    end
                }))
            else -- Destroy a random joker
                local whichJokerDestroyed = pseudorandom_element(destructible_jokers, 'wafflemod_wheel_rx_selection')
                G.E_MANAGER:add_event(Event({
                    func = function()
                        whichJokerDestroyed:start_dissolve({ G.C.DARK_EDITION }, nil, 1.6)
                        return true
                    end
                }))
            end
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
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
        return next(SMODS.Edition:get_edition_cards(G.jokers, true))
    end
}

-- XIV - Temperance?
SMODS.Consumable {
    key = "temperance_rx",
    set = "Tarot",
    atlas = "wafflemod_rxAtlas",
    pos = { x = 3, y = 1 },
    config = { extra = { value_multiplier = 3 } },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.reverse_arcana.enabled)
        return { vars = { card.ability.extra.value_multiplier } }
    end,
    set_card_type_badge = rxBadge,
    hidden = true,
    soul_rate = soulRate,
    soul_set = 'Tarot',
    use = function(self, card, area, copier)
        local jokerToSell = G.jokers.highlighted[1]
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                jokerToSell:start_dissolve({ G.C.MONEY }, nil, 1.6)
                delay(0.4)
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_dollars(jokerToSell.sell_cost * card.ability.extra.value_multiplier, true)
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return G.jokers and G.jokers.highlighted and #G.jokers.highlighted == 1
    end
}

-- XXIII - The Artist?
SMODS.Consumable {
    key = "artist_rx",
    set = "Tarot",
    atlas = "wafflemod_tarotsAtlas",
    pos = { x = 1, y = 1 },
    config = { extra = { value_multiplier = 3 } },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.reverse_arcana.enabled)
        return { vars = { card.ability.extra.value_multiplier } }
    end,
    set_card_type_badge = rxBadge,
    hidden = true,
    soul_rate = soulRate,
    soul_set = 'Tarot',

    use = function(self, card, area, copier)
        for _, v in pairs(G.hand.cards) do
            if v:is_face() then
                SMODS.destroy_cards(v)
            end
        end
    end,
    can_use = function(self, card)
        local anyFacesInHand = false
        do
            for _, v in pairs(G.hand.cards) do
                if v:is_face() then
                    anyFacesInHand = true
                end
            end
        end

        return anyFacesInHand
    end
}

-- Add reverse arcana to table
WaffleMod.rxTarots = {
    "c_wafflemod_fool_rx",
    "c_wafflemod_magician_rx",
    "c_wafflemod_high_priestess_rx",
    "c_wafflemod_wheel_of_fortune_rx",
    "c_wafflemod_temperance_rx",
    "c_wafflemod_artist_rx"
}

local function attemptToReverseCard(card)
    if WaffleMod.config.reverse_arcana.enabled then
        local getReplacement = reverseDictionary[card.config.center.key]
        if getReplacement then
            print("this card has a reversed form")
            local getInPoolFunc = G.P_CENTERS[getReplacement].in_pool
            local inPool
            if getInPoolFunc then
                inPool = getInPoolFunc()
            else
                inPool = true
            end
            if inPool and pseudorandom("wafflemod_rx_replace") <= replaceChance then
                print("roll successful")
                card:set_ability(getReplacement)
            end
        end
    end
end
-- Attempt to reverse tarot cards as they appear in booster packs or shop
local emplaceRef = CardArea.emplace
function CardArea.emplace(self, card)
    if self == G.pack_cards or self == G.shop_jokers then
        attemptToReverseCard(card)
    end
    emplaceRef(self, card)
end
