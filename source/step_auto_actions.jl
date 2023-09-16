""" Passe à la prochaine step. """
function next_step!(g::Game)
    empty_manapools!(g)
    current = g.step
    next = 0
    for (i,step) in enumerate(steps)
        (step[1] == current) && (next = i+1)
    end
    (next > length(steps)) && (next = 4)
    g.step = steps[next][1]
    steps[next][2](g)
end

""" Untap step. """
function go_to_untap(g::Game)
    (active_p(g).name == g.starter) && (g.turn += 1)
    println("\e[1m\e[38;2;102;102;255;249m", "\nTURN $(g.turn) - $(active_p(g).name)\nUntap step", "\e[1m\e[38;2;190;190;190;249m")
    for card in active_p(g).phasedout
        move_card!(card.id, active_p(g).phasedout, g.battlefield)
    end
    for card in g.battlefield
        (card.controller == active_p(g).name) && (card.tapped = false)
    end
    next_step!(g)
end

""" Upkeep step. """
function go_to_upkeep(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Upkeep step", "\e[1m\e[38;2;190;190;190;249m")
end

""" Draw step. """
function go_to_draw(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Draw step", "\e[1m\e[38;2;190;190;190;249m")
    !(g.starter == active_p(g).name && g.turn == 1 && length(g.players) <= 2) && draw!(active_p(g))
end

""" Precombat main step. """
function go_to_precombat_main(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Precombat mainphase", "\e[1m\e[38;2;190;190;190;249m")
    show_hand(active_p(g))
end

""" Begining of combat step. """
function go_to_combat_beg(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Begining of combat step", "\e[1m\e[38;2;190;190;190;249m")
    show_battlefield()
end

""" Declare attackers step. """
function go_to_combat_att(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Declare attackers step", "\e[1m\e[38;2;190;190;190;249m")
end

""" Declare blockers step. """
function go_to_combat_blo(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Declare blockers step", "\e[1m\e[38;2;190;190;190;249m")
end

""" Combat damage step. """
function go_to_combat_dam(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Combat damage step", "\e[1m\e[38;2;190;190;190;249m")
end

""" End of combat step. """
function go_to_combat_end(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "End of combat step", "\e[1m\e[38;2;190;190;190;249m")
end

""" Postcombat main step. """
function go_to_postcombat_main(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Post combat mainphase", "\e[1m\e[38;2;190;190;190;249m")
    show_hand(active_p(g))
end

""" End step. """
function go_to_end(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "End step", "\e[1m\e[38;2;190;190;190;249m")
end

""" Cleanup step. """
function go_to_cleanup(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Cleanup step", "\e[1m\e[38;2;190;190;190;249m")
    reset_priority!(g)
    for p in g.players
        p.autopasslevel = 0
    end
    active_p(g).playedland = false
    next_active_p!(g)
    g.priority = active_p(g).name
    next_step!(g)
end