SMODS.Shader {
    key = "ephemeral",
    path = "ephemeral.fs"
}

-- Ephemeral
-- +1 hand size/joker or consumable slot, self-destructs when played, discarded, used, or at end of round
SMODS.Edition {
    key = "ephemeral",
    shader = "ephemeral",
    config = { card_limit = 1 },
    disable_base_shader = true,
    loc_vars = function(self, info_queue, card)
        if card.ability and card.ability.set == "Joker" then
            info_queue[#info_queue] = { key = 'e_wafflemod_ephemeral_joker', set = 'Edition', config = {} }
        elseif card.config and (card.config.center.pools or {}).Consumeables then
            info_queue[#info_queue] = { key = 'e_wafflemod_ephemeral_consumable', set = 'Edition', config = {} }
        else
            info_queue[#info_queue] = { key = 'e_wafflemod_ephemeral', set = 'Edition', config = {} }
        end
    end,
    -- on_apply = function (card)
    --     card.sell_cost = 0
    -- end,
    calculate = function(self, card, context)
        card.sell_cost = 0
        if card.ability.set == "Default" then
            if context.discard and card == context.other_card then
                card:start_dissolve()
            end
            if context.destroy_card and context.cardarea == G.play and card == context.destroy_card then
                return { remove = true }
            end
        else
            if WaffleMod.endOfRoundContext(context) then
                G.E_MANAGER:add_event(Event({
                    trigger = "immediate",
                    func = function()
                        SMODS.destroy_cards(card)
                        return true
                    end
                }))
            end
        end
    end
}

-- destroy ephemeral cards in deck at end of round
WaffleMod.bindToModCalculate(function(context)
    if WaffleMod.endOfRoundContext(context) then
        for _, v in pairs(G.playing_cards) do
            if v.edition and ((v.edition.key == "e_wafflemod_ephemeral") or v.edition.wafflemod_ephemeral) then
                SMODS.destroy_cards(v, nil, true)
            end
        end
    end
end)
