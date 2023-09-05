# Ordre des steps, et la fonction pour passer à chaque step.

step_list = [("Initialisation/start", x -> x),
             ("Initialisation/choose_starter", x -> x),
             ("Initialisation/hand_decisions", x -> x),
             ("Begin/untap", go_to_untap),
             ("Begin/upkeep", go_to_upkeep),
             ("Begin/draw", go_to_draw),
             ("Precombat_main", go_to_precombat_main),
             ("Combat/begin", go_to_combat_beg),
             ("Combat/declare_attackers", go_to_combat_att),
             ("Combat/declare_blockers", go_to_combat_blo),
             ("Combat/demage", go_to_combat_dam),
             ("Combat/end", go_to_combat_end),
             ("Postcombat_main", go_to_postcombat_main)]