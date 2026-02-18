SMODS.Atlas{
    key = "wafflemod_boosterAtlas",
    path = "boosters.png",
    px = 71,
    py = 95,
}

SMODS.Booster {
    key = "arcade_normal_1",
    weight = 0.6,
    kind = 'wafflemod_arcade',
    cost = 4,
    atlas = "wafflemod_boosterAtlas",
    pos = { x = 1, y = 0 },
    config = { extra = 3, choose = 1 },
    draw_hand = false,
    select_card = "consumeables",
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.arcade_cabinets.enabled)
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3)
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.TAROT_PACK)
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.GREEN, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.BLUE, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        local _card
            _card = {
                set = "wafflemod_arcade",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append =
                "wafflemod_arcade"
            }
        return _card
    end,
    in_pool = function ()
        return WaffleMod.config.arcade_cabinets.enabled
    end
}

SMODS.Booster {
    key = "arcade_normal_2",
    weight = 0.6,
    kind = 'wafflemod_arcade',
    cost = 4,
    atlas = "wafflemod_boosterAtlas",
    pos = { x = 2, y = 0 },
    config = { extra = 3, choose = 1 },
    draw_hand = false,
    select_card = "consumeables",
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        WaffleMod.addDisabledTooltip(info_queue, WaffleMod.config.arcade_cabinets.enabled)
        return {
            vars = { cfg.choose, cfg.extra },
            key = self.key:sub(1, -3)
        }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.TAROT_PACK)
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.GREEN, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.BLUE, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
    create_card = function(self, card, i)
        local _card
            _card = {
                set = "wafflemod_arcade",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append =
                "wafflemod_arcade"
            }
        return _card
    end,
    in_pool = function ()
        return WaffleMod.config.arcade_cabinets.enabled
    end
}