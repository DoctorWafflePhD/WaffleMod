SMODS.Atlas {
    key = "voucherAtlas",
    path = "vouchers.png",
    px = 71,
    py = 95,
}

local config = WaffleMod.config

-- Hunting License
-- (See jokers.lua for boss joker drop implementation)
SMODS.Voucher {
    key = "hunting_license",
    atlas = "voucherAtlas",
    pos = { x = 1, y = 0 },
    config = { extra = {
        boost = 2
    } },
    loc_vars = function(self, info_queue, card)
        WaffleMod.addDisabledTooltip(info_queue, config.boss_jokers.enabled)
        return { vars = { card.ability.extra.boost } }
    end,
    in_pool = function()
        return WaffleMod.config.boss_jokers.enabled
    end
}

-- Trophy Collector
SMODS.Voucher {
    key = "trophy_collector",
    atlas = "voucherAtlas",
    pos = { x = 1, y = 1 },
    requires = { 'v_wafflemod_hunting_license' },
    loc_vars = function(self, info_queue)
        WaffleMod.addDisabledTooltip(info_queue, config.boss_jokers.enabled)
    end,
    in_pool = function()
        return WaffleMod.config.boss_jokers.enabled
    end
}

-- Insert Coin
SMODS.Voucher {
    key = "insert_coin",
    atlas = "voucherAtlas",
    pos = { x = 2, y = 0 },
    config = { extra = { rate = 4 } },
    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = "wafflemod_arcade_hint", set = "Other", config = {} }
        WaffleMod.addDisabledTooltip(info_queue, config.arcade_cabinets.enabled)
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.wafflemod_arcade_rate = card.ability.extra.rate
                return true
            end
        }))
    end,
    in_pool = function()
        return WaffleMod.config.arcade_cabinets.enabled
    end
}

-- Kill Screen
local killScreenNegativeChance = 1 / 12
SMODS.Voucher {
    key = "kill_screen",
    atlas = "voucherAtlas",
    pos = { x = 2, y = 1 },
    requires = { 'v_wafflemod_insert_coin' },
        loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = { key = "wafflemod_arcade_hint", set = "Other", config = {} }
        info_queue[#info_queue + 1] = { key = "e_negative_consumable", set = "Edition", config = {extra = 1} }
        WaffleMod.addDisabledTooltip(info_queue, config.arcade_cabinets.enabled)
    end,
    in_pool = function()
        return WaffleMod.config.arcade_cabinets.enabled
    end
}
WaffleMod.bindToModCalculate(function(context)
    if G.GAME.used_vouchers["v_wafflemod_kill_screen"] and context.modify_shop_card and context.card.ability.set == "wafflemod_arcade" then
        local rollForNegative = pseudorandom("wafflemod_killscreen") < killScreenNegativeChance
        if rollForNegative then
            context.card:set_edition("e_negative", true)
        end
    end
end)
