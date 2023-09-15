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
    grave::Vector{Card}
    phasedout::Vector{Card}
    sideboard::Vector{Card}
    abilities::Vector{Ability}
    manapool::Vector{Mana}
    poison::Int

    Player(name::String,
           deckname::String,
           life::Int,
           library::Vector{Card},
           mulligan = 0,
           prioritypass = false,
           playedland = false,
           hand = Card[],
           exile = Card[],
           grave = Card[],
           phasedout = Card[],
           sideboard = Card[],
           abilities = Ability[],
           manapool = Mana[],
           poison = 0) =
           new(name,
               deckname,
               mulligan,
               prioritypass,
               playedland,
               life,
               library,
               hand,
               exile,
               grave,
               phasedout,
               sideboard,
               abilities,
               manapool,
               poison)
end

""" Affiche des statistiques in game d'un joueur. """
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
    println("\tExile: $(length(p.exile))")
    return
end

""" Affiche les cartes en main d'un joueur. """
function show_hand(p::Player)
    println("$(p.name)'s hand:")
    show(p.hand)
    println()
    return
end

""" Affiche la mana pool d'un joueur. """
function show_pool(p::Player)
    (length(p.manapool) > 0) ? show(p.manapool) : println("nothing")
    return
end