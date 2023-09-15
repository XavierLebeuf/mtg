Random.seed!(0)

### INITIALIZE PLAYERS ###

X = initialize_player("Xavier", Mono_red_dragons_list, "modern");
T = initialize_player("Thomas", Mono_red_dragons_list, "modern");
W = initialize_player("William", Mono_red_dragons_list, "modern");
E = initialize_player("Eduardo", Mono_red_dragons_list, "modern");

### GAME START ###

get_turn_order!()
choose_starting_player!(X)
keep_hand!(X)
keep_hand!(W)
keep_hand!(T)
keep_hand!(E)

### TURN ONE ###

pass_priority!(X)
pass_priority!(W)
pass_priority!(T)
pass_priority!(E)

pass_priority!(X)
pass_priority!(W)
pass_priority!(T)
pass_priority!(E)