steps= [("Initialisation/start", x -> nothing),
        ("Initialisation/choose_starter", x -> nothing),
        ("Initialisation/hand_decisions", x -> nothing),
        ("Begin/untap", go_to_untap),
        ("Begin/upkeep", go_to_upkeep),
        ("Begin/draw", go_to_draw),
        ("Precombat_main", go_to_precombat_main),
        ("Combat/begin", go_to_combat_beg),
        ("Combat/declare_attackers", go_to_combat_att),
        ("Combat/declare_blockers", go_to_combat_blo),
        ("Combat/demage", go_to_combat_dam),
        ("Combat/end", go_to_combat_end),
        ("Postcombat_main", go_to_postcombat_main),
        ("Ending/end", go_to_end),
        ("Ending/cleanup", go_to_cleanup)]

permanents = [:battle, :enchantment, :planeswalker, :creature, :land, :artifact]
zones = [:cache, :battlefield, :grave, :exile, :phasedout, :library, :sideboard, :hand]
colors = [:W, :U, :B, :R, :G, :CL]