SMODS.Rarity {
    key = "Boss",
        loc_txt = {
        name = "Boss"
    },
    default_weight = 0,
    badge_colour = HEX('E08B4A'),
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

SMODS.Rarity {
    key = "Showdown",
        loc_txt = {
        name = "Showdown"
    },
    default_weight = 0,
    badge_colour = HEX('e0ba48'),
    get_weight = function(self, weight, object_type)
        return weight
    end,
}