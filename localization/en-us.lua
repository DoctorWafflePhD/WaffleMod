return {

    descriptions = {

        Back = {

            b_wafflemod_arcade = {
                name = "Arcade Deck",
                text = {
                    "Start with Extra Credit voucher",
                    "Arcade Cabinets cost {C:money}$1{} to use", }
            },

            b_wafflemod_blighted = {
                name = "Blighted Deck",
                text = {
                    "Start with {C:money,T:v_clearance_sale}Clearance Sale{}",
                    "All Jokers are {C:attention,T:perishable}Perishable{}",
                    "Gain {C:attention}+#1#{} Joker slot for every",
                    "{C:attention}#2#{} {C:inactive}[#3#]{} debuffed Jokers sold"
                }
            },

            b_wafflemod_hunting = {
                name = "Hunting Deck",
                text = {
                    "Start with {C:attention,T:v_wafflemod_hunting_license}Hunting License",
                    "and a {C:attention,T:j_wafflemod_trophy_hunters_tricorn}Trophy Hunter's Tricorn",
                }
            },

            b_wafflemod_hunting_disabled = {
                name = "Hunting Deck",
                text = {
                    "{C:wafflemod_boss}Boss Jokers{} are currently {C:red}disabled{}",
                    "This deck will have {C:red}no effect{}",
                }
            },

            b_wafflemod_mirage = {
                name = "Mirage Deck",
                text = {
                    "When Blind is selected,",
                    "create #1# {C:dark_edition,T:e_wafflemod_ephemeral}Ephemeral{} Jokers"
                }
            },

            b_wafflemod_patchwork = {
                name = "Patchwork Deck",
                text = {
                    "{C:attention}+#1#{} Joker slot",
                    "Rightmost Joker",
                    "is {C:attention}debuffed{}"
                }
            },

            b_wafflemod_waffle = {
                name = "Waffle Deck",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "replace Jokers in shop",
                    "with {C:attention}WaffleMod Jokers{}"
                }
            }

        },

        Blind = {

            bl_wafflemod_axe = {
                name = "The Axe",
                text = {
                    "Discards cost $3"
                }
            },

            bl_wafflemod_gate = {
                name = "The Gate",
                text = {
                    "Played cards lose",
                    "their enhancements"
                }
            },

            bl_wafflemod_tail = {
                name = "The Tail",
                text = {
                    "Decrease rank of",
                    "played cards by 1"
                }
            },

            bl_wafflemod_union = {
                name = "The Union",
                text = {
                    "Played hand must have",
                    "2 or more scoring cards"
                }
            },

        },

        Edition = {

            e_wafflemod_ephemeral = {
                name = "Ephemeral",
                text = {
                    "{C:attention}+1{} area slot",
                    "{C:red,E:2}Self destructs{} at",
                    "end of round"
                }
            },
            e_wafflemod_ephemeral_consumable = {
                name = "Ephemeral",
                text = {
                    "{C:attention}+1{} consumable slot",
                    "{C:red,E:2}Self destructs{} at",
                    "end of round"
                }
            },
            e_wafflemod_ephemeral_joker = {
                name = "Ephemeral",
                text = {
                    "{C:attention}+1{} Joker slot",
                    "{C:red,E:2}Self destructs{} at",
                    "end of round"
                }
            },
            e_wafflemod_ephemeral_playing_card = {
                name = "Ephemeral",
                text = {
                    "{C:attention}+1{} hand size",
                    "{C:red,E:2}Self destructs{} when",
                    "played, discarded,",
                    "or at end of round"
                }
            },
        },

        Enhanced = {
            m_wafflemod_scribbled = {
                name = "Scribbled Card",
                text = {
                    "Counts as",
                    "a {C:attention}face card{}"
                },
            },
        },

        Joker = {

            j_wafflemod_blueberry_jam = {
                name = "Blueberry Jam",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "{C:mult}-#2#{} Mult for each",
                    "card held in hand",
                    "after hand played"
                },
            },

            j_wafflemod_broken_record = {
                name = "Broken Record",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "per {C:attention}consecutive{} play",
                    "of the same {C:attention}poker hand",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },

            j_wafflemod_fickle = {
                name = "Fickle Joker",
                text = {
                    "This Joker gains {C:chips}+#1#{} Chips when",
                    "cards with {V:1}#2#{} suit are scored",
                    "Loses {C:chips}-#3#{} Chips when",
                    "other suits are scored",
                    "{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips){}",
                    "{C:inactive}(Suit changes at end of round){}"
                }
            },

            j_wafflemod_golden_goose_egg = {
                name = "Golden Goose Egg",
                text = {
                    "Gains {C:money}$#1#{} of sell value",
                    "when a {C:tarot}Tarot{} card is used"
                }
            },

            j_wafflemod_golfer = {
                name = "Golfer",
                text = {
                    "{V:1}#1#{} cards held in hand",
                    "each give {C:mult}+#2#{} Mult"
                }
            },

            j_wafflemod_dreamsicle = {
                name = "Dreamsicle",
                text = {
                    "Earn {C:money}$#1#{} on your next",
                    "{C:attention}#2#{} card purchases"
                }
            },

            j_wafflemod_fountain = {
                name = "Fountain",
                text = {
                    "Played cards have a",
                    "{C:green}#1# in (rank){} chance to",
                    "earn {C:money}$#2#{} when {C:attention}scored{}"
                }
            },

            j_wafflemod_in_the_rough = {
                name = "In the Rough",
                text = {
                    "First scored card with",
                    "{V:1}#1#{} suit gives",
                    "{C:white,X:mult}X#2#{} Mult for each",
                    "non-{V:1}#1#{} card in {C:attention}full deck",
                    "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)"

                }
            },

            j_wafflemod_instant_mac_and_cheese = {
                name = "Instant Mac & Cheese",
                text = {
                    "After playing {C:attention}#1#{} hands, upgrade",
                    "next played hand {C:attention}#2#{} times",
                    "{C:inactive}(Currently {C:attention}#3#{C:inactive}/#1#)"
                }
            },

            j_wafflemod_purple = {
                name = "Purple Joker",
                text = {
                    "{C:chips}+#1#{} Chips for each",
                    "card {C:attention}discarded{}, resets",
                    "after each hand played",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips){}"
                }
            },

            j_wafflemod_miner = {
                name = "Miner",
                text = {
                    "Played {C:attention}Stone{} cards lose",
                    "their {C:enhanced}Enhancement{}, but",
                    "gain a {C:attention}Gold Seal{}"
                },
            },

            j_wafflemod_motley = {
                name = "Motley Joker",
                text = {
                    "{C:hearts}Hearts{} and {C:diamonds}Diamonds{} give",
                    "{C:mult}+#1#{} Mult when scored,",
                    "{C:spades}Spades{} and {C:clubs}Clubs{} give",
                    "{C:chips}+#2#{} Chips when scored"
                }
            },

            j_wafflemod_mystery_gift = {
                name = "Mystery Gift",
                text = {
                    "{C:green}#1# in #2#{} chance to create a",
                    "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
                    "{C:dark_edition}Polychrome{} tag",
                    "at end of round"
                }
            },

            j_wafflemod_damocles = {
                name = "Damocles",
                text = {
                    "Earn {C:money}$#1#{} at end of round",
                    "{C:green}#2# in #3#{} chance to {C:attention}destroy{}",
                    "a random Joker after",
                    "each hand played"
                }
            },

            j_wafflemod_fortune_iii = {
                name = "Fortune III",
                text = {
                    "{C:attention}Retrigger{} all played",
                    "{C:attention}Stone{} cards, {C:green}#1# in #2#{} chance",
                    "to {C:attention}retrigger{} them again"
                }
            },

            j_wafflemod_jok = {
                name = "jok",
                text = {
                    "This Joker gains {X:mult,C:white}X#1#{} Mult every",
                    "time {C:tarot,T:c_tower}The Tower{} is used",
                    "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
                },
            },

            j_wafflemod_jokerton = {
                name = "Jokerton",
                text = {
                    "Every {C:attention}#1# {C:inactive}[#2#] {C:hearts}Hearts{} cards discarded,",
                    "enhance {C:attention}first card{} of next",
                    "hand played to a {C:attention}Steel Card{}"
                }
            },

            j_wafflemod_martian = {
                name = "Martian",
                text = {
                    "Using a {C:planet}Planet Card{} has",
                    "has a {C:green}#1# in #2#{} chance to",
                    "create a {C:spectral}Spectral Card{}",
                    "{C:inactive}(Must have room)"
                }
            },

            j_wafflemod_pop_art = {
                name = "Pop Art",
                text = {
                    "Earn {C:money}$#1#{} at end of round, increases",
                    "by {C:money}$#2#{} for each {V:1}#3#{} card in {C:attention}scoring hand{},",
                    "{s:0.85}value resets and suit changes at end of round"
                }
            },

            j_wafflemod_scene = {
                name = "Scene Joker",
                text = {
                    "{C:white,X:mult}X#1#{} Mult if {C:attention}no cards{}",
                    "with {V:1}#2#{} suit have",
                    "been {C:attention}played{} this round"
                }
            },

            j_wafflemod_snowman = {
                name = "Snowman",
                text = {
                    "Earn {C:money}$#1#{} at end of round",
                    "Payout increases by {C:money}$#2#{} if",
                    "{C:attention}Blind{} is defeated {C:attention}in one hand{}"
                }
            },

            j_wafflemod_stage_magician = {
                name = "Stage Magician",
                text = {
                    "When round begins,",
                    "add {C:attention}#1#{} random {C:dark_edition}Ephemeral{}",
                    "playing cards to hand",
                }
            },

            j_wafflemod_aaaaaa = {
                name = "AAAAAA",
                text = {
                    "Played {C:attention}Aces{} give {C:white,X:mult}+X#1#{} Mult",
                    "when scored for every",
                    "{C:attention}Ace{} in scoring hand"
                }
            },

            j_wafflemod_bring_me_your_love = {
                name = "Bring Me Your Love",
                text = {
                    "When round begins, bring",
                    "cards with {C:hearts}#1#{} suit",
                    "to the {C:attention}top{} of your deck"
                }
            },

            j_wafflemod_bring_me_your_love_vampire = {
                name = "Bring Me Your Love",
                text = {
                    "When round begins, bring",
                    "cards with {C:hearts}#1#{} suit",
                    "to the {C:attention}top{} of your deck",
                    "{C:inactive}\"I'll never let them",
                    "{C:inactive}hurt you, I promise\""
                }
            },

            j_wafflemod_darkroom = {
                name = "Darkroom",
                text = {
                    "Using a non-{C:dark_edition,T:e_negative}Negative{} {C:tarot}Tarot{},",
                    "{C:planet}Planet{}, or {C:spectral}Spectral{} card has",
                    "a {C:green}#1# in #2#{} chance of creating",
                    "a {C:dark_edition}Negative{} copy"
                },
            },

            j_wafflemod_freddie_mercury = {
                name = "Freddie Mercury",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "when a {C:attention}Queen{} is scored,",
                    "and {C:white,X:mult}X#2#{} Mult when",
                    "{C:planet}Mercury{} is used",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult",
                    "{C:inactive}and {C:white,X:mult}X#4#{C:inactive} Mult)"
                },
            },

            j_wafflemod_fuzzy_pickle = {
                name = "Fuzzy Pickle",
                text = {
                    "{C:attention}Jokers{} that reference",
                    "{C:attention}pop culture{} give {C:white,X:mult}X#1#{} Mult",
                }
            },

            j_wafflemod_trophy_hunters_tricorn = {
                name = "Trophy Hunter's Tricorn",
                text = { "Sell this card to",
                    "disable the current",
                    "{C:attention}Boss Blind{} and spawn",
                    "its matching {C:wafflemod_boss}Boss Joker{}",
                }
            },

            j_wafflemod_trophy_hunters_tricorn_edition = {
                name = "Trophy Hunter's Tricorn",
                text = { "Sell this card to",
                    "disable the current",
                    "{C:attention}Boss Blind{} and spawn",
                    "its matching {C:wafflemod_boss}Boss Joker{}",
                    "{C:inactive}(Copies this card's Edition)"
                }
            },

            j_wafflemod_doctorwaffle_0 = {
                name = "DoctorWaffle",
                text = {
                    '"Huh? What?',
                    'How\'d I get here?"',
                }
            },

            j_wafflemod_doctorwaffle_1 = {
                name = "DoctorWaffle",
                text = {
                    "Oh, I get it. I'm a {C:legendary}Legendary{} Joker because I'm a",
                    "{C:attention}fool{} for adding a dev self-insert. How original of me.\"",
                }
            },

            j_wafflemod_doctorwaffle_2 = {
                name = "DoctorWaffle",
                text = {
                    '"But uh, sorry for the confusion. Just {C:attention}sell{} me, I\'ll get an ',
                    "actual {C:legendary}Legendary{} for you. Hell, I'll even make it {C:dark_edition}Negative{}.\"",
                }
            },

            j_wafflemod_doctorwaffle_collection = {
                name = "DoctorWaffle",
                text = {
                    "''It's kinda boring in here. All I ",
                    'have is a DVD copy of {C:attention}SharkTale{}."'
                }
            },

            j_wafflemod_ice_juggler_cookie = {
                name = "Ice Juggler Cookie",
                text = {
                    "{C:attention}+#1#{} hand size",
                    "This Joker gains {C:white,X:mult}X#2#{} Mult if a",
                    "{C:diamonds}Diamond{} card, {C:clubs}Club{} card,",
                    "{C:hearts}Heart{} card, and {C:spades}Spade{} card",
                    "are held in hand",
                    "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult){}"
                }
            },

            j_wafflemod_mrdo = {
                name = "Mr. Do!",
                text = {
                    "This Joker gains {X:mult,C:white}X#2#{} Mult",
                    "after an {C:attention}Ace{}, {C:attention}King{}, {C:attention}Queen{},",
                    "and {C:attention}Jack{} have been scored",
                    "{C:inactive}({V:1}A{V:2}K{V:3}Q{V:4}J{C:inactive})",
                    "{C:inactive}(Currently {C:white,X:mult}X#1#{C:inactive} Mult)"
                }
            },

            j_wafflemod_arm = {
                name = "The Arm",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "upgrade level of",
                    "played {C:attention}poker hand{}",
                }
            },

            j_wafflemod_club = {
                name = "The Club",
                text = {
                    "This Joker gains",
                    "{C:white,X:mult}X#1#{} Mult when a",
                    "card with {C:clubs}#2#{}",
                    "suit is scored",
                    "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)"
                }
            },

            j_wafflemod_goad = {
                name = "The Goad",
                text = {
                    "This Joker gains",
                    "{C:white,X:mult}X#1#{} Mult when a",
                    "card with {C:spades}#2#{}",
                    "suit is scored",
                    "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)"
                }
            },

            j_wafflemod_head = {
                name = "The Head",
                text = {
                    "This Joker gains",
                    "{C:white,X:mult}X#1#{} Mult when a",
                    "card with {C:hearts}#2#{}",
                    "suit is scored",
                    "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)"
                }
            },

            j_wafflemod_hook = {
                name = "The Hook",
                text = {
                    "Earn {C:money}$#1#{} for each",
                    "card {C:attention}held in hand{}",
                    "at end of round"
                }
            },

            j_wafflemod_manacle = {
                name = "The Manacle",
                text = {
                    "{C:attention}+#1#{} hand size"
                }
            },

            j_wafflemod_needle = {
                name = "The Needle",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "lose all but {C:blue}1 {}Hand and",
                    "gain {C:white,X:mult}X#1#{} Mult for",
                    "{C:attention}each hand lost,",
                    "resets at {C:attention}end of round",
                    "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
                }
            },

            j_wafflemod_ox = {
                name = "The Ox",
                text = {
                    "If {C:attention}poker hand{} is your",
                    "{C:attention}most played{} poker hand, each",
                    "card earns {C:money}$#1#{} when scored",
                    --"{C:inactive}(Currently {C:attention}#2#{C:inactive})"
                }
            },

            j_wafflemod_pillar = {
                name = "The Pillar",
                text = {
                    "Every played {C:attention}card{}",
                    "permanently gains",
                    "{C:mult}+#1#{} Mult when scored",
                },
            },

            j_wafflemod_psychic = {
                name = "The Psychic",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for each",
                    "card in scored hand"
                }
            },

            j_wafflemod_serpent = {
                name = "The Serpent",
                text = {
                    "After {C:attention}Play or Discard{},",
                    "increase hand size by {C:attention}#1#{}",
                    "until end of round"
                }
            },

            j_wafflemod_wall = {
                name = "The Wall",
                text = {
                    "{C:white,X:mult}X#1#{} Mult"
                }
            },

            j_wafflemod_water = {
                name = "The Water",
                text = {
                    "{X:mult,C:white}X#1#{} Mult for each",
                    "{C:attention}discard{} remaining",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                }
            },

            j_wafflemod_wheel = {
                name = "The Wheel",
                text = {
                    "{C:green}#1# in #2#{} chance to add",
                    "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or {C:dark_edition}Polychrome{}",
                    "to each card in scoring hand"
                }
            },

            j_wafflemod_window = {
                name = "The Window",
                text = {
                    "This Joker gains",
                    "{C:white,X:mult}X#1#{} Mult when a",
                    "card with {C:diamonds}#2#{}",
                    "suit is scored",
                    "{C:inactive}(Currently {C:white,X:mult}X#3#{C:inactive} Mult)"
                }
            },

            j_wafflemod_amber_acorn = {
                name = "Amber Acorn",
                text = {
                    "Jokers to the {C:attention}left{} give {C:white,X:mult}X#1#{} Mult",
                    "Jokers to the {C:attention}right{} give {C:money}$#2#{}"
                }
            },

            j_wafflemod_cerulean_bell = {
                name = "Cerulean Bell",
                text = {
                    "Adds a {C:attention}Cerulean Sticker{}",
                    "to a random card in hand"
                }
            },

            j_wafflemod_crimson_heart = {
                name = "Crimson Heart",
                text = {
                    "{C:attention}+#1#{} Joker slots"
                }
            },

            j_wafflemod_verdant_leaf = {
                name = "Verdant Leaf",
                text = {
                    "Whenever a Joker is {C:attention}sold{}, add",
                    "{C:attention}#1#%{} of its {C:attention}sell value{} to",
                    "this Joker as {C:white,X:mult}XMult{}",
                    "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult)"
                }
            },

            j_wafflemod_violet_vessel = {
                name = "Violet Vessel",
                text = {
                    "{C:white,X:mult}X#1#{} Mult per {C:attention}Ante{}",
                    "{C:inactive}(Currently {C:white,X:mult}X#2#{C:inactive} Mult,",
                    "{C:inactive,s:0.85}minimum of {C:white,X:mult,s:0.85}X#3#{C:inactive,s:0.85} Mult)"
                }
            }

        },

        Spectral = {

            c_wafflemod_egregore = {
                name = "Egregore",
                text = {
                    "Add an {C:wafflemod_ivory}Ivory Seal{}",
                    "to {C:attention}1{} selected",
                    "card in your hand",
                },
            },

            c_wafflemod_psychopomp = {
                name = "Psychopomp",
                text = {
                    "Add an {C:wafflemod_ebony}Ebony Seal{}",
                    "to {C:attention}1{} selected",
                    "card in your hand",
                },
            },

            c_wafflemod_ritual = {
                name = "Ritual",
                text = {
                    "{C:green}#1# in #2#{} chance to add",
                    "a random {C:enhanced}Enhancement{} to",
                    "each card in hand"
                },
            },

            c_wafflemod_polybius = {
                name = "Polybius",
                text = {
                    "When {C:attention}used:{} Spend {C:money}$#1#{} to",
                    "add {C:dark_edition}Negative{} edition",
                    "to {C:attention}1{} selected card",
                    "While {C:attention}held:{} {C:dark_edition}Negative{} cards",
                    "give {C:mult}+#2#{} Mult when scored"
                }
            },

        },

        Tag = {
            tag_wafflemod_photocopy = {
                name = "Photocopy Tag",
                text = {
                    "Next Joker purchased",
                    "in Shop immediately puts",
                    "a copy of it on sale"
                }
            }
        },

        Tarot = {

            c_wafflemod_well = {
                name = "The Well",
                text = {
                    "Create an {C:dark_edition}Ephemeral{} copy",
                    "of {C:attention}1{} selected Joker"
                }
            },

            c_wafflemod_artist = {
                name = "The Artist",
                text = {
                    "Enhances {C:attention}#1#",
                    "selected cards to",
                    "{C:attention}#2#s",
                }
            },

            c_wafflemod_fool_rx = {
                name = string.reverse("The Fool"),
                text = {
                    "{C:attention}Reverses{} all {C:tarot}Tarot{}",
                    "cards on screen",
                }
            },

            c_wafflemod_magician_rx = {
                name = string.reverse("The Magician"),
                text = {
                    "Permanently add {C:attention}#1#{} retrigger",
                    "to up to {C:attention}#2# Lucky Cards"
                }
            },

            c_wafflemod_high_priestess_rx = {
                name = string.reverse("The High Priestess"),
                text = {
                    "Upgrade {C:attention}#1#{}",
                    "by {C:attention}#2# levels{}"
                }
            },

            c_wafflemod_hermit_rx = {
                name = string.reverse("The Hermit"),
                text = {
                    "Make cards and booster packs",
                    "currently in the Shop free"
                }
            },

            c_wafflemod_temperance_rx = {
                name = string.reverse("Temperance"),
                text = {
                    "Sell the selected {C:attention}Joker{} for",
                    "{C:attention}triple{} its sell value",
                }
            },

            c_wafflemod_wheel_of_fortune_rx = {
                name = string.reverse("The Wheel of Fortune"),
                text = {
                    "{C:green}#1# in #2#{} chance to either",
                    "add {C:dark_edition}Negative{} to or {C:attention}destroy",
                    "a random Joker"
                }
            },

            c_wafflemod_artist_rx = {
                name = string.reverse("The Artist"),
                text = {
                    "Destroys all {C:attention}face{}",
                    "cards in hand",
                }
            },

        },

        Voucher = {

            v_wafflemod_hunting_license = {
                name = "Hunting License",
                text = {
                    "{C:attention}Boss Jokers{} appear",
                    "{C:attention}#1#X{} more frequently after",
                    "defeating a {C:attention}Boss Blind{}",
                    "{C:inactive}(Must have room){}"
                }
            },

            v_wafflemod_trophy_collector = {
                name = "Trophy Collector",
                text = {
                    "If {C:attention}Boss Blind{} is defeated in one",
                    "hand, its respective {C:attention}Boss Joker{}",
                    "is {C:attention}guaranteed{} to appear",
                    "{C:inactive}(Must have room){}"
                }
            },

            v_wafflemod_insert_coin = {
                name = "Insert Coin",
                text = {
                    "{C:wafflemod_arcade}Arcade Cabinets{}",
                    "can be purchased",
                    "from the {C:attention}shop{}"
                }
            },

            v_wafflemod_kill_screen = {
                name = "Kill Screen",
                text = {
                    "{C:wafflemod_arcade}Arcade Cabinets{}",
                    "in {C:attention}shop{} can appear",
                    "with {C:dark_edition}Negative{} edition"
                }
            }

        },

        Other = {

            p_wafflemod_arcade_normal = {
                name = "Arcade Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{C:wafflemod_arcade} Arcade Cabinets{} to",
                    "add to your consumable area",
                },
            },

            r_j_hit_the_road = {
                name = "Reference",
                text = {"Ray Charles"}
            },

            r_j_seeing_double = {
                name = "Reference",
                text = {"S Club 7"}
            },

            r_j_wafflemod_fuzzy_pickle = {
                name = "Reference",
                text = {"Earthbound"}
            },

            r_generic = {
                name = "Reference",
                text = {
                    "This card counts as a",
                    "{C:attention}pop culture{} reference"
                }
            },

            r_cookie_run = {
                name = "Reference",
                text = { "Cookie Run" }
            },

            r_deadlock = {
                name = "Reference",
                text = { "Deadlock" }
            },

            r_earthbound = {
                name = "Reference",
                text = { "Earthbound" }
            },

            r_mcr = {
                name = "Reference",
                text = { 
                    "My Chemical",
                    "Romance" }
            },

            r_minecraft = {
                name = "Reference",
                text = { "Minecraft" }
            },

            r_mrdo = {
                name = "Reference",
                text = { "Mr. Do!" }
            },

            r_queen = {
                name = "Reference",
                text = { "Queen" }
            },

            r_ror = {
                name = "Reference",
                text = { "Risk of Rain" }
            },

            r_tadc = {
                name = "Reference",
                text = { 
                    "The Amazing",
                    "Digital Circus" 
                }
            },

            r_weezer = {
                name = "Reference",
                text = { "Weezer" }
            },

            r_yume_nikki = {
                name = "Reference",
                text = { "Yume Nikki" }
            },

            wafflemod_copper_seal = {
                name = "Copper Seal",
                text = {
                    "Earn {C:money}$#1#{} for",
                    "each {C:wafflemod_copper}Copper Seal{}",
                    "in your {C:attention}full deck{}",
                    "at end of round",
                    "{C:inactive}(Currently {C:money}$#2#{C:inactive})"
                }
            },

            wafflemod_ebony_seal = {
                name = "Ebony Seal",
                text = {
                    "{C:attention}+1{} hand size",
                    "for the round",
                    "when {C:attention}discarded{}"
                }
            },

            -- Version with chance listed (unused)
            wafflemod_ivory_seal = {
                name = "Ivory Seal",
                text = {
                    "Creates a {C:spectral}Spectral{} card",
                    "and has a {C:green}#1# in #2#{} chance",
                    "to add an {C:wafflemod_ivory}Ivory Seal",
                    "to a random card {C:attention}in deck{}",
                    "when {C:attention}destroyed{}",
                    "{C:inactive}(Must have room){}"
                }
            },

            wafflemod_ivory_seal = {
                name = "Ivory Seal",
                text = {
                    "Creates a {C:spectral}Spectral{} card",
                    "and adds an {C:wafflemod_ivory}Ivory Seal{}",
                    "to a random card {C:attention}in deck{}",
                    "when {C:attention}destroyed{}",
                    "{C:inactive}(Must have room){}"
                }
            },

            wafflemod_viridian_seal = {
                name = "Viridian Seal",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "{C:attention}level up{} poker hand",
                    "if part of {C:attention}scoring hand{}"
                }
            },


            wafflemod_sharktale = {
                name = "SharkTale",
                text = {
                    "Dumbass fish movie",
                    "made by {C:attention}DreamWorks{}"
                }
            },

            wafflemod_arcade_hint = {
                name = "Arcade Cabinet",
                text = {
                    "Costs {C:money}money{} to use,",
                    "but is {C:attention}not{} consumed"
                }
            },

            wafflemod_arcade_hint_perkeo = {
                name = "Arcade Cabinet",
                text = {
                    "Costs {C:money}money{} to use,",
                    "but is {C:attention}not{} consumed",
                    "{C:inactive}(Cannot be copied by Perkeo)"
                }
            },

            undiscovered_wafflemod_arcade = {
                name = "Not Discovered",
                text = {
                    "Purchase or use",
                    "this card in an",
                    "unseeded run to",
                    "learn what it does",
                },
            },

            wafflemod_art_credit_jac = {
                name = "Guest Artist",
                text = {
                    "Jac1231"
                }
            },

            wafflemod_disabled_tooltip = {
                name = "Disabled",
                text = {
                    "This feature is",
                    "currently {C:red}disabled",
                    "in the mod's config"
                }
            },

            wafflemod_cerulean = {
                name = "Cerulean",
                text = {
                    "{C:white,X:mult}X3{} Mult",
                    "{C:inactive,s:0.85}(Sticker removed",
                    "{C:inactive,s:0.85}after Play or Discard)"
                }
            }

        },

        wafflemod_arcade = {

            c_wafflemod_asteroids = {
                name = "Asteroids",
                text = {
                    "When {C:attention}used:{} Spend {C:money}$#1#{} to",
                    "create a random Planet card",
                    "{C:inactive}(Must have room)",
                    "While {C:attention}held:{} Destroying a Stone Card",
                    "levels up your most played poker hand"
                }
            },

            c_wafflemod_crystal_castles = {
                name = "Crystal Castles",
                text = {
                    "When {C:attention}used:{} Spend {C:money}$#1#{} to",
                    "add 2 Ephemeral Diamond cards to hand",
                    "While {C:attention}held:{} Cards with Diamond suit",
                    "add their rank to Mult when scored"
                }
            },

            c_wafflemod_dig_dug = {
                name = "Dig Dug",
                text = {
                    "When {C:attention}used:{} Spend {C:money}$#1#{} to enhance",
                    "{C:attention}1{} selected card into a {C:attention}Stone Card{}",
                    "While {C:attention}held:{} Create a {C:tarot}Tarot Card{}",
                    "after every {C:attention}#2#{} {C:inactive}[#3#]{} {C:attention}Stone Cards{} played",
                    "{C:inactive}(Must have room)"
                },
            },

            c_wafflemod_metro_cross = {
                name = "Metro-Cross",
                text = {
                    "When {C:attention}used:{} Spend {C:money}$#1#{} to",
                    "create a random {C:attention}Tag{}",
                    "While {C:attention}held:{} Skipping a Blind creates",
                    "a random {C:spectral}Spectral Card{}",
                    "{C:inactive}(Must have room){}"
                }
            },

            c_wafflemod_pacman = {
                name = "Pac-Man",
                text = {
                    "When {C:attention}used:{} Spend {C:money}$#1#{} to enhance",
                    "{C:attention}1{} selected card into a {C:attention}Wild Card{}",
                    "While {C:attention}held:{} {C:white,X:mult}X#2#{} Mult first",
                    "time each unique {C:attention}suit{} is scored"
                },
            },

            c_wafflemod_space_invaders = {
                name = "Space Invaders",
                text = {
                    "When {C:attention}used:{} Spend {C:money}$#1#{} to",
                    "create a random {C:planet}Planet{} card",
                    "While {C:attention}held:{} Using a {C:planet}Planet{} card also",
                    "upgrades a random {C:attention}poker hand{}"
                }
            },

        },

        Sleeve = {
            sleeve_wafflemod_waffle = {
                name = "Waffle Sleeve",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "replace Jokers in shop",
                    "with {C:attention}WaffleMod Jokers{}"
                }
            },
            sleeve_wafflemod_waffle_alt = {
                name = "Waffle Sleeve",
                text = {
                    "{C:attention}WaffleMod{} Jokers",
                    "cost {C:money}$#1#{} less"
                }
            },
            sleeve_wafflemod_blighted = {
                name = "Blighted Sleeve",
                text = {
                    "All Jokers are {C:attention,T:perishable}Perishable{}",
                    "Gain {C:attention}+#1#{} Joker slot for every",
                    "{C:attention}#2#{} {C:inactive}[#3#]{} debuffed Jokers sold"
                }
            },
            sleeve_wafflemod_blighted_alt = {
                name = "Blighted Sleeve",
                text = {
                    "Earn {C:money}$#1#{} whenever a",
                    "debuffed Joker is sold"
                }
            },
            sleeve_wafflemod_hunting = {
                name = "Hunting Sleeve",
                text = {
                    "Start with {C:attention,T:v_wafflemod_hunting_license}Hunting License",
                }
            },
            sleeve_wafflemod_hunting_alt = {
                name = "Hunting Sleeve",
                text = {
                    "Starting {C:attention,T:j_wafflemod_trophy_hunters_tricorn}Trophy Hunter's Tricorn",
                    "comes with {C:dark_edition,T:e_polychrome}Polychrome{} edition"
                }
            },
            sleeve_wafflemod_hunting_disabled = {
                name = "Hunting Sleeve",
                text = {
                    "{C:wafflemod_boss}Boss Jokers{} are currently {C:red}disabled{}",
                    "This sleeve will have {C:red}no effect{}",
                }
            },
        }

    },

    misc = {

        dictionary = {
            b_wafflemod_arcade_cards = "Arcade Cabinets",
            k_wafflemod_tarot_rx = "Tarot?",
            k_wafflemod_steel = "Steel",
            k_wafflemod_arcade = "Arcade Cabinet",
            k_wafflemod_copper_seal_eval = "Copper Seals",
            k_wafflemod_copper_seal_eval_singular = "Copper Seal",
            k_wafflemod_testing = "testing lalalala",
            k_wafflemod_deactived_ex = "Deactivated!",
            k_wafflemod_inactive = "inactive",
            ph_wafflemod_no_boss_joker = "no matching joker",
            wafflemod_dubious_legendary = "Legendary?",
            wafflemod_arcade_pack = "Arcade Pack"
        },

        labels = {
            wafflemod_copper_seal = "Copper Seal",
            wafflemod_ebony_seal = "Ebony Seal",
            wafflemod_ivory_seal = "Ivory Seal",
            wafflemod_viridian_seal = "Viridian Seal",
            wafflemod_ephemeral = "Ephemeral",
            wafflemod_arcade = "Arcade",
            wafflemod_cerulean = "Cerulean"
        },

        v_dictionary = {
            a_chips_scale = "+#1# Chips",
            a_chips_scale_minus = "-#1# Chips",
        }

    }

}
