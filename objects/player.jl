""" Type abstrait dont d'autres types de joueurs dériveront. """
abstract type AbstractPlayer end

""" Type représentant un joueur.
    « abilities » est pour quand un jouer gagne hexproof par exemple. """
mutable struct Player <: AbstractPlayer
    name::String
    deckname::String
    mulligan::Int
    prioritypass::Bool
    playedland::Bool
    life::Int
    library::Vector{Card}
    hand::Vector{Card}
    exile::Vector{Card}
    batt::Vector{Card}
    grave::Vector{Card}
    phasedout::Vector{Card}
    sideboard::Vector{Card}
    abilities::Vector{Ability}
    manapool::Vector{Mana}
    poison::Int
end

""" Constructor de base. """
Player(name::String,
       deckname::String,
       life::Int,
       library::Vector{Card},
       mulligan = 0,
       prioritypass = false,
       playedland = false,
       hand = Card[],
       exile = Card[],
       batt = Card[],
       grave = Card[],
       phasedout = Card[],
       sideboard = Card[],
       abilities = Ability[],
       manapool = Mana[],
       poison = 0) =
       Player(name,
              deckname,
              mulligan,
              prioritypass,
              playedland,
              life,
              library,
              hand,
              exile,
              batt,
              grave,
              phasedout,
              sideboard,
              abilities,
              manapool,
              poison)

""" Affiche un joueur. """
function show(p::Player)
    println("$(p.name) joue $(p.deckname).")
    println("Life total = $(p.life), Poison counters = $(p.poison)")
    print("Mana pool = ")
    (length(p.manapool) > 0) ? show(p.manapool) : println("nothing")
    println("\n\tNumber of cards in")
    println("\tLibrary: $(length(p.library))")
    println("\tHand: $(length(p.hand))")
    println("\tGraveyard: $(length(p.grave))")
    println("\tPhased-out zone: $(length(p.phasedout))")
    println("\tBattlefield: $(length(p.batt))")
    println("\tExile: $(length(p.exile))")
    return
end

""" Affiche les cartes en main. """
function show_hand(p::Player)
    println("$(p.name)'s hand:")
    show(p.hand)
    println()
    return
end