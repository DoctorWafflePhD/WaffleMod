SMODS.Atlas {
    key = "wafflemod_enhancementAtlas",
    path = "enhancements.png",
    px = 71,
    py = 95,
}

-- Ripple (NYI)
if false then
    SMODS.Enhancement {
    key = "ripple",
    atlas = "wafflemod_enhancementAtlas",
    pos = {x=1,y=0}
}
end

-- Scribbled
SMODS.Enhancement {
    key = "scribbled",
    atlas = "wafflemod_enhancementAtlas"
}
local card_is_face_ref = Card.is_face
function Card:is_face(from_boss)
    return card_is_face_ref(self, from_boss) or SMODS.has_enhancement(self, "m_wafflemod_scribbled")
end
