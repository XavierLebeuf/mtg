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

""" Renvoie le joueur actif. """
active_p(g::Game) = g.players[1]

""" Renvoie l'object joueur à partir de son nom. Un object joueur donnée en argument est directement renvoyé. """
function str_to_p(g::Game, name::Union{Player, String})
    (typeof(name) == Player) && (return name)
    for p in g.players
        (p.name == name) && (return p)
    end
    throw(ArgumentError("Aucun joueur ne se nomme « $name » dans la liste de joueurs."))
end

""" Montre les tours de jeu, avec le joueur actif en premier. """
function show_turn_order()
    global g
    println("Ordre des tours: ", [p.name for p in g.players])
end

""" Affiche le battlefield. """
function show_battlefield()
    global g
    for p in g.players
        println("$(p.name)'s controlled permanents:")
        print("\ttapped: ")
        show([card for card in g.battlefield if (card.controller == p.name && card.tapped)])
        print("\n\tuntapped: ")
        show([card for card in g.battlefield if (card.controller == p.name && !card.tapped)])
        println("\n")
    end
    return
end

