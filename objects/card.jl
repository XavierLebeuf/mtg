""" Type abstrait dont d'autres types de cartes dériveront. """
abstract type AbstractCard end

""" Type représentant une carte.
    Pour les power/toughness variables, mettre 0/0 et ajouter une abilité: ~ gets +1/+1 for each...
    Une carte unique a un id de 0, une carte en jeu est accordé un id différent de 0. """
mutable struct Card <: AbstractCard
    name::String
    owner::String
    cost::Vector{Mana}
    color::String
    supertype::Vector{String}
    type::Vector{String}
    subtype::Vector{String}
    ability::Vector{Ability}
    power::Union{Int,Nothing}
    toughness::Union{Int, Nothing}
    token::Bool
    tapped::Bool
    id::Int
end

""" Constructor for a card with no sub/super types and no power/thoughness with a mana cost shorcut. """
Card(name::String,
     cost::String,
     color::String,
     type::Vector{String},
     ability::Vector{Ability},
     owner = "",
     supertype = String[],
     subtype = String[],
     power = nothing,
     toughness = nothing,
     token = false,
     tapped = false,
     id = 0) =
     Card(name,
          owner,
          (cost == "") ? (Mana[]) : ([Mana(string(mana)) for mana in split(cost, "")]),
          color,
          supertype,
          type,
          subtype,
          ability,
          power,
          toughness,
          token,
          tapped,
          id)

""" Constructor for a card with some sub/super types and no power/thoughness with a mana cost shorcut. """
Card(name::String,
     cost::String,
     color::String,
     supertype::Vector{String},
     type::Vector{String},
     subtype::Vector{String},
     ability::Vector{Ability},
     owner = "",
     power = nothing,
     toughness = nothing,
     token = false,
     tapped = false,
     id = 0) =
     Card(name,
         owner,
         (cost == "") ? (Mana[]) : ([Mana(string(mana)) for mana in split(cost, "")]),
         color,
         supertype,
         type,
         subtype,
         ability,
         power,
         toughness,
         token,
         tapped,
         id)

""" Constructor with a mana cost shorcut. """
Card(name::String,
     cost::String,
     color::String,
     supertype::Vector{String},
     type::Vector{String},
     subtype::Vector{String},
     ability::Vector{Ability},
     power::Int,
     toughness::Int,
     owner = "",
     token = false,
     tapped = false,
     id = 0) =
     Card(name,
         owner,
         (cost == "") ? (Mana[]) : ([Mana(string(mana)) for mana in split(cost, "")]),
         color,
         supertype,
         type,
         subtype,
         ability,
         power,
         toughness,
         token,
         tapped,
         id)

""" Show une carte. """
function show(card::Card)
    print(card.color, "   ", card.name, "   ")
    show(card.cost)
    card.token && print("token - ")
    for t in card.supertype
        print(t, " ")
    end
    for t in card.type
        print(t, " ")
    end
    (length(card.subtype) != 0 ) && print("- ")
    for t in card.subtype
        print(t, " ")
    end
    print("\nid: ", card.id, "\t\t")
    (card.power !== nothing) && println(card.power, "/", card.toughness)
    return
end

""" Show un ensemble de cartes. """
function show(set::Vector{Card})
    for card in set
        print("($(card.id))", card.name)
        (card.id != set[end].id) && print(", ")
    end
end