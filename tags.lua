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
        if context.discard then
            tag.triggered = true
            tag:yep('+', G.C.RED)
        end
    end
}

-- Extension Tag
local slotsPerExtensionTag = 2
SMODS.Tag {
    key = "extension",
    atlas = "wafflemod_tagAtlas",
    pos = {x = 2, y = 0},
    config = {extra = {slots = slotsPerExtensionTag}},
    loc_vars = function (self, info_queue, tag)
        return {vars = {slotsPerExtensionTag, slotsPerExtensionTag ~= 1 and "s" or ""}}
    end,
    apply = function (self, tag, context)
        if context.starting_shop then
            G.GAME.wafflemod_extension_tags = (G.GAME.wafflemod_extension_tags or 0) + 1
            tag.triggered = true
            tag:yep('+', G.C.GREEN)
        end
    end
}

-- Photocopy Tag
SMODS.Tag {
    key = "photocopy",
    atlas = "wafflemod_tagAtlas",
    pos = {x=3, y=0},
    min_ante = 3, -- Mostly just so it appears when you actually have money to use it best
    apply = function (self, tag, context)
        if context.buying_card and context.card.ability.set == "Joker" then
            tag.triggered = true
            tag:yep('+', G.C.GREEN)
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

    local numExtensionTags = 0

    -- Go through tags and call apply_to_run as needed
    for _, tag in pairs(G.GAME.tags) do

        if tag.key == "tag_wafflemod_stamper" and context.before and not stamperActivated then
            stamperActivated = true
            tag:apply_to_run(context)
        end

        if tag.key == "tag_wafflemod_cutter" and context.discard and not cutterActivated then
            cutterActivated = true
            tag:apply_to_run(context)
            return {
                remove = true
            }
        end

        if tag.key == "tag_wafflemod_extension" and context.starting_shop then
            numExtensionTags = numExtensionTags + 1
            tag:apply_to_run(context)
        end

        if tag.key == "tag_wafflemod_photocopy" and context.buying_card then
            if context.card.ability.set == "Joker" and G.shop_jokers then
                local photocopy = SMODS.copy_card(context.card, {
                    area = G.shop_jokers
                })
                photocopy:start_materialize()
                photocopy:set_cost()
                create_shop_card_ui(photocopy, "Joker", G.shop_jokers)
                tag:apply_to_run(context)
            end
        end

    end

    -- Increase shop size based on extension tag count
    if context.starting_shop and numExtensionTags > 0 then
        change_shop_size(numExtensionTags * slotsPerExtensionTag)
        G.GAME.wafflemod_extension_tags = numExtensionTags
    end

    -- Remove temporary shop size boost at end of shop
    if context.ending_shop and G.GAME.wafflemod_extension_tags then
        change_shop_size(G.GAME.wafflemod_extension_tags * slotsPerExtensionTag * -1)
        G.GAME.wafflemod_extension_tags = 0
    end

end,
"customTagCheck")