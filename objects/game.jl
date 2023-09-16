""" Type abstrait dont d'autres types de game dériveront. """
abstract type AbstractGame end

""" Type représentant une partie.
    L'ordre du vrecteur de joueurs représente l'ordre des touts de jeux.
    Cet ordre est changé à chaque tour pour que le premier joueur du vecteur soit le joueur actif. """
mutable struct Game <: AbstractGame
    players::Vector{Player}
    starter::String
    priority::String
    step::String
    turn::Int
    stack::Vector{Union{Card, Ability}}
    battlefield::Vector{Card}
    passivetrigs::Vector{Ability}
    id::Int
    cache::Vector{Card}

    Game(players = Player[],
         starter = "",
         priority = "",
         step = "Initialisation/start",
         turn = 0,
         stack = Union{Card, Ability}[],
         battlefield = Card[],
         passivetrigs = Ability[],
         id = 0,
         cache = Card[]) =
         new(players,
             starter,
             priority,
             step,
             turn,
             stack,
             battlefield,
             passivetrigs,
             id,
             cache)
end