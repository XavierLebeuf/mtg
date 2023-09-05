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
    println("Untap step ($(active_p(g).name))")
    g.turn += 1
    for card in active_p(g).phasedout
        move_card!(card.id, active_p(g).phasedout, active_p(g).batt)
    end
    for card in active_p(g).batt
        card.tapped = false
    end
    next_step!(g)
end

""" Upkeep step. """
function go_to_upkeep(g::Game)
    g.step = "Begin/upkeep"
    println("Upkeep step ($(active_p(g).name))")
end

""" Draw step. """
function go_to_draw(g::Game)
    g.step = "Begin/draw"
    println("Draw step ($(active_p(g).name))")
    !(g.starter == active_p(g).name && g.turn == 1 && length(g.players) <= 2) && draw!(active_p(g))
end

""" Precombat main step. """
function go_to_precombat_main(g::Game)
    g.step = "Precombat_main"
    println("Precombat main step ($(active_p(g).name))")
end

""" Begining of combat step. """
function go_to_combat_beg(g::Game)
    g.step = "Combat/begin"
    println("Begining of combat step ($(active_p(g).name))")
end

""" Declare attackers step. """
function go_to_combat_att(g::Game)
    g.step = "Combat/declare_attackers"
    println("Declare attackers step ($(active_p(g).name))")
end

""" Declare blockers step. """
function go_to_combat_blo(g::Game)
    g.step = "Combat/declare_blockers"
    println("Declare blockers step ($(active_p(g).name))")
end

""" Combat damage step. """
function go_to_combat_dam(g::Game)
    g.step = "Combat/demage"
    println("Combat damage step ($(active_p(g).name))")
end

""" End of combat step. """
function go_to_combat_end(g::Game)
    g.step = "Combat/end"
    println("End of combat step ($(active_p(g).name))")
end

""" Postcombat main step. """
function go_to_postcombat_main(g::Game)
    g.step = "Postcombat_main"
    println("Postcombat main step ($(active_p(g).name))")
end