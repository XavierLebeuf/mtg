""" Type abstrait dont d'autres types de deck dériveront. """
abstract type AbstractDeckList end

""" Type représentant une mana. """
mutable struct DeckList <: AbstractDeckList
    name::String
    formats::Vector{String}
    list::Vector{Tuple{Int,Card}}
end