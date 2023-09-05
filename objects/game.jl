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
    passivetrigs::Vector{Ability}
    id::Int
end

""" Constructor de base. """
Game(players = Player[],
     starter = "",
     priority = "",
     step = "Initialisation/start",
     turn = 0,
     stack = Union{Card, Ability}[],
     passivetrigs = Ability[],
     id = 0) =
     Game(players,
          starter,
          priority,
          step,
          turn,
          stack,
          passivetrigs,
          id)

""" Montre les tours de jeu, avec le joueur actif en premier. """
function show_turn_order(g::Game)
    println("Ordre des tours: ", [p.name for p in g.players])
end

""" Renvoie le joueur actif. """
active_p(g::Game) = g.players[1]

""" Affiche le battlefield. """
function show_batt()
    global g
    for p in g.players
        println("$(p.name)'s battlefield side:")
        show(p.batt)
        println("\n")
    end
    return
end

