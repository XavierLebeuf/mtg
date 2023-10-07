############################## In another file ##############################
""" Type abstrait dont d'autres types d'abilities dériveront. """
abstract type AbstractAbility end

""" Sous-type d'abilité: spell ability. """
mutable struct SpellAbility <: AbstractAbility
      name::String
      content::Vector{Symbol}
end

flashback = SpellAbility("Flashback", [:GE, :GE, :R])
#############################################################################

using Observables
# NOTE: LA DOC DE CE PACKAGE EST VRAIMENT CLAIRE ET CONCISE

""" Type abstrait dont d'autres types de cartes dériveront. """
abstract type AbstractCard end

""" Sous-type de card: sorcery card."""
mutable struct Sorcery <: AbstractCard
    printed_name::String
    printed_cost::Vector{Symbol}
    printed_colors::Vector{Symbol}
    printed_supertypes::Vector{Symbol}
    printed_types::Vector{Symbol}
    printed_subtypes::Vector{Symbol}
    abilities::Vector{<:AbstractAbility}
    zone::Observable{Symbol}
    cost::Vector{Symbol}

    Sorcery(name::String,
            cost::Vector{Symbol},
            colors::Vector{Symbol},
            abilities::Vector{<:AbstractAbility}) =
            new(name, cost, colors, Symbol[], [:sorcery], Symbol[], abilities, Observable{Symbol}(:library), cost)
end

strike_it_rich = Sorcery("Strike it Rich", [:R], [:R], [flashback])

function event_listener(new_zone::Symbol)
      if new_zone == :hand
            strike_it_rich.cost = strike_it_rich.printed_cost
      elseif new_zone == :graveyard
            for ability in strike_it_rich.abilities
                  if ability.name == "Flashback"
                        strike_it_rich.cost = ability.content
                  end
            end
      else
            strike_it_rich.cost = Symbol[]
      end
      println("Cost actuel: $(strike_it_rich.cost)")
end

obs_func = on(strike_it_rich.zone) do val
      event_listener(val)
end






