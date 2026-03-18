local config = WaffleMod.config

SMODS.Atlas {
    key = "wafflemod_jokerAtlas",
    path = "jokers.png",
    px = 71,
    py = 95,
}

-- Common
------------------------------------------------------------------------------------------------------------------------------------------

-- Blueberry Jam
SMODS.Joker {
    key = "blueberry_jam",
    config = {
        extra = {
            mult = 25,
            subtract_mult = 1,
            currentMultRemoval = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.subtract_mult } }
    end,
    rarity = 1,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 1, y = 0 },
    cost = 5,
    calculate = function(self, card, context)
        -- Add mult to score
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end

        -- Lose Mult based on amt of cards in hand
        if context.after and not context.blueprint then
            local multToRemove = #G.hand.cards * card.ability.extra.subtract_mult
            if multToRemove and multToRemove > 0 then
                card.ability.extra.currentMultRemoval = multToRemove * -1
                --print(card.ability.extra.mult, card.ability.extra.currentMultRemoval)
                if card.ability.extra.mult - multToRemove <= 0 then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.RED
                    }
                else
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "mult",
                        scalar_value = "currentMultRemoval",
                        scaling_message = {
                            message = localize { type = 'variable', key = 'a_mult_minus', vars = { multToRemove } },
                            colour = G.C.MULT,
                            message_card = card
                        }
                    })
                end
            end
        end
    end
}

-- Broken Record
SMODS.Joker {
    key = "broken_record",
    config = {
        extra = {
            mult = 0,
            mult_gain = 3,
            hand = nil
        }
    },
    cost = 5,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 5, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before then
            --print(context.scoring_name, card.ability.extra.hand)

            if context.scoring_name == card.ability.extra.hand or card.ability.extra.hand == nil then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_gain",
                    no_message = true
                })
            elseif card.ability.extra.mult > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "mult",
                    scalar_value = "mult_gain",
                    operation = function(ref_table, ref_value, initial, change)
                        ref_table[ref_value] = 0
                    end,
                    no_message = true
                })
                return {
                    message = localize('k_reset')
                }
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end

        if context.after then
            card.ability.extra.hand = context.scoring_name
        end
    end
}

-- Dreamsicle
SMODS.Joker {
    key = "dreamsicle",
    config = { extra = {
        dollars = 2,
        purchases = 6,
        scalar = -1
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.purchases } }
    end,
    rarity = 1,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 2, y = 1 },
    cost = 6,
    eternal_compat = false,
    calculate = function(self, card, context)
        if context.buying_card and not context.buying_self and card.ability.set ~= "Voucher" and context.card ~= card then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "purchases",
                scalar_value = "scalar",
                no_message = true
            })
            if card.ability.extra.purchases <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end,
                    message = localize('k_eaten_ex'),
                    colour = G.C.MONEY
                }
            else
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end
}

-- Fickle Joker
SMODS.Joker {
    key = "fickle",
    config = { extra = {
        chip_gain = 4,
        chip_loss = 1,
        chips = 0,
        target_suit = "Spades",
    } },
    cost = 5,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 5, y = 1 },
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.wafflemod_fickle_suit or {}).suit or 'Spades'
        return { vars = { card.ability.extra.chip_gain, localize(suit, 'suits_singular'), card.ability.extra.chip_loss, card.ability.extra.chips, colours = { G.C.SUITS[suit] } } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.chips > 0 then
            return { chips = card.ability.extra.chips }
        end
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit(G.GAME.current_round.wafflemod_fickle_suit.suit) then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_gain",
                    no_message = true
                })
                return {
                    message = localize { type = 'variable', key = 'a_chips_scale', vars = { card.ability.extra.chip_gain } },
                    colour = G.C.CHIPS,
                    message_card = card
                }
            else
                local startedAt0 = card.ability.extra.chips == 0
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_loss",
                    operation = "-",
                    no_message = true
                })
                card.ability.extra.chips = math.max(card.ability.extra.chips, 0)
                if not startedAt0 then
                    return {
                        message = localize { type = 'variable', key = 'a_chips_scale_minus', vars = { card.ability.extra.chip_loss } },
                        colour = G.C.CHIPS,
                        message_card = card
                    }
                end
            end
        end
    end
}
local function reset_fickle_suit()
    G.GAME.current_round.wafflemod_fickle_suit = G.GAME.current_round.wafflemod_fickle_suit or { suit = 'Spades' }
    local picky_suits = {}
    for k, v in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
        if v ~= G.GAME.current_round.wafflemod_fickle_suit.suit then picky_suits[#picky_suits + 1] = v end
    end
    local picky_card = pseudorandom_element(picky_suits, 'wafflemod_fickle' .. G.GAME.round_resets.ante)
    G.GAME.current_round.wafflemod_fickle_suit.suit = picky_card
end

-- Fountain
SMODS.Joker {
    key = "fountain",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 8, y = 1 },
    config = { extra = {
        dollars = 3,
    } },
    cost = 5,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                G.GAME.probabilities.normal or 1,
                card.ability.extra.dollars
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            SMODS.has_no_rank(context.other_card) ~= true and -- Stone cards have no rank and thus should not count for this
            SMODS.pseudorandom_probability(card, "wafflemod_fountain_roll", 1, context.other_card.base.nominal) then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end
}

