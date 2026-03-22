-- Plays the given sound if the "legendary_joker_sounds" config option is true.
-- Otherwise, plays the "otherwise" sound.
-- "sound" will automatically have "wafflemod_" appended to the front.
function WaffleMod.legendary_sound(sound, otherwise)
    if WaffleMod.config.legendary_joker_sounds then
        play_sound("wafflemod_" .. sound)
    else
        play_sound(otherwise or "generic")
    end
end

-- Flip a table of cards and perform a function on each one.
-- This is similar to how cards such as Sigil do it.
-- Each card is passed as the first argument of applyFunc.
function WaffleMod.flipFunctionCards(cards, applyFunc)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.4,
        func = function()
            play_sound('tarot1')
            return true
        end
    }))
    for i = 1, #cards do
        local percent = math.max(1.15 - (i - 0.999) / (#cards - 0.998) * 0.3, 0)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                cards[i]:flip()
                play_sound('card1', percent)
                cards[i]:juice_up(0.3, 0.3)
                return true
            end
        }))
    end
    for i = 1, #cards do
        G.E_MANAGER:add_event(Event({
            func = function()
                applyFunc(cards[i])
                return true
            end
        }))
    end
    delay(0.2)
    for i = 1, #cards do
        local percent = math.max(1.15 - (i - 0.999) / (#cards - 0.998) * 0.3, 0)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                cards[i]:flip()
                play_sound('tarot2', percent, 0.6)
                cards[i]:juice_up(0.3, 0.3)
                return true
            end
        }))
    end
end

function WaffleMod.addLocColor(name, color)
    G.C[name] = color
    local ref_loc_colour = loc_colour
    function loc_colour(_c, _default)
        ref_loc_colour(_c, _default)
        G.ARGS.LOC_COLOURS[name] = G.C[name]
        return G.ARGS.LOC_COLOURS[_c] or _default or G.C.UI.TEXT_DARK
    end
end

-- Respects Credit Card's debt ability
function WaffleMod.canAfford(price)
    return G.GAME.dollars - price > G.GAME.bankrupt_at
end

-- Juices up the blind and plays the light "ba-dunk" sound when a boss blind is triggered.
function WaffleMod.juiceBlindWithSound()
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            SMODS.juice_up_blind()
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.06 * G.SETTINGS.GAMESPEED,
                blockable = false,
                blocking = false,
                func = function()
                    play_sound('tarot2', 0.76, 0.4); return true
                end
            }))
            play_sound('tarot2', 1, 0.4)
            return true
        end)
    }))
end

