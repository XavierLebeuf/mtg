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

### TURN 1 X ###

play!(X, 31)
activate!(X, 31)
cast!(X, 59)

auto_pass_priority!(X, 2)
auto_pass_priority!(T, 2)

### TURN 1 T ###

auto_pass_priority!(T, 1)
auto_pass_priority!(X, 2)

play!(T, 104)
activate!(T, 104)
cast!(T, 120)

auto_pass_priority!(T, 2)
auto_pass_priority!(X, 2)

### TURN 2 X ###

auto_pass_priority!(X, 1)
auto_pass_priority!(T, 2)

play!(X, 36)
activate!(X, 31)
activate!(X, 36)
activate!(X, 121, user_inputs = [:R])

### TURN 2 T ###