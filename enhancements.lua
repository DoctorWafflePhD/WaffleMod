SMODS.Atlas {
    key = "wafflemod_enhancementAtlas",
    path = "enhancements.png",
    px = 71,
    py = 95,
}

-- Monochrome
if false then
    SMODS.Enhancement {
        key = "monochrome",
        atlas = "wafflemod_enhancementAtlas",
        pos = { x = 1, y = 0 },
        no_suit = true,
        config = { extra = {
            retriggers = 1
        } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.retriggers } }
        end,
        calculate = function(self, card, context)
            if context.repetition then
                return {
                    repetitions = card.ability.extra.retriggers,
                }
            end
        end,
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
