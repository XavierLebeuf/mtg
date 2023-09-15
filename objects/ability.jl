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
        :t1         = le premier target.
        :t2         = le second target.
        :tX         = plus de deux targets.
        token codes = :tr,:dX,:d1,:d2,:d5.
    Constructeur par défaut: sans parentplayer ni parentcardid. """
mutable struct Ability <: AbstractAbility
    type::Symbol
    parentcardid::Int
    parentplayer::String
    manaability::Bool
    zone::Vector{Symbol}
    trigger::Vector{Symbol}
    costfunc::Vector{Function}
    costargs::Matrix{Any}
    effectfunc::Vector{Function}
    effectargs::Matrix{Any}

    function Ability(type::Symbol,
                     manaability::Bool,
                     zone::Vector{Symbol},
                     trigger::Vector{Symbol},
                     costfunc::Vector{<:Function},
                     costargs::Matrix{Symbol},
                     effectfunc::Vector{<:Function},
                     effectargs::Matrix{Symbol},
                     parentplayer = "none",
                     parentcardid = 0)
        (length(costfunc) != size(costargs)[1]) && throw(ErrorException("System error: Cost functions vector and arguments vector are not of the same length."))
        (length(effectfunc) != size(effectargs)[1]) && throw(ErrorException("System error: Effect functions vector and arguments vector are not of the same length."))
        new(type,
            parentcardid,
            parentplayer,
            manaability,
            zone,
            trigger,
            costfunc,
            convert(Matrix{Any}, costargs),
            effectfunc,
            convert(Matrix{Any}, effectargs))
    end
end

""" Constructeur pour une activated ability. """
ActivatedAbility(manaability::Bool,
                 zone::Vector{Symbol},
                 costfunc::Vector{<:Function},
                 costargs::Matrix{Symbol},
                 effectfunc::Vector{<:Function},
                 effectargs::Matrix{Symbol},
                 type = :activated,
                 trigger = Symbol[]) =
                 Ability(type,
                         manaability,
                         zone,
                         trigger,
                         costfunc,
                         costargs,
                         effectfunc,
                         effectargs)

""" Constructeur pour une spell ability. """
SpellAbility(effectfunc::Vector{<:Function},
             effectargs::Matrix{Symbol},
             type = :spell,
             manaability = false,
             zone = [:stack],
             trigger = Symbol[],
             costfunc = Function[],
             costargs = Matrix{Symbol}(undef, 0, 0)) =
             Ability(type,
                     manaability,
                     zone,
                     trigger,
                     costfunc,
                     costargs,
                     effectfunc,
                     effectargs)

""" Constructeur pour une triggered ability. """

""" Constructeur pour une static ability. """