-- If checkConfig evaluates to false (or nil), adds the "disabled" tooltip to the passed info_queue.
function WaffleMod.addDisabledTooltip(info_queue, checkConfig)
    if not checkConfig then
        info_queue[#info_queue + 1] = { key = 'wafflemod_disabled_tooltip', set = 'Other', config = {} }
    end
end

-- Will only get visible poker hands (i.e. will not get secret hands that have not yet been played)
function WaffleMod.getRandomHand(pseudorandom_seed)
    local _poker_hands = {}
    for handname, _ in pairs(G.GAME.hands) do
        if SMODS.is_poker_hand_visible(handname) then
            _poker_hands[#_poker_hands + 1] = handname
        end
    end
    return pseudorandom_element(_poker_hands, pseudorandom_seed)
end

-- Returns the name of the most played hand, as well as the amount of times it has been played.
function WaffleMod.getMostPlayedHand()
    local _handname, _played = 'High Card', 0
    for hand_key, hand in pairs(G.GAME.hands) do
        if hand.played > _played then
            _played = hand.played
            _handname = hand_key
        end
    end
    return _handname, _played
end

-- Returns the key of the current deck.
function WaffleMod.getCurrentBack()
    return G.GAME.selected_back.effect.center.key
end

-- Returns true if key matches the key of the current deck.
function WaffleMod.usingBack(key)
    return G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect and G.GAME.selected_back.effect.center and
    G.GAME.selected_back.effect.center.key == key
end

-- Returns true if at least one card with the given enhancement exists in the deck.
function WaffleMod.isEnhancementInDeck(enhancement_key)
    for _, playing_card in ipairs(G.playing_cards or {}) do
        if SMODS.has_enhancement(playing_card, enhancement_key) then
            return true
        end
    end
    return false
end

-- Returns true if at least one card with the given enhancement is held in hand.
function WaffleMod.isEnhancementInHand(enhancement_key)
    for _, playing_card in ipairs(G.hand or {}) do
        if SMODS.has_enhancement(playing_card, enhancement_key) then
            return true
        end
    end
    return false
end

-- As in whether it's in the collection *UI*, i.e. when you're viewing a card in the collection
function WaffleMod.isCardInCollection(card)
    if G.your_collection then
        for i, v in pairs(G.your_collection) do
            if v.cards then
                for _, w in pairs(v.cards) do
                    if w == card then
                        return true
                    end
                end
            end
        end
    end
end

-- Returns true if the given voucher is owned
function WaffleMod.hasVoucher(key)
    if G.GAME.used_vouchers[key] then
        return true
    end
end

-- Returns a random number that is determined by the given seed.
-- Made this as an analog for pseudorandom that does not progress the seed used
local letterToNumber = {
    q = 1,
    w = 2,
    e = 3,
    r = 4,
    t = 5,
    y = 6,
    u = 7,
    i = 8,
    o = 9,
    p = 10,
    a = 11,
    s = 12,
    d = 13,
    f = 14,
    g = 15,
    h = 16,
    j = 17,
    k = 18,
    l = 19,
    z = 20,
    x = 21,
    c = 22,
    v = 23,
    b = 24,
    n = 25,
    m = 26,
}
function WaffleMod.frozenRandom(seed)
    for letter, number in pairs(letterToNumber) do
        seed = seed:gsub(string.upper(letter), tostring(number))
    end
    seed = tonumber(seed) or 0
    return seed
end

-- Gets the number of suits. Useful if other mods add more than the normal 4.
function WaffleMod.getSuitCount()
    local count = 0
    for _, v in pairs(SMODS.Suits) do
        count = count + 1
    end
    return count
end

-- Checks if the context is the main end of round context (and not game_over)
function WaffleMod.endOfRoundContext(context)
    return context.end_of_round and context.main_eval and context.game_over == false
end

function WaffleMod.blightedMakePerishable(card)
    if card.ability.set == "Joker" then
        card.ability.eternal = false
        card:add_sticker("perishable", true)
    end
end

function WaffleMod.selectRandomTag()
    
local tag_pool = get_current_pool('Tag')
local selected_tag = pseudorandom_element(tag_pool, 'modprefix_seed')
local it = 1
while selected_tag == 'UNAVAILABLE' do
    it = it + 1
    selected_tag = pseudorandom_element(tag_pool, 'modprefix_seed_resample'..it)
end
return selected_tag

end

WaffleMod.calculateFunctions = {}
function WaffleMod.bindToModCalculate(func, name)
    if name then
        WaffleMod.calculateFunctions[name] = func
    else
        table.insert(WaffleMod.calculateFunctions, func)
    end
end

function SMODS.current_mod.calculate(self, context)
    local retTable
    local curExtra
    for _, func in pairs(WaffleMod.calculateFunctions) do
        local returnEffect = func(context)
        if returnEffect then
            if not retTable then
                retTable = returnEffect
            elseif curExtra then
                curExtra.extra = returnEffect
            end
            curExtra = returnEffect
        end
    end
    return retTable
end

function SMODS.current_mod.calc_dollar_bonus()
    return 5
end

-- i am far too used to luau and its capabilities
table.find = function(tab, findThis)
    for i, v in pairs(tab) do
        if findThis == v then
            return i
        end
    end
end