-- In the Rough
local function getNumNonDiamondsInFullDeck()
    local numberNonDiamonds = 0
    if not G.playing_cards then -- For cases where there is no G.playing_cards, i.e. viewing in collection
        return 52 - 13
    else
        for _, v in pairs(G.playing_cards) do
            if not v:is_suit("Diamonds") then
                numberNonDiamonds = numberNonDiamonds + 1
            end
        end
    end
    return numberNonDiamonds
end
SMODS.Joker {
    key = "in_the_rough",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 9, y = 1 },
    cost = 5,
    config = {
        extra = {
            suit = "Diamonds",
            xmult_per = 0.05
        }
    },
    loc_vars = function(self, info_queue, card)
        local suit = card.ability.extra.suit
        local nonDiamondCount = getNumNonDiamondsInFullDeck()
        return {
            vars = {
                localize(suit, 'suits_singular'),
                card.ability.extra.xmult_per,
                card.ability.extra.xmult_per * nonDiamondCount,
                colours = { G.C.SUITS[suit] }
            },
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.suit) then
            local is_first_diamond = false
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_suit(card.ability.extra.suit) then
                    is_first_diamond = context.scoring_hand[i] == context.other_card
                    break
                end
            end
            if is_first_diamond then
                return {
                    xmult = card.ability.extra.xmult_per * getNumNonDiamondsInFullDeck()
                }
            end
        end
    end
}

-- Instant Mac & Cheese
SMODS.Joker {
    key = "instant_mac_and_cheese",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 8, y = 0 },
    cost = 4,
    config = {
        extra = {
            hands_needed = 3,
            hands_played = 0,
            levels = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands_needed, card.ability.extra.levels, card.ability.extra.hands_played } }
    end,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    calculate = function(self, card, context)
        if context.after and not context.blueprint then
            card.ability.extra.hands_played = card.ability.extra.hands_played + 1
            if card.ability.extra.hands_played >= card.ability.extra.hands_needed then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.calculate_effect(
                            {
                                message = localize('k_active_ex'),
                                colour = G.C.FILTER,
                            },
                            card)
                        local eval = function(card) return not card.REMOVED end
                        juice_card_until(card, eval, true)
                        return true
                    end
                }))
            end
        end
        if context.before and card.ability.extra.hands_played >= card.ability.extra.hands_needed and not context.blueprint then
            SMODS.smart_level_up_hand(card, context.scoring_name, false, card.ability.extra.levels)
            SMODS.destroy_cards(card, nil, nil, true)
            return {
                message = localize('k_eaten_ex')
            }
        end
    end
}

-- Miner
if false then
    SMODS.Joker {
        key = "miner",
        config = {
            extra = {
                target_enhancement = "m_stone",
                seal = "Gold"
            }
        },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.target_enhancement]
            info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
            return {
                vars = {
                }
            }
        end,
        rarity = 1,
        atlas = "wafflemod_jokerAtlas",
        pos = { x = 3, y = 0 },
        cost = 5,
        blueprint_compat = false,
        calculate = function(self, card, context)
            if context.before and not context.blueprint then
                local didActivate = false
                for _, scoredCard in ipairs(context.scoring_hand) do
                    if SMODS.has_enhancement(scoredCard, card.ability.extra.target_enhancement) and not scoredCard.mined then
                        scoredCard.mined = true
                        scoredCard:set_ability('c_base', nil, true)
                        -- If the below line is moved into the event then it doesn't count as a gold seal card when scored, which kinda sucks :/
                        scoredCard:set_seal(card.ability.extra.seal, true, false)
                        didActivate = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scoredCard.mined = nil
                                scoredCard:juice_up()
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
        end,
        in_pool = function(self, args)
            return WaffleMod.isEnhancementInDeck("m_stone")
        end
    }
end

-- Motley Joker
SMODS.Joker {
    key = "motley",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 9, y = 0 },
    cost = 4,
    config = { extra = {
        chips = 20,
        mult = 2,
        chips_suits = { "Spades", "Clubs" },
        mult_suits = { "Hearts", "Diamonds" }
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        local returnTable = {}
        if context.individual and context.cardarea == G.play then
            for _, suit in pairs(card.ability.extra.chips_suits) do
                if context.other_card:is_suit(suit) then
                    returnTable.chips = card.ability.extra.chips
                    break
                end
            end
            for _, suit in pairs(card.ability.extra.mult_suits) do
                if context.other_card:is_suit(suit) then
                    returnTable.mult = card.ability.extra.mult
                    break
                end
            end
            return returnTable
        end
    end
}

-- Mystery Gift
WaffleMod.mysteryGiftTags = { -- Other mods should be able to add to these tables if they have edition tags of their own
    { name = "e_tag_foil",       weight = 0.5 },
    { name = "e_tag_holo",       weight = 0.35 },
    { name = "e_tag_polychrome", weight = 0.15 },
}
local function removeEditionFromString(str)
    return string.sub(str, 3)
end
SMODS.Joker {
    key = "mystery_gift",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 3, y = 1 },
    config = { extra = {
        odds = 2
    } },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        for _, entry in pairs(WaffleMod.mysteryGiftTags) do
            info_queue[#info_queue + 1] = { key = removeEditionFromString(entry.name), set = 'Tag' }
        end
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if WaffleMod.endOfRoundContext(context) then
            local pr = pseudorandom("wafflemod_mystery_gift_odds")
            --print(pr, G.GAME.probabilities.normal / card.ability.extra.odds)
            local rollForTagCreation = pr < G.GAME.probabilities.normal / card.ability.extra.odds
            if rollForTagCreation then
                -- this is kind of a hacky method since this function is made for editions and not their matching tags but it's a weighted pseudorandom pull from a table so i'm using it
                -- I'm Lazy
                -- if there's a weighted SMODS.pseudorandom_element lmk Roflmao
                local tagToCreate = poll_edition("wafflemod_mystery_gift_selection", nil, true, true,
                    WaffleMod.mysteryGiftTags)
                G.E_MANAGER:add_event(Event {
                    func = function()
                        add_tag(Tag(removeEditionFromString(tagToCreate)))
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        card:juice_up()
                        return true
                    end
                })
            end
        end
    end
}

-- Purple Joker
SMODS.Joker {
    key = "purple",
    config = {
        extra = {
            chips = 0,
            chip_gain = 6
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,
    rarity = 1,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 4, y = 0 },
    cost = 4,
    calculate = function(self, card, context)
        -- Main scoring
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end

        -- Add chips for each card discarded
        if context.discard and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "chips",
                scalar_value = "chip_gain",
                scaling_message = {
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chip_gain } },
                    colour = G.C.CHIPS,
                    message_card = card
                }
            })
        end

        -- Reset after each hand
        if context.after and card.ability.extra.chips > 0 then
            card.ability.extra.chips = 0
            return {
                message = localize('k_reset'),
                colour = G.C.BLUE
            }
        end
    end
}

