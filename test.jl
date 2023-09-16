""" Cast a spell avec tous les champs sans keyword arguments. """
cast!(p::Player,
      card_id::Int,
      zone_arg::Symbol,
      mana_ids_arg::Vector{Int},
      user_inputs_arg::Vector{T},
      alt_cost_arg::Vector{Symbol}) where T =
      cast!(p,
            card_id,
            zone = zone_arg,
            mana_ids = mana_ids_arg,
            user_inputs = user_inputs_arg,
            alt_cost = alt_cost_arg)

""" Cast a spell. """
function cast!(p::Player,
               card_id::Int;
               zone::Symbol = :hand,
               mana_ids::Vector{Int} = collect(1:length(p.manapool)),
               user_inputs::Vector{T} = Any[],
               alt_cost::Vector{Symbol} = Symbol[]) where T

               println("ok")
end