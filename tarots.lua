SMODS.Atlas {
    key = "wafflemod_tarotsAtlas",
    path = "tarots.png",
    px = 71,
    py = 95,
}

local function findEternalJoker()
    if G.jokers and G.jokers.cards then
            for _, v in pairs(G.jokers.cards) do
            if v.ability.eternal then
                return true
            end
        end
    end
end

-- The Well
G.ARGS.LOC_COLOURS.eternal = G.C.ETERNAL -- For eternal tooltip
SMODS.Consumable {
    key = "well",
    set = "Tarot",
    atlas = "wafflemod_tarotsAtlas",
    pos = { x = 0, y = 0 },
    config = { max_highlighted = 1, extra = {
        clone_edition = "e_wafflemod_ephemeral"
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_wafflemod_ephemeral_joker', set = 'Edition', config = {} }
        return { 
            key = findEternalJoker() and "c_wafflemod_well_eternal" or nil,
            vars = { card.ability.extra.clone_edition, card.ability.max_highlighted } }
    end,
    can_use = function()
        return G.jokers and #G.jokers.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local clone = copy_card(G.jokers.highlighted[1])
        clone:set_edition(card.ability.extra.clone_edition)
        clone:start_materialize()
        clone:add_to_deck()
        clone:remove_sticker('eternal')
        G.jokers:emplace(clone)
    end
}

-- The Artist
SMODS.Consumable {
    key = "artist",
    set = "Tarot",
    atlas = "wafflemod_tarotsAtlas",
    pos = { x = 1, y = 0 },
    config = { max_highlighted = 3, mod_conv = 'm_wafflemod_scribbled' },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}

-- Destiny
-- Fun fact on the off chance anyone ever reads this, this is based off this one tarot themed shirt I keep seeing that pisses me off because no, Destiny is NOT a card in the Major Arcana, thank you very much
SMODS.Consumable {
    key = "destiny",
    set = "Tarot",
    atlas = "wafflemod_tarotsAtlas",
    pos = {x = 2, y = 0},
    config = {max_highlighted = 2, mod_conv = "m_wafflemod_monochrome"},
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}