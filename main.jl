using Random
import Base.+
import Base.show

include("objects/mana.jl")
include("objects/ability.jl")
include("objects/card.jl")
include("objects/player.jl")
include("objects/deck.jl")
include("objects/game.jl")

include("auto_actions.jl")
include("auto_step_actions.jl")
include("player_actions.jl")

include("data_base/ability_data.jl")
include("data_base/card_data.jl")
include("data_base/deck_data.jl")
include("data_base/steps_data.jl")

println("System message: game loaded")