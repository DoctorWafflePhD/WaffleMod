SMODS.Atlas {
    key = "wafflemod_sealAtlas",
    path = "seals.png",
    px = 71,
    py = 95,
}

local shinySealDraw = function(self, card, layer)
    if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
        G.shared_seals[card.seal].role.draw_major = card
        G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
end

-- Copper Seal
local dollarsPerCopperSeal = 1
WaffleMod.addLocColor("wafflemod_copper", HEX('E08043'))
local function getNumCopperSealsInFullDeck()
    local numCopperSeals = 0
    if not G.playing_cards then -- For cases where there is no G.playing_cards, i.e. viewing in collection
        return dollarsPerCopperSeal
    else
        for _, v in pairs(G.playing_cards) do
            if v.seal == "wafflemod_copper" then
                numCopperSeals = numCopperSeals + 1
            end
        end
    end
    return numCopperSeals
end
SMODS.Seal {
    key = "copper",
    pos = { x = 4, y = 0 },
    config = { extra = {
        dollars = dollarsPerCopperSeal
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.dollars, getNumCopperSealsInFullDeck() } }
    end,
    atlas = "wafflemod_sealAtlas",
    badge_colour = HEX('E08043'),
    draw = shinySealDraw
}
WaffleMod.bindToModCalculate(function(context)
    if context.round_eval and getNumCopperSealsInFullDeck() > 0 then
        local localizeKey = 'k_wafflemod_copper_seal_eval'
        if getNumCopperSealsInFullDeck() == 1 then
            localizeKey = 'k_wafflemod_copper_seal_eval_singular'
        end
        add_round_eval_row({
            name = "custom",
            text = localize(localizeKey),
            number = getNumCopperSealsInFullDeck(),
            number_colour = G.C.wafflemod_copper,
            dollars = getNumCopperSealsInFullDeck(),
            --card = G.deck,
            pitch = 1
        })
    end
end, "copperSealEvalDollars")

-- Ebony Seal
local handSizePerSealDiscarded = 1
SMODS.Seal {
    key = 'ebony',
    pos = { x = 2, y = 0 },
    config = { extra = {
        h_size = handSizePerSealDiscarded
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.extra.h_size, "test" } }
    end,
    atlas = "wafflemod_sealAtlas",
    badge_colour = HEX('4F6367'),
    calculate = function(self, card, context)
        if context.discard and card == context.other_card then
            G.GAME.ebony_seals_discarded = (G.GAME.ebony_seals_discarded or 0) + 1
            G.hand:change_size(self.config.extra.h_size)
        end
    end,
    draw = shinySealDraw,
}
local curModCalcRef = SMODS.current_mod.calculate or function() end
SMODS.current_mod.calculate = function(self, context)
    if context and context.end_of_round and context.main_eval and context.game_over == false and G.GAME.ebony_seals_discarded then
        G.hand:change_size(-handSizePerSealDiscarded * G.GAME.ebony_seals_discarded)
        G.GAME.ebony_seals_discarded = 0
    end
    return curModCalcRef(self, context)
end

-- Ivory Seal
local ivorySealUsesChance = false
WaffleMod.addLocColor("wafflemod_ivory", HEX('ADC5CC'))
SMODS.Seal {
    key = 'ivory',
    pos = { x = 1, y = 0 },
    atlas = "wafflemod_sealAtlas",
    badge_colour = G.C.wafflemod_ivory,
    config = { extra = {
        odds_numerator = 2,
        odds_denominator = 3,
    } },
    loc_vars = function(self, info_queue)
        return { vars = { G.GAME.probabilities.normal * self.config.extra.odds_numerator, self.config.extra.odds_denominator } }
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and context.removed then
            if table.find(context.removed, card) then
                print("ivory seal destroyed")
                local eligibleCards = {}
                for _, card in pairs(G.deck.cards) do
                    if not card.seal then
                        table.insert(eligibleCards, card)
                    end
                end
                if (not ivorySealUsesChance) or SMODS.pseudorandom_probability(self, "wafflemod_ivorySealSpreadRoll", 2, 3) then
                    if #eligibleCards > 0 then
                        local chosenCarrier = pseudorandom_element(eligibleCards, "wafflemod_ivorySealInheritance")
                        chosenCarrier:set_seal("wafflemod_ivory", true, true)
                    else
                        -- print("no eligible cards!")
                    end
                end

                -- Create spectral card if we have room
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                set = 'Spectral',
                                key_append = 'wafflemod_ivory_seal'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                end
            end
        end
    end,
    draw = shinySealDraw,
}

-- Viridian Seal
WaffleMod.addLocColor("wafflemod_viridian", HEX('42B374'))
SMODS.Seal {
    key = "viridian",
    pos = { x = 3, y = 0 },
    atlas = "wafflemod_sealAtlas",
    badge_colour = G.C.GREEN,
    config = { extra = {
        odds_numerator = 1,
        odds_denominator = 2,
    } },
    loc_vars = function(self, info_queue)
        return { vars = { G.GAME.probabilities.normal * self.config.extra.odds_numerator, self.config.extra.odds_denominator } }
    end,
    calculate = function(self, card, context)
        if context.before then
            for _, v in pairs(context.scoring_hand) do
                if v == card then
                    if SMODS.pseudorandom_probability(card, "wafflemod_viridianRoll", G.GAME.probabilities.normal * self.config.extra.odds_numerator, self.config.extra.odds_denominator) then
                        SMODS.upgrade_poker_hands({
                            hands = context.scoring_name,
                            from = card,
                            level_up = 1
                        })
                    end
                end
            end
        end
    end,
}
