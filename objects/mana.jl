""" Type abstrait dont d'autres types de mana dériveront. """
abstract type AbstractMana end

""" Type représentant une mana.
    Chaque liste de restriction est either une black list ou une white list. """
mutable struct Mana <: AbstractMana
    type::Symbol
    typeRestrictionWhite::Vector{Symbol}
    typeRestrictionBlack::Vector{Symbol}
end

""" Constructor for non restricted mana. """
NRMana(type::Symbol) =
       Mana(type,
            Symbol[],
            Symbol[])

""" Addition de vecteurs de mana, a+b=c. """
+(a::Vector{Mana}, b::Vector{Mana}) = vcat(a, b)

""" Checks if mana is restricted """
restricted(mana::Mana) = !(length(mana.typeRestrictionWhite) == 0 && length(mana.typeRestrictionBlack) == 0)

""" Show un ensemble de mana. """
function show(set::Vector{Mana})
    for (i,mana) in enumerate(set)
        print("($i)$(mana.type)")
        restricted(mana) && print("*")
        print(" ")
    end
    return println()
end