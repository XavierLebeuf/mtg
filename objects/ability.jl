""" Type abstrait dont d'autres types d'abilities dériveront. """
abstract type AbstractAbility end

""" Type représentant une abilité.
    Si une abilité n'a pas de nom, indiquer la carte d'où elle vient.
    Les quatre types sont: activated, triggered, static et spell.
    Indiquer dans zone les zones à partir desquelles cette abilité peut entrer en effet.
    Pour chaque cost ou effect, indiquer dans un tuple la fonction to call, 
        ainsi qu'un vecteur des arguments de la fonction.
    Dans le vecteur des arguments, indiquer en symbol quelque chose qui est variable.
        :gm         = game
        :pp         = player parent
        :cp         = carte parent
        :va         = vector vide de any
        :ui         = user inputs
        :u1         = le premier user input.
        :u2         = le second user input.
        token codes = :tr,:dX,:d1,:d2,:d5.
    Constructeur par défaut: sans parentplayer ni parentcardid ni id. """
mutable struct Ability <: AbstractAbility
    name::String
    type::Symbol
    parentcardid::Int
    parentplayer::String
    manaability::Bool
    zone::Vector{Symbol}
    trigger::Vector{Symbol}
    costfunc::Vector{Function}
    costargs::Vector{Vector{Any}}
    effectfunc::Vector{Function}
    effectargs::Vector{Vector{Any}}
    id::Int

    function Ability(name::String,
                     type::Symbol,
                     manaability::Bool,
                     zone::Vector{Symbol},
                     trigger::Vector{Symbol},
                     costfunc::Vector{<:Function},
                     costargs::Union{Vector{Vector{Symbol}}, Vector{Vector{Any}}},
                     effectfunc::Vector{<:Function},
                     effectargs::Union{Vector{Vector{Symbol}}, Vector{Vector{Any}}},
                     parentplayer = "none",
                     parentcardid = 0,
                     id = 0)
        (length(costfunc) != length(costargs)) && throw(ErrorException("System error: Cost functions vector and arguments vector are not of the same length."))
        (length(effectfunc) != length(effectargs)) && throw(ErrorException("System error: Effect functions vector and arguments vector are not of the same length."))
        new(name,
            type,
            parentcardid,
            parentplayer,
            manaability,
            zone,
            trigger,
            costfunc,
            convert(Vector{Vector{Any}}, costargs),
            effectfunc,
            convert(Vector{Vector{Any}}, effectargs),
            id)
    end
end

""" Constructeur pour une activated ability. """
ActivatedAbility(name::String,
                 manaability::Bool,
                 zone::Vector{Symbol},
                 costfunc::Vector{<:Function},
                 costargs::Union{Vector{Vector{Symbol}}, Vector{Vector{Any}}},
                 effectfunc::Vector{<:Function},
                 effectargs::Union{Vector{Vector{Symbol}}, Vector{Vector{Any}}},
                 type = :activated,
                 trigger = Symbol[]) =
                 Ability(name,
                         type,
                         manaability,
                         zone,
                         trigger,
                         costfunc,
                         costargs,
                         effectfunc,
                         effectargs)

""" Constructeur pour une spell ability. """
SpellAbility(name::String,
             effectfunc::Vector{<:Function},
             effectargs::Union{Vector{Vector{Symbol}}, Vector{Vector{Any}}},
             type = :spell,
             manaability = false,
             zone = [:stack],
             trigger = Symbol[],
             costfunc = Function[],
             costargs = Vector{Vector{Symbol}}(undef, 0)) =
             Ability(name,
                     type,
                     manaability,
                     zone,
                     trigger,
                     costfunc,
                     costargs,
                     effectfunc,
                     effectargs)

""" Constructeur pour une triggered ability. """

""" Constructeur pour une static ability. """