-- Uncommon
------------------------------------------------------------------------------------------------------------------------------------------

-- Damocles
SMODS.Joker {
    key = "damocles",
    config = {
        extra = {
            dollars = 10,
            odds = 10
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    rarity = 2,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 2, y = 0 },
    cost = 8,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.after and #G.jokers.cards > 1 and not context.blueprint then
            if pseudorandom('wafflemod_damocles_odds') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local destructable_jokers = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= card and not SMODS.is_eternal(G.jokers.cards[i], card) and not G.jokers.cards[i].getting_sliced then
                        destructable_jokers[#destructable_jokers + 1] =
                            G.jokers.cards[i]
                    end
                end
                local joker_to_destroy = pseudorandom_element(destructable_jokers, 'wafflemod_damocles_choose')

                if joker_to_destroy then
                    joker_to_destroy.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            (card):juice_up(0.8, 0.8)
                            play_sound('slice1', 0.96 + math.random() * 0.08)
                            joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                            return true
                        end
                    }))
                else -- Chance to destroy succeeded, but there was nothing eligible to destroy
                    SMODS.calculate_effect(
                        {
                            message = localize('k_safe_ex'),
                        },
                        card
                    )
                end
            else -- Chance to destroy failed
                SMODS.calculate_effect(
                    {
                        message = localize('k_safe_ex'),
                    },
                    card
                )
            end
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

-- Fortune III
SMODS.Joker {
    key = "fortune_iii",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 0, y = 2 },
    config = { extra = {
        target_enhancement = "m_stone",
        repetitions = 1,
        odds = 2
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.target_enhancement]
        return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    rarity = 2,
    cost = 6,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, card.ability.extra.target_enhancement) then
            local repCount = card.ability.extra.repetitions
            if SMODS.pseudorandom_probability(card, "wafflemod_fortune_iii_retrigger", 1, card.ability.extra.odds) then
                repCount = repCount + card.ability.extra.repetitions
            end
            return {
                repetitions = repCount
            }
        end
    end,
    in_pool = function(self, args)
        return WaffleMod.isEnhancementInDeck("m_stone")
    end
}

-- Jok
SMODS.Joker {
    key = "jok",
    config = {
        extra = {
            Xmult = 1,
            Xmult_gain = 0.5
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_tower
        return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
    end,
    rarity = 2,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 1, y = 1 },
    cost = 6,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.config.center.key == "c_tower" then
            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain

            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult },
                    colour = G.C.RED
                }
            }
        end

        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end
    end
}

-- Jokerton
SMODS.Joker {
    key = "jokerton",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 7, y = 1 },
    config = { extra = {
        discard_requirement = 10,
        discards_remaining = 10,
        is_juicing = false,
        conv_enhancement = "m_steel"
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.conv_enhancement]
        return {
            vars = {
                card.ability.extra.discard_requirement,
                card.ability.extra.discards_remaining
            }
        }
    end,
    blueprint_compat = false,
    rarity = 2,
    cost = 5,
    calculate = function(self, card, context)
        local extra = card.ability.extra
        if context.discard and context.other_card:is_suit("Hearts") then
            extra.discards_remaining = math.max(extra.discards_remaining - 1, 0)
            if extra.discards_remaining == 0 and not extra.is_juicing then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.calculate_effect(
                            {
                                message = localize('k_active_ex'),
                                colour = G.C.FILTER,
                            },
                            card)
                        local eval = function(card) return not extra.is_juicing end
                        juice_card_until(card, eval, true)
                        extra.is_juicing = true
                        return true
                    end
                }))
            end
        end
        if extra.is_juicing and context.before then
            if context.scoring_hand and context.scoring_hand[1] then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local convCard = context.scoring_hand[1]
                        convCard:set_ability(extra.conv_enhancement)
                        convCard:juice_up()
                        extra.is_juicing = false
                        extra.discards_remaining = 10
                        return true
                    end
                }))
                return {
                    message = localize('k_wafflemod_steel'),
                    colour = G.C.FILTER,
                }
            end
        end
    end
}

