""" Type abstrait dont d'autres types de mana dériveront. """
abstract type AbstractMana end

""" Type représentant une mana. """
mutable struct Mana <: AbstractMana
    type::String
    supertypeRestriction::Vector{String}
    typeRestriction::Vector{String}
    subtypeRestriction::Vector{String}
end

""" Constructor for non restricted mana. """
Mana(type::String) = Mana(type, String[], String[], String[])

""" Addition de vecteurs de mana, a+b=c. """
+(a::Vector{Mana}, b::Vector{Mana}) = vcat(a, b)

""" Checks if mana is restricted """
restricted(m::Mana) = (length(m.supertypeRestriction) == 0 && length(m.typeRestriction) == 0 && length(m.subtypeRestriction) == 0) ? false : true

""" Show un ensemble de mana. """
function show(set::Vector{Mana})
    for mana in set
        print(mana.type)
        restricted(mana) && print("*")
    end
    return println()
end