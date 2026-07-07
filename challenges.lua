-- Trickle Down
SMODS.Challenge {
    key = "trickle_down_1",
    rules = {
        custom = {
            {id = 'no_interest'},
            {id = 'no_extra_hand_money'}
        }
    },
    jokers = {
        {
            id = "j_wafflemod_fountain",
            eternal = true
        }
    },
    restrictions = {
        banned_cards = {
            {id = "v_seed_money"},
            {id = "v_money_tree"},
            {id = "j_to_the_moon"}
        }
    }
}

-- Claustrophobia
SMODS.Challenge {
    key = "claustrophobia_1",
    rules = {
        modifiers = {
            {id = "hand_size", value = 5},
            {id = "discards", value = 4},
        }
    },
    jokers = {
        {
            id = "j_wafflemod_aaaaaa",
            eternal = true
        }
    },
    consumeables = {
        {
            id = "c_death"
        },
        {
            id = "c_death"
        }
    },
    deck = {
        type = "Challenge Deck",
        no_ranks = {
            J = true,
            Q = true,
            K = true
        },
        -- cards = {
        --     {s = "S", r = "A"},
        --     {s = "S", r = "A"},
        --     {s = "H", r = "A"},
        --     {s = "H", r = "A"},
        --     {s = "C", r = "A"},
        --     {s = "C", r = "A"},
        --     {s = "D", r = "A"},
        --     {s = "D", r = "A"},
        --     { s = 'C', r = 'T' },
        --     { s = 'D', r = 'T' },
        --     { s = 'H', r = 'T' },
        --     { s = 'S', r = 'T' },
        --     { s = 'C', r = '9' },
        --     { s = 'D', r = '9' },
        --     { s = 'H', r = '9' },
        --     { s = 'S', r = '9' },
        --     { s = 'C', r = '8' },
        --     { s = 'D', r = '8' },
        --     { s = 'H', r = '8' },
        --     { s = 'S', r = '8' },
        --     { s = 'C', r = '7' },
        --     { s = 'D', r = '7' },
        --     { s = 'H', r = '7' },
        --     { s = 'S', r = '7' },
        --     { s = 'C', r = '6' },
        --     { s = 'D', r = '6' },
        --     { s = 'H', r = '6' },
        --     { s = 'S', r = '6' },
        --     { s = 'C', r = '5' },
        --     { s = 'D', r = '5' },
        --     { s = 'H', r = '5' },
        --     { s = 'S', r = '5' },
        --     { s = 'C', r = '4' },
        --     { s = 'D', r = '4' },
        --     { s = 'H', r = '4' },
        --     { s = 'S', r = '4' },
        --     { s = 'C', r = '3' },
        --     { s = 'D', r = '3' },
        --     { s = 'H', r = '3' },
        --     { s = 'S', r = '3' },
        -- }
    }
}