-- Pop Art
SMODS.Joker {
    key = "pop_art",
    atlas = "wafflemod_jokerAtlas",
    pos = {x = 2,y = 2},
    rarity = 2,
    config = {extra = {
        dollars = 0,
        dollar_gain = 1,
        target_suit = "Spades",
    }},
    loc_vars = function (self, info_queue, card)
        local suit = (G.GAME.current_round.wafflemod_pop_art_suit or {}).suit or 'Spades'
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollar_gain, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] } } }
    end,
    blueprint_compat = false,
    calculate = function (self, card, context)
        if context.before and not context.blueprint then
            local upgradeCount = 0
            for _, scoring_card in pairs(context.scoring_hand) do
                if scoring_card:is_suit(card.ability.extra.target_suit) then
                    upgradeCount = upgradeCount + 1
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            scoring_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if upgradeCount > 0 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "dollars",
                    change = "dollar_gain",
                    operation = function (ref_table, ref_value, initial, change)
                        ref_table[ref_value] = initial + upgradeCount*card.ability.extra.dollar_gain
                    end 
                })
            end
        end
    end,
    calc_dollar_bonus = function (self, card)
        if card.ability.extra.dollars > 0 then
            local dollarsGiven = card.ability.extra.dollars
            card.ability.extra.dollars = 0
            return dollarsGiven
        end
    end
}
local function reset_pop_art_suit()
    G.GAME.current_round.wafflemod_pop_art_suit = G.GAME.current_round.wafflemod_pop_art_suit or { suit = 'Spades' }
    local valid_pop_art_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(playing_card) then
            valid_pop_art_cards[#valid_pop_art_cards + 1] = playing_card
        end
        local pop_art_card = pseudorandom_element(valid_pop_art_cards,
        'wafflemod_pop_art' .. G.GAME.round_resets.ante)
        if pop_art_card then
            G.GAME.current_round.wafflemod_pop_art_suit.suit = pop_art_card.base.suit
        end
    end
end

-- Snowman
SMODS.Joker {
    key = "snowman",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 6, y = 0 },
    config = { extra = {
        dollars = 2,
        dollar_gain = 2
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollar_gain } }
    end,
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if WaffleMod.endOfRoundContext(context) and (G.GAME.current_round.hands_played <= 1) then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "dollars",
                scalar_value = "dollar_gain",
            })
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end
}

-- Stage Magician
SMODS.Joker {
    key = "stage_magician",
    rarity = 2,
    cost = 4,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 6, y = 1 },
    config = { extra = {
        cards_added = 4
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_wafflemod_ephemeral_playing_card', set = 'Edition', config = {} }
        return { vars = { card.ability.extra.cards_added } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local createdCards = {}

            for i = 1, card.ability.extra.cards_added do
                G.E_MANAGER:add_event(Event {
                    func = function()
                        local _card = SMODS.add_card { set = "Base", edition = "e_wafflemod_ephemeral" }
                        G.GAME.blind:debuff_card(_card)
                        _card:start_materialize()
                        G.hand:sort()
                        SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                        return true
                    end
                })
            end

            return nil, true
        end
    end
}

-- Rare
------------------------------------------------------------------------------------------------------------------------------------------

-- AAAAAA
SMODS.Joker {
    key = "aaaaaa",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 1, y = 2 },
    config = { extra = {
        xmult = 0.2
    } },
    rarity = 3,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 14 then
            local xmultToGive = 1
            for i, v in pairs(context.scoring_hand) do
                if v:get_id() == 14 then
                    xmultToGive = xmultToGive + card.ability.extra.xmult
                end
            end
            return {
                xmult = xmultToGive
            }
        end
    end
}

-- Bring Me Your Love
SMODS.Joker {
    key = "bring_me_your_love",
    rarity = 3,
    cost = 7,
    pos = { x = 7, y = 0 },
    atlas = "wafflemod_jokerAtlas",
    config = { extra = {
        suit = "Hearts"
    } },
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return {
            key = next(SMODS.find_card("j_vampire")) and "j_wafflemod_bring_me_your_love_vampire" or nil,
            vars = { localize(card.ability.extra.suit, 'suits_singular') }
        }
    end
}
local shuffle_ref = CardArea.shuffle
function CardArea:shuffle(_seed)
    shuffle_ref(self, _seed)

    if next(SMODS.find_card("j_wafflemod_bring_me_your_love")) then
        local idx = #self.cards
        for j = #self.cards, 1, -1 do
            local card_j = self.cards[j]
            if card_j:is_suit("Hearts") and j ~= idx then
                self.cards[idx], self.cards[j] = self.cards[j], self.cards[idx]
                idx = idx - 1
            end
        end
        self:set_ranks()
    end
end

-- Darkroom
SMODS.Joker {
    key = "darkroom",
    config = {
        extra = {
            odds = 4,
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_negative_consumable', set = 'Edition', config = { extra = 1 } }
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    rarity = 3,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 0, y = 1 },
    cost = 8,
    calculate = function(self, card, context)
        if context.using_consumeable and pseudorandom('darkroomRng') < G.GAME.probabilities.normal / card.ability.extra.odds then
            local isNegative = context.consumeable.edition and context.consumeable.edition.key == "e_negative"
            if not isNegative then
                local copy = copy_card(context.consumeable)

                copy:set_edition("e_negative", true)
                copy:add_to_deck()
                G.consumeables:emplace(copy)
            end
        end
    end
}

-- Freddie Mercury
SMODS.Joker {
    key = "freddie_mercury",
    config = {
        extra = {
            queenScaling = 2,
            mercuryScaling = 0.2,
            currentQueenScale = 0,
            currentMercuryScale = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_mercury
        info_queue[#info_queue + 1] = { key = "wafflemod_art_credit_jac", set = "Other", config = {} }
        return {
            vars = {
                card.ability.extra.queenScaling,
                card.ability.extra.mercuryScaling,
                card.ability.extra.currentQueenScale,
                card.ability.extra.currentMercuryScale
            }
        }
    end,
    rarity = 3,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 4, y = 1 },
    cost = 7,
    calculate = function(self, card, context)
        -- Upgrade when a Queen is scored
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 12 and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "currentQueenScale",
                scalar_value = "queenScaling",
                no_message = true
            })
            return {
                message = localize('k_upgrade_ex'),
                message_card = card
            }
        end

        -- Upgrade when Mercury is used
        if context.using_consumeable and not context.blueprint and context.consumeable.config.center.key == "c_mercury" then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "currentMercuryScale",
                scalar_value = "mercuryScaling",
                scaling_message = {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.currentMercuryScale + card.ability.extra.mercuryScaling } },
                    colour = G.C.RED
                }
            })
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.currentQueenScale,
                Xmult = card.ability.extra.currentMercuryScale
            }
        end
    end
}

