""" 
    Contient des exemples de function calls.
    Exemples cohérents à l'intérieur d'une section seulement.
"""

### INITIALIZE PLAYERS ###

X = initialize_player("Xavier", Mono_red_dragons_list, "modern");
T = initialize_player("Thomas", Mono_red_dragons_list, "modern");
#W = initialize_player("William", Mono_red_dragons_list, "modern");
#E = initialize_player("Eduardo", Mono_red_dragons_list, "modern");

### GAME START ###

get_turn_order!()
choose_starting_player!(X)
keep_hand!(X)
keep_hand!(T)
#mulligan!(T)
#mulligan!(T)
#keep_hand!(T, 89, 62)

### TURN ONE ###

pass_priority!(X)
pass_priority!(T)
#pass_priority!(E)
#pass_priority!(W)

pass_priority!(X)
pass_priority!(T)

#play!(X, 32)
#activate!(X, 32, 1)