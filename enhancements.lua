SMODS.Atlas {
    key = "enhancementAtlas",
    path = "enhancements.png",
    px = 71,
    py = 95,
}

SMODS.Enhancement {
    key = "scribbled",
    atlas = "enhancementAtlas"
}
local card_is_face_ref = Card.is_face
function Card:is_face(from_boss)
    return card_is_face_ref(self, from_boss) or SMODS.has_enhancement(self, "m_wafflemod_scribbled")
end