-- Legendary
------------------------------------------------------------------------------------------------------------------------------------------

-- Waffle
SMODS.Joker {
    key = "doctorwaffle",
    no_collection = true,
    config = {
        extra = {
            rounds_cleared = 0
        } },
    loc_vars = function(self, info_queue, card)
        local roundsCleared = card.ability.extra.rounds_cleared
        local returnTable = {}

        -- yandev would be proud
        if roundsCleared < 1 then
            returnTable.key = "j_wafflemod_doctorwaffle_0"
        elseif roundsCleared < 2 then
            returnTable.key = "j_wafflemod_doctorwaffle_1"
        else
            info_queue[#info_queue + 1] = { key = 'e_negative_consumable', set = 'Edition', config = { extra = 1 } }
            returnTable.key = "j_wafflemod_doctorwaffle_2"
        end

        -- Collection special
        if WaffleMod.isCardInCollection(card) then
            info_queue[#info_queue + 1] = { key = 'wafflemod_sharktale', set = 'Other', config = {} }
            returnTable.key = "j_wafflemod_doctorwaffle_collection"
        end

        return returnTable
    end,
    rarity = 4,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('wafflemod_dubious_legendary'),
            G.C.RARITY.Legendary, G.C.WHITE,
            1.2)
    end,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 4, y = 3 },
    soul_pos = { x = 5, y = 3 },
    cost = 20,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and context.game_over == false and not context.blueprint then
            card.ability.extra.rounds_cleared = card.ability.extra.rounds_cleared + 1

            if card.ability.extra.rounds_cleared == 2 then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
        end

        if context.selling_self and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blocking = false,
                blockable = false,
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Joker', legendary = true, edition = "e_negative" })
                    check_for_unlock { type = 'spawn_legendary' }
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end
}

-- Ice Juggler Cookie
SMODS.Joker {
    key = "ice_juggler_cookie",
    config = { extra = {
        h_size = 3,
        xmult = 1,
        xmult_gain = 0.25,
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size, card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 6, y = 3 },
    soul_pos = { x = 7, y = 3 },
    rarity = 4,
    cost = 20,
    add_to_deck = function(self, card, from_debuff)
        WaffleMod.legendary_sound("icejuggler_appear")

        G.hand:change_size(card.ability.extra.h_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.h_size)
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local wildcardsHeld = 0
            local findSuits = {
                "Hearts",
                "Spades",
                "Diamonds",
                "Clubs",
            }
            local foundSuits = {}

            for _, playing_card in pairs(G.hand.cards) do
                if SMODS.has_enhancement(card, "m_wild") then
                    wildcardsHeld = wildcardsHeld + 1
                else
                    for _, suit in pairs(findSuits) do
                        if playing_card:is_suit(suit) and not table.find(foundSuits, suit) then
                            table.insert(foundSuits, suit)
                        end
                    end
                end
            end

            if wildcardsHeld + #foundSuits >= 4 then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        WaffleMod.legendary_sound("icejuggler_upgrade")
                        return true
                    end
                }))
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    scalar_value = "xmult_gain",
                    ref_value = "xmult",
                    scaling_message = {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult + card.ability.extra.xmult_gain } }
                    }
                })
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

