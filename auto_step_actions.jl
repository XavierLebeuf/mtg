""" Passe à la prochaine step. """
function next_step!(g::Game)
    empty_manapools!(g)
    current = g.step
    next = 0
    for (i,step) in enumerate(step_list)
        (step[1] == current) && (next = i+1)
    end
    (next > length(step_list)) && (next = 4)
    g.step = step_list[next][1]
    step_list[next][2](g)
end

""" Untap step. """
function go_to_untap(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Untap step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
    g.turn += 1
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
    println("\e[1m\e[38;2;102;102;255;249m", "Upkeep step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
end

""" Draw step. """
function go_to_draw(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Draw step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
    !(g.starter == active_p(g).name && g.turn == 1 && length(g.players) <= 2) && draw!(active_p(g))
end

""" Precombat main step. """
function go_to_precombat_main(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Precombat main step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
    show_hand(active_p(g))
end

""" Begining of combat step. """
function go_to_combat_beg(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Begining of combat step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
end

""" Declare attackers step. """
function go_to_combat_att(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Declare attackers step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
end

""" Declare blockers step. """
function go_to_combat_blo(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Declare bloackers step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
end

""" Combat damage step. """
function go_to_combat_dam(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Combat damage step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
end

""" End of combat step. """
function go_to_combat_end(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "End of combat step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
end

""" Postcombat main step. """
function go_to_postcombat_main(g::Game)
    println("\e[1m\e[38;2;102;102;255;249m", "Post combat main step ($(active_p(g).name))", "\e[1m\e[38;2;190;190;190;249m")
end