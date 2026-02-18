WaffleMod = {}

-- gotta learn ui at some point ourrhghghh i start melting like the wicked witch of the west
WaffleMod.config = SMODS.current_mod.config

assert(SMODS.load_file("functions.lua"))()
assert(SMODS.load_file("rarities.lua"))()
assert(SMODS.load_file("jokers.lua"))()
assert(SMODS.load_file("backs.lua"))()
assert(SMODS.load_file("tarots.lua"))()
assert(SMODS.load_file("spectrals.lua"))()
assert(SMODS.load_file("blinds.lua"))()
assert(SMODS.load_file("skins.lua"))()
assert(SMODS.load_file("seals.lua"))()
assert(SMODS.load_file("reverse_arcana.lua"))()
assert(SMODS.load_file("enhancements.lua"))()
assert(SMODS.load_file("vouchers.lua"))()
assert(SMODS.load_file("editions.lua"))()
assert(SMODS.load_file("arcades.lua"))()
assert(SMODS.load_file("boosters.lua"))()

if SMODS.find_mod("CardSleeves") then
    assert(SMODS.load_file("xmod/sleeves.lua"))()
end

SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
})

-- add sounds
local soundNames = {
    "icejuggler_appear",
    "icejuggler_upgrade",
    "mrdo_appear",
    "mrdo_upgrade",
    "scream",
}
for _, name in pairs(soundNames) do
    SMODS.Sound({
        key = 'wafflemod_' .. name,
        path = name .. '.ogg'
    })
end

-- wafflemod joker pool
SMODS.ObjectType({
    key = "wafflemod_jokers",
    default = "j_wafflemod_purple",
    cards = {},
    rarities = {
        {
            key = "Common",
            rate = 0.75
        },
        {
            key = "Uncommon",
            rate = 0.2
        },
        {
            key = "Rare",
            rate = 0.05
        }
    }
})
SMODS.ObjectType({
    key = "wafflemod_rx_arcana",
    default = "c_wafflemod_fool_rx",
    cards = WaffleMod.rxTarots
})
WaffleMod.hasInjected = false
local injectRef = SMODS.injectItems
function SMODS.injectItems()
    injectRef()
    if not WaffleMod.hasInjected then -- otherwise will repeat when changing language (i think)
        for i, v in ipairs(G.P_CENTER_POOLS.Joker) do
            local key = v.key
            if string.sub(key, 1, 12) == "j_wafflemod_" then
                SMODS.ObjectTypes.wafflemod_jokers:inject_card(v)
            end
        end
        -- for i, v in ipairs(WaffleMod.rxTarots) and G.P_CENTER_POOLS[v] do
        --     SMODS.ObjectTypes.wafflemod_rx_arcana:inject_card(G.P_CENTER_POOLS[v])
        -- end
        WaffleMod.hasInjected = true
    end
end
