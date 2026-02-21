SMODS.Atlas {
    key = "wafflemod_tarotsAtlas",
    path = "tarots.png",
    px = 71,
    py = 95,
}

-- The Well (NYI)
if false then
    SMODS.Consumable {
    key = "well",
    set = "Tarot",
    atlas = "wafflemod_tarotsAtlas",
    pos = {x=0,y=0},
    config = { max_highlighted = 2, mod_conv = 'm_mult' }, -- temporary
}
end

-- The Artist
SMODS.Consumable {
    key = "artist",
    set = "Tarot",
    atlas = "wafflemod_tarotsAtlas",
    pos = {x=1,y=0},
    config = { max_highlighted = 3, mod_conv = 'm_wafflemod_scribbled'},
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end
}