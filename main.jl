using Random
import Base.+
import Base.show
import Base.isless

include("objects/mana.jl")
include("objects/ability.jl")
include("objects/card.jl")
include("objects/player.jl")
include("objects/deck.jl")
include("objects/game.jl")

include("source/short_auto_actions.jl")
include("source/long_auto_actions.jl")
include("source/step_auto_actions.jl")
include("source/player_actions.jl")
include("source/show.jl")

include("data_base/ability_data.jl")
include("data_base/card_data.jl")
include("data_base/deck_data.jl")
include("data_base/lists.jl")

println("System message: game loaded")