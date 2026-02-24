SMODS.Atlas {
    key = "wafflemod_tarotsAtlas",
    path = "tarots.png",
    px = 71,
    py = 95,
}

-- The Well
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
        return { vars = { card.ability.extra.clone_edition, card.ability.max_highlighted } }
    end,
    can_use = function()
        return G.jokers and #G.jokers.highlighted == 1
    end,
    use = function(self, card, area, copier)
        local clone = copy_card(G.jokers.highlighted[1])
        clone:set_edition(card.ability.extra.clone_edition)
        clone:start_materialize()
        clone:add_to_deck()
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
