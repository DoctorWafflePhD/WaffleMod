SMODS.Atlas {
    key = "sealAtlas",
    path = "seals.png",
    px = 71,
    py = 95,
}

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
    atlas = "sealAtlas",
    badge_colour = HEX('4F6367'),
    calculate = function(self, card, context)
        if context.discard and card == context.other_card then
            G.GAME.ebony_seals_discarded = (G.GAME.ebony_seals_discarded or 0) + 1
            G.hand:change_size(self.config.extra.h_size)
        end
    end,
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end,
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
    atlas = "sealAtlas",
    badge_colour = G.C.wafflemod_ivory,
    config = { extra = {
        odds_numerator = 2,
        odds_denominator = 3,
    } },
    loc_vars = function(self, info_queue)
        return { vars = { G.GAME.probabilities.normal * self.config.extra.odds_numerator, self.config.extra.odds_denominator } }
    end,
    calculate = function(self, card, context)
    end,
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end,
}
local removeRef = Card.start_dissolve
function Card.start_dissolve(self)
    -- This is unrelated to the seal
    if self.config.center.key == "j_wafflemod_doctorwaffle" then
        play_sound("wafflemod_scream")
    end

    if self.seal == "wafflemod_ivory" then
        -- Go through cards in deck, add ivory seal to random card

        local eligibleCards = {}
        for _, card in pairs(G.deck.cards) do
            if not card.seal then
                table.insert(eligibleCards, card)
            end
        end
        if (not ivorySealUsesChance) or SMODS.pseudorandom_probability(self, "wafflemod_ivorySealSpreadRoll", 2, 3) then
            if #eligibleCards > 0 then
                local chosenCarrier = pseudorandom_element(eligibleCards, "wafflemod_ivorySealInheritance")
                chosenCarrier:set_seal("wafflemod_ivory", nil, true)
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

    return removeRef(self, card, from_debuff)
end
