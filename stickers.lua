SMODS.Atlas {
    key = "wafflemod_stickerAtlas",
    path = "stickers.png",
    px = 73,
    py = 95,
}

SMODS.Sticker {
    key = "cerulean",
    atlas = "wafflemod_stickerAtlas",
    sets = {
        Default = true
    },
    badge_colour = HEX('009CFD'),
    rate = 0.0,
    calculate = function(self, card, context)
        if context.individual and context.other_card.ability.wafflemod_cerulean and context.cardarea == G.play then
            print("hello!")
            return {
                xmult = 3,
                message_card = context.other_card,
            }
        end
    end
}

WaffleMod.bindToModCalculate(function(context)
    if context.individual and context.other_card.ability.wafflemod_cerulean and context.cardarea == G.play then
        --print("scored")
        return {
            xmult = 3,
            message_card = context.other_card,
            no_juice = true
        }
        -- return {
        --     func = function ()
        --         SMODS.calculate_effect(
        --     {
        --         xmult = 3
        --     },
        --     context.other_card
        -- )
        --     end
        -- }
    end
end)