-- Mr. Do!
SMODS.Joker {
    key = "mrdo",
    config = {
        extra = {
            Xmult = 1,
            Xmult_gain = 0.5,
            aceScored = nil,
            kingScored = nil,
            queenScored = nil,
            jackScored = nil,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.Xmult,
                card.ability.extra.Xmult_gain,
                colours = {
                    card.ability.extra.aceScored or G.C.UI.TEXT_INACTIVE,
                    card.ability.extra.kingScored or G.C.UI.TEXT_INACTIVE,
                    card.ability.extra.queenScored or G.C.UI.TEXT_INACTIVE,
                    card.ability.extra.jackScored or G.C.UI.TEXT_INACTIVE,
                }
            }
        }
    end,
    rarity = 4,
    cost = 20,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 0, y = 3 },
    soul_pos = { x = 1, y = 3 },
    add_to_deck = function(self, card, from_debuff)
        WaffleMod.legendary_sound("mrdo_appear")
    end,
    calculate = function(self, card, context)
        local function checkUpgrade()
            if
                card.ability.extra.aceScored
                and card.ability.extra.kingScored
                and card.ability.extra.queenScored
                and card.ability.extra.jackScored
            then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        WaffleMod.legendary_sound("mrdo_upgrade")
                        return true
                    end
                }))
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "Xmult",
                    scalar_value = "Xmult_gain",
                    scaling_message = {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult + card.ability.extra.Xmult_gain } },
                        --colour = G.C.MULT,
                        message_card = card
                    }
                })
                -- Reset values
                card.ability.extra.aceScored = nil
                card.ability.extra.kingScored = nil
                card.ability.extra.queenScored = nil
                card.ability.extra.jackScored = nil
                -- return {
                --     message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                --     colour = G.C.MULT,
                --     message_card = card
                -- }
            end
        end

        if context.joker_main then
            return {
                Xmult = card.ability.extra.Xmult
            }
        end

        if context.before and not context.blueprint then
            for i, scoring_card in pairs(context.scoring_hand) do
                local getRank = scoring_card:get_id()

                if getRank == 14 then     -- Ace
                    card.ability.extra.aceScored = G.C.BLUE
                elseif getRank == 13 then -- King
                    card.ability.extra.kingScored = G.C.BLUE
                elseif getRank == 12 then -- Queen
                    card.ability.extra.queenScored = G.C.BLUE
                elseif getRank == 11 then -- Jack
                    card.ability.extra.jackScored = G.C.BLUE
                end
            end
            checkUpgrade()
        end
    end
}

-- Pomni
SMODS.Joker {
    key = "pomni",
    loc_txt = {
        name = "Pomni",
        text = {
            "Sell this card while",
            "in the shop to",
            "set Ante to 1"
        }
    },
    rarity = 4,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 2, y = 3 },
    soul_pos = { x = 3, y = 3 },
    cost = 20,
    calculate = function(self, card, context)
        if context.selling_self and G.STATE == G.STATES.SHOP then
            local reduction = G.GAME.round_resets.ante - 1

            ease_ante(-reduction)

            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - reduction
        end
    end
}

-- Boss
------------------------------------------------------------------------------------------------------------------------------------------

-- Table of blinds and their corresponding jokers
-- Other mods can add to this table (or should theoretically be able to, at least)
WaffleMod.bossJokerTable = {

    bl_arm = "j_wafflemod_arm",
    bl_club = "j_wafflemod_club",
    bl_goad = "j_wafflemod_goad",
    bl_head = "j_wafflemod_head",
    bl_hook = "j_wafflemod_hook",
    bl_needle = "j_wafflemod_needle",
    bl_ox = "j_wafflemod_ox", -- roblox ?!?!
    bl_psychic = "j_wafflemod_psychic",
    bl_serpent = "j_wafflemod_serpent",
    bl_wall = "j_wafflemod_wall",
    bl_water = "j_wafflemod_water",
    bl_window = "j_wafflemod_window",

    bl_cerulean_bell = "j_wafflemod_cerulean_bell",
    bl_crimson_heart = "j_wafflemod_crimson_heart"

}

local bossJokerTable = WaffleMod.bossJokerTable

-- Hook into blind defeated function to roll for Boss Joker drops
local blindDefeatedRef = Blind.defeat
function Blind:defeat(silent)
    -- print(G.GAME.current_round.hands_played) -- test
    local bossJokersEnabled = WaffleMod.config.boss_jokers.enabled -- TODO: config
    local bossJokerDropOdds = WaffleMod.config.boss_jokers.chance
    if self.boss and bossJokersEnabled then
        local getJokerKeyFromBlind = bossJokerTable[self.config.blind.key]
        local bossJokerDropNumerator = G.GAME.probabilities.normal or 1

        -- Doubled odds of dropping if hunting license voucher is owned
        if WaffleMod.hasVoucher("v_wafflemod_hunting_license") then
            bossJokerDropNumerator = bossJokerDropNumerator * 2
        end

        local trophyCollected = WaffleMod.hasVoucher("v_wafflemod_trophy_collector") and
            (G.GAME.current_round.hands_played <= 1)
        local bossJokerRoll = pseudorandom("bossJokerRNG") <
            G.GAME.probabilities.normal /
            bossJokerDropOdds
        local freeJokerSlot = G.jokers and #G.jokers.cards < G.jokers.config.card_limit

        if freeJokerSlot and (bossJokerRoll or trophyCollected) and getJokerKeyFromBlind then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                delay = 0.1,
                func = function()
                    play_sound('timpani')
                    local newJoker = SMODS.add_card({ set = 'Joker', key = getJokerKeyFromBlind })
                    newJoker:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
    end

    return blindDefeatedRef(self, silent)
end

-- just so i'm not repeating this math.huge() times
local bossCardDraw = function(self, card, layer)
    if card.config.center.discovered or card.bypass_discovery_center then
        card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
    end
end

local suitBossMultGain = 0.05

-- The Arm
SMODS.Joker {
    key = "arm",
    rarity = "wafflemod_Boss",
    config = {extra = {
        odds = 2
    }},
    pos = {x = 8, y = 4},
    soul_pos = {x = 9, y = 4},
    loc_vars = function (self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal or 1, card.ability.extra.odds}}
    end,
    cost = 15,
    atlas = "wafflemod_jokerAtlas",
    calculate = function (self, card, context)
        if context.before and SMODS.pseudorandom_probability(card, 'wafflemod_arm', 1, card.ability.extra.odds) then
            return {
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end,
    draw = bossCardDraw
}

