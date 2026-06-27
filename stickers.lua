SMODS.Atlas {
    key = "wafflemod_stickerAtlas",
    path = "stickers.png",
    px = 73,
    py = 95,
}

SMODS.Sticker {
    key = "cerulean",
    atlas = "wafflemod_stickerAtlas",
    no_collection = true,
    sets = {
        Default = true
    },
    badge_colour = HEX('009CFD'),
    rate = 0.0,
}

WaffleMod.bindToModCalculate(function(context)
    if context.individual and context.other_card.ability.wafflemod_cerulean and context.cardarea == G.play then
        return {
            xmult = 3,
            message_card = context.other_card,
            no_juice = true
        }
    end
end)
