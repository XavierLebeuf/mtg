""" Type abstrait dont d'autres types de mana dériveront. """
abstract type AbstractMana end

""" Type représentant une mana.
    Chaque liste de restriction est either une black list ou une white list. """
mutable struct Mana <: AbstractMana
    type::Symbol
    castTypeRestrictionWhite::Vector{Symbol}
    castTypeRestrictionBlack::Vector{Symbol}
    activateTypeRestrictionWhite::Vector{Symbol}
    activateTypeRestrictionBlack::Vector{Symbol}
end

""" Constructor for non restricted mana. """
NRMana(type::Symbol) =
       Mana(type,
            Symbol[],
            Symbol[],
            Symbol[],
            Symbol[])