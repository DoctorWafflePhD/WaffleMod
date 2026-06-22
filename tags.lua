SMODS.Atlas {
    key = "wafflemod_tagAtlas",
    path = "tags.png",
    px = 34,
    py = 34,
}

-- Cutter Tag
SMODS.Tag {
    key = "cutter",
    atlas = "wafflemod_tagAtlas",
    pos = {x=1,y=0},
    apply = function (self, tag, context)
        if context.pre_discard then
            tag.triggered = true
            tag:yep('+', G.C.RED)
            SMODS.destroy_cards(context.full_hand)
        end
    end
}

-- Stamper Tag
SMODS.Tag {
    key = "stamper",
    atlas = "wafflemod_tagAtlas",
    apply = function (self, tag, context)
        if context.before then
            tag.triggered = true
            tag:yep('+', G.C.BLUE)
            for _, card in pairs(context.full_hand) do
                local random_seal = SMODS.poll_seal {key = "wafflemod_stamper", guaranteed = true}
                card:set_seal(random_seal)
            end
        end
    end
}

WaffleMod.bindToModCalculate(function(context)

    local stamperActivated = false
    local cutterActivated = false

    for _, tag in pairs(G.GAME.tags) do

        if tag.key == "tag_wafflemod_stamper" and context.before and not stamperActivated then
            stamperActivated = true
            tag:apply_to_run(context)
        end

        if tag.key == "tag_wafflemod_cutter" and context.pre_discard and not cutterActivated then
            cutterActivated = true
            tag:apply_to_run(context)
        end

    end
end,
"customTagCheck")