Random.seed!(0)

### INITIALIZE PLAYERS ###

X = initialize_player("Xavier", Mono_red_dragons_list, "modern");
T = initialize_player("Thomas", Mono_red_dragons_list, "modern");

### GAME START ###

get_turn_order!()
choose_starting_player!(X)
keep_hand!(X)
mulligan!(T)
mulligan!(T)
keep_hand!(T, 110, 119)

### TURN ONE ###

pass_priority!(X)
pass_priority!(T)
pass_priority!(X)
pass_priority!(T)

play!(X, 31)
activate!(X, 31)
cast!(X, 59)
pass_priority!(X)
pass_priority!(T)