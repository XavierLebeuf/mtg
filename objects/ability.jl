""" Type abstrait dont d'autres types d'abilities dériveront. """
abstract type AbstractAbility end

""" Type représentant une abilité.
    Si une abilité n'a pas de nom, indiquer la carte d'où elle vient.
    Les quatre types sont: activated, triggered, static et spell.
    Indiquer dans zone les zones à partir desquelles cette abilité peut entrer en effet.
    Pour chaque cost ou effect, indiquer dans un tuple la fonction to call, 
        ainsi qu'un vecteur des arguments de la fonction.
    Dans le vecteur des arguments, indiquer en symbol quelque chose qui est variable.
        :pp         = player parent
        :cp         = carte parent
        :t1         = le premier target.
        :t2         = le second target.
        :tX         = plus de deux targets. """
mutable struct Ability <: AbstractAbility
    type::Symbol
    parentcardid::Int
    parentplayer::String
    manaability::Bool
    zone::Vector{Symbol}
    trigger::Vector{Symbol}
    cost::Vector{Tuple{Function, Vector{Any}}}
    effect::Vector{Tuple{Function, Vector{Any}}}

    #Ability(type::Symbol,
    #    manaability::Bool,
    #    zone::Vector{Symbol},
    #    trigger::Vector{Symbol},
    #    cost::Vector{Tuple{Function, Vector{Any}}},
    #    effect::Vector{Tuple{Function, Vector{Any}}},
    #    parentplayer = "",
    #    parentcardid = 0) =
    #    new(type,
    #        parentcardid,
    #        parentplayer,
    #        manaability,
    #        zone,
    #        trigger,
    #        cost,
    #        effect)
end

""" Constructeur pour une activated ability sans parents. """
ActivatedAbility(manaability::Bool,
                 zone::Vector{Symbol},
                 cost::Vector{Tuple{Function, Vector{Any}}},
                 effect::Vector{Tuple{Function, Vector{Any}}},
                 type = :activated,
                 parentplayer = "",
                 parentcardid = 0,
                 trigger = Symbol[]) =
                 Ability(type,
                         parentcardid,
                         "parentplayer",
                         manaability,
                         zone,
                         trigger,
                         cost,
                         effect)

""" Constructeur pour une spell ability sans parents. """
SpellAbility(cost::Vector{Tuple{Function, Vector{Any}}},
             effect::Vector{Tuple{Function, Vector{Any}}},
             type = :spell,
             parentplayer = "",
             parentcardid = 0,
             manaability = false,
             zone = [:stack],
             trigger = Symbol[]) =
             Ability(type,
                     parentcardid,
                     parentplayer,
                     manaability,
                     zone,
                     trigger,
                     cost,
                     effect)

""" Constructeur pour une triggered ability sans parents. """

""" Constructeur pour une static ability sans parents. """