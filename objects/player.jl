""" Type abstrait dont d'autres types de joueurs dériveront. """
abstract type AbstractPlayer end

""" Type représentant un joueur.
    « abilities » est pour quand un jouer gagne hexproof par exemple. """
mutable struct Player <: AbstractPlayer
    name::String
    deckname::String
    mulligan::Int
    prioritypass::Bool
    autopasslevel::Int
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
    drawfail::Bool

    Player(name::String,
           deckname::String,
           life::Int,
           library::Vector{Card},
           mulligan = 0,
           prioritypass = false,
           autopasslevel = 1,
           playedland = false,
           hand = Card[],
           exile = Card[],
           grave = Card[],
           phasedout = Card[],
           sideboard = Card[],
           abilities = Ability[],
           manapool = Mana[],
           poison = 0,
           drawfail = false) =
           new(name,
               deckname,
               mulligan,
               prioritypass,
               autopasslevel,
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
               poison,
               drawfail)
end