-- The Club
SMODS.Joker {
    key = "club",
    config = {
        extra = {
            xmult = 1,
            target_suit = "Clubs",
            xmult_gain = suitBossMultGain
        }
    },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.boss_jokers.enabled)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.target_suit, card.ability.extra.xmult } }
    end,
    rarity = "wafflemod_Boss",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 0, y = 6 },
    soul_pos = { x = 1, y = 6 },
    cost = 15,
    draw = bossCardDraw,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end

        if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.target_suit) and not context.blueprint then
            local xMult = card.ability.extra.xmult + card.ability.extra.xmult_gain

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_gain",
                no_message = true
            })

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
    end
}

-- The Goad
SMODS.Joker {
    key = "goad",
    config = {
        extra = {
            xmult = 1,
            target_suit = "Spades",
            xmult_gain = suitBossMultGain
        }
    },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.boss_jokers.enabled)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.target_suit, card.ability.extra.xmult } }
    end,
    rarity = "wafflemod_Boss",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 2, y = 6 },
    soul_pos = { x = 3, y = 6 },
    cost = 15,
    draw = bossCardDraw,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end

        if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.target_suit) and not context.blueprint then
            local xMult = card.ability.extra.xmult + card.ability.extra.xmult_gain

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_gain",
                no_message = true
            })

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
    end
}

-- The Head
SMODS.Joker {
    key = "head",
    config = {
        extra = {
            xmult = 1,
            target_suit = "Hearts",
            xmult_gain = suitBossMultGain
        }
    },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.boss_jokers.enabled)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.target_suit, card.ability.extra.xmult } }
    end,
    rarity = "wafflemod_Boss",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 0, y = 5 },
    soul_pos = { x = 1, y = 5 },
    cost = 15,
    draw = bossCardDraw,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end

        if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.target_suit) and not context.blueprint then
            local xMult = card.ability.extra.xmult + card.ability.extra.xmult_gain

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_gain",
                no_message = true
            })

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
    end
}

-- The Hook
SMODS.Joker {
    key = "hook",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 4, y = 4 },
    soul_pos = { x = 5, y = 4 },
    draw = bossCardDraw,
    rarity = "wafflemod_Boss",
    config = { extra = {
        dollars = 2
    } },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.boss_jokers.enabled)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and context.end_of_round then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end
}

-- The Needle
SMODS.Joker {
    key = "needle",
    config = {
        extra = {
            xmult = 1,
            xmult_gain = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.boss_jokers.enabled)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,
    rarity = "wafflemod_Boss",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 0, y = 4 },
    soul_pos = { x = 1, y = 4 },
    cost = 15,
    draw = bossCardDraw,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end

        if context.setting_blind and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local handsRemoved = G.GAME.current_round.hands_left - 1
                    local xMult = handsRemoved * card.ability.extra.xmult_gain + 1
                    ease_hands_played(-handsRemoved)
                    card.ability.extra.xmult = xMult
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_xmult', vars = { xMult } }, colour = G.C.MULT },
                        card)
                    return true
                end
            }))
            return nil, true
        end
    end
}

-- The Ox
SMODS.Joker {
    key = "ox",
    config = {
        extra = {
            dollars = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.boss_jokers.enabled)
        return { vars = { card.ability.extra.dollars, localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') } }
    end,
    collection_loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, localize(ph_most_played) } }
    end,
    rarity = "wafflemod_Boss",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 2, y = 4 },
    soul_pos = { x = 3, y = 4 },
    cost = 15,
    draw = bossCardDraw,
    calculate = function(self, card, context)
        local function dosh()
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end

        -- Single payout on playing hand
        -- if context.before and context.scoring_name == G.GAME.current_round.most_played_poker_hand then
        --     dosh()
        -- end

        -- Payout each time a card is scored
        if context.individual and context.cardarea == G.play and context.scoring_name == WaffleMod.getMostPlayedHand() then
            return dosh()
        end
    end
}

-- The Psychic
SMODS.Joker {
    key = "psychic",
    config = { extra = {
        xmult = 1.5,
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    rarity = "wafflemod_Boss",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 4, y = 5 },
    soul_pos = { x = 5, y = 5 },
    draw = bossCardDraw,
    calculate = function(self, card, context)
        if context.joker_main then
            for _, scoredCard in pairs(context.scoring_hand) do
                if scoredCard.debuff then
                    SMODS.calculate_effect(
                        {
                            message = localize('k_debuffed'),
                            colour = G.C.RED
                        },
                        card
                    )
                else
                    SMODS.calculate_effect(
                        { xmult = card.ability.extra.xmult },
                        card
                    )
                end
            end
        end
    end
}

-- The Serpent
SMODS.Joker {
    key = "serpent",
    config = { extra = {
        h_size = 1
    } },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.boss_jokers.enabled)
        return { vars = { card.ability.extra.h_size } }
    end,
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 4, y = 6 },
    soul_pos = { x = 5, y = 6 },
    rarity = "wafflemod_Boss",
    cost = 15,
    draw = bossCardDraw,
    calculate = function(self, card, context)
        if context.pre_discard or context.after then
            G.GAME.serpent_joker_boost = (G.GAME.serpent_joker_boost or 0) + card.ability.extra.h_size
            G.hand:change_size(card.ability.extra.h_size)
            return {
                message = localize { type = 'variable', key = 'a_handsize', vars = { card.ability.extra.h_size } }
            }
        end
    end
}
local curModCalcRef = SMODS.current_mod.calculate or function() end
function SMODS.current_mod.calculate(self, context)
    if context.end_of_round and context.main_eval and context.game_over == false and G.GAME.serpent_joker_boost then
        G.hand:change_size(G.GAME.serpent_joker_boost * -1)
        G.GAME.serpent_joker_boost = 0
    end
    return curModCalcRef(self, context)
