""" Show une carte. """
function show(card::Card)
    for color in card.color
        print(color, " ")
    end
    print("  ", card.name, "   ")
    show(card.cost)
    card.token && print("token - ")
    for t in card.supertype
        print(t, " ")
    end
    for t in card.type
        print(t, " ")
    end
    (length(card.subtype) != 0 ) && print("- ")
    for t in card.subtype
        print(t, " ")
    end
    print("\nid: ", card.id, "\t\t")
    (card.power !== nothing) && println(card.power, "/", card.toughness)
    return
end

""" Show un ensemble de cartes. """
function show(set::Vector{Card})
    for card in set
        print("($(card.id))", card.name)
        (card.id != set[end].id) && print(", ")
    end
end

""" Affiche les tours de jeu, avec le joueur actif en premier. """
function show_turn_order()
    global g
    println("Ordre des tours: ", [p.name for p in g.players])
    return
end

""" Affiche le stack, avec le dernier élément le prochain à resolve. """
function show_stack()
    global g
    stack = g.stack
    (length(stack) == 0) && (println("nothing"))
    for object in stack
        print("($(object.id))", object.name)
        (object.id != stack[end].id) && print(", ")
    end
    return
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
        println()
    end
    return
end

""" Show un ensemble de mana. """
function show(set::Vector{Mana})
    for (i,mana) in enumerate(set)
        print("($i)$(mana.type)")
        restricted(mana) && print("*")
        print(" ")
    end
    return println()
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
    (length(p.hand) == 0) && (print("nothing"))
    show(p.hand)
    println()
    return
end

""" Affiche la mana pool d'un joueur. """
function show_pool(p::Player)
    (length(p.manapool) > 0) ? show(p.manapool) : println("nothing")
    return
end

""" Affiche le grave d'un joueur. """
function show_grave(p::Player)
    println("$(p.name)'s graveyard:")
    (length(p.grave) == 0) && (print("nothing"))
    show(p.grave)
    println()
    return
end