end

-- The Wall
SMODS.Joker {
    key = "wall",
    config = { extra = {
        xmult = 3
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    rarity = "wafflemod_Boss",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 6, y = 6 },
    soul_pos = { x = 7, y = 6 },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    cost = 15,
    draw = bossCardDraw
}

-- The Water
SMODS.Joker {
    key = "water",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 6, y = 4 },
    soul_pos = { x = 7, y = 4 },
    cost = 15,
    rarity = "wafflemod_Boss",
    config = { extra = {
        xmult = 1
    } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                (card.ability.extra.xmult * G.GAME.current_round.discards_left) + 1
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = (card.ability.extra.xmult * G.GAME.current_round.discards_left) + 1
            }
        end
    end,
    draw = bossCardDraw
}

-- The Wheel
SMODS.Joker {
    key = "wheel",
    atlas = "wafflemod_jokerAtlas",
    config = {extra = {
        odds = 4
    }},
    loc_vars = function (self, info_queue, card)
        return {vars = {
            G.GAME.probabilities.normal or 1,
            card.ability.extra.odds
        }}
    end,
    cost = 15,
    pos = {x = 8, y = 6},
    soul_pos = {x = 9, y = 6},
    calculate = function (self, card, context)
        if context.before then
            for _, playing_card in pairs(context.scoring_hand) do
                if playing_card.edition == nil and SMODS.pseudorandom_probability(card, 'wafflemod_wheel', 1, card.ability.extra.odds) then
                    local edition = SMODS.poll_edition { key = "wafflemod_wheel_edition", guaranteed = true, no_negative = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
                    playing_card:set_edition(edition, nil, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function ()
                            card:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end,
    draw = bossCardDraw
}

-- testing joker Lolol
SMODS.Joker {
    key = "debug",
    atlas = "wafflemod_jokerAtlas",
    calculate = function (self, card, context)
        if context.before then
            for _, playing_card in pairs(context.scoring_hand) do
                if playing_card.edition == nil then

                    -- Card scores as holographic and juices up before scoring but is visually editioned as soon as play is pressed, which looks odd
                    playing_card:set_edition("e_holo", nil, nil, true)

                    -- Card juices up and visually turns holographic before scoring, but does not actually score as holo
                    -- Additionally the juice up is immediately before scoring with no delay, which also looks odd
                    -- G.E_MANAGER:add_event(Event({
                    --     func = function ()
                    --         playing_card:set_edition("e_holo", true)
                    --         return true
                    --     end
                    -- }))

                end
            end
        end
    end
}

-- The Window
SMODS.Joker {
    key = "window",
    config = {
        extra = {
            xmult = 1,
            target_suit = "Diamonds",
            xmult_gain = suitBossMultGain
        }
    },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.boss_jokers.enabled)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.target_suit, card.ability.extra.xmult } }
    end,
    rarity = "wafflemod_Boss",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 2, y = 5 },
    soul_pos = { x = 3, y = 5 },
    cost = 15,
    draw = bossCardDraw,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end

        if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.target_suit) and not context.blueprint then
            local xMult = card.ability.extra.xmult + card.ability.extra.xmult_gain

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_gain",
                no_message = true
            })

            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
    end
}

-- Cerulean Bell
local ceruleanStickerXMult = 3
SMODS.Joker {
    key = "cerulean_bell",
    config = { extra = {
        sticker = "wafflemod_cerulean"
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'wafflemod_cerulean', set = 'Other', config = { vars = { 2.5 } } }
    end,
    atlas = "wafflemod_jokerAtlas",
    rarity = "wafflemod_Showdown",
    pos = { x = 8, y = 5 },
    soul_pos = { x = 9, y = 5 },
    blueprint_compat = false,
    cost = 20
}
WaffleMod.bindToModCalculate(function(context)
    if context.hand_drawn then
        for _, deckCard in pairs(G.playing_cards) do
            deckCard.ability.wafflemod_cerulean = false
        end
        if next(SMODS.find_card("j_wafflemod_cerulean_bell")) then
            local eligibleCards = {}
            for _, handCard in pairs(G.hand.cards) do
                if handCard.ability.wafflemod_cerulean then
                    handCard.ability.wafflemod_cerulean = false
                else
                    table.insert(eligibleCards, handCard)
                end
            end
            local whichCard = pseudorandom_element(eligibleCards, "wafflemod_ceruleanSticker")
            if whichCard then
                G.E_MANAGER:add_event(Event {
                    func = function()
                        whichCard:add_sticker("wafflemod_cerulean", true)
                        play_sound("generic1")
                        whichCard:juice_up()
                        return true
                    end
                })
            end
        end
    end
end)

-- Crimson Heart
SMODS.Joker {
    key = "crimson_heart",
    atlas = "wafflemod_jokerAtlas",
    pos = { x = 6, y = 5 },
    soul_pos = { x = 7, y = 5 },
    rarity = "wafflemod_Showdown",
    cost = 20,
    blueprint_compat = false,
    config = {
        extra = {
            slots = 2
        }
    },
    add_to_deck = function (self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,
    remove_from_deck = function (self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots } }
    end,
    calculate = function(self, card, context)

    end
}

-- Reset game globals (Change suits for random-suit Jokers)

function SMODS.current_mod.reset_game_globals(run_start)
    reset_fickle_suit()
    reset_pop_art_suit()
end