""" Type abstrait dont d'autres types de cartes dériveront. """
abstract type AbstractCard end

""" Type représentant une carte.
    Pour les power/toughness variables, mettre 0/0 et ajouter une abilité: ~ gets +1/+1 for each...
    Une carte unique a un id de 0, une carte dans un jeu est accordé un id différent de 0.
    Constructeur par défaut: sans id ni owner, untapped et avec un shortcut pour le cost. """
mutable struct Card <: AbstractCard
    name::String
    owner::String
    cost::Vector{Symbol}
    color::Vector{Symbol}
    supertype::Vector{Symbol}
    type::Vector{Symbol}
    subtype::Vector{Symbol}
    ability::Vector{Ability}
    power::Union{Int,Nothing}
    toughness::Union{Int, Nothing}
    loyalty::Union{Int,Nothing}
    token::Bool
    id::Int
    controller::String
    tapped::Bool

    Card(name::String,
         cost::Vector{Symbol},
         color::Vector{Symbol},
         supertype::Vector{Symbol},
         type::Vector{Symbol},
         subtype::Vector{Symbol},
         ability::Vector{Ability},
         power::Union{Int,Nothing},
         toughness::Union{Int,Nothing},
         loyalty::Union{Int,Nothing},
         token::Bool,
         owner = "none",
         id = 0,
         controller = "none",
         tapped = false) =
         new(name,
             owner,
             cost,
             color,
             supertype,
             type,
             subtype,
             ability,
             power,
             toughness,
             loyalty,
             token,
             id,
             controller,
             tapped)
end

""" Constructor for a non token card with no power/toughness, and no loyalty. """
GenCard(name::String,
        cost::Vector{Symbol},
        color::Vector{Symbol},
        supertype::Vector{Symbol},
        type::Vector{Symbol},
        subtype::Vector{Symbol},
        ability::Vector{Ability},
        power = nothing,
        toughness = nothing,
        loyalty = nothing,
        token = false) =
        Card(name,
             cost,
             color,
             supertype,
             type,
             subtype,
             ability,
             power,
             toughness,
             loyalty,
             token)

""" Constructor for a land. """
LandCard(name::String,
         supertype::Vector{Symbol},
         subtype::Vector{Symbol},
         ability::Vector{Ability},
         type = [:land],
         cost = Symbol[],
         color = [:colorless],
         power = nothing,
         toughness = nothing,
         loyalty = nothing,
         token = false) =
         Card(name,
              cost,
              color,
              supertype,
              type,
              subtype,
              ability,
              power,
              toughness,
              loyalty,
              token)

""" Constructor for creatures. """
CreatureCard(name::String,
             cost::Vector{Symbol},
             color::Vector{Symbol},
             supertype::Vector{Symbol},
             subtype::Vector{Symbol},
             ability::Vector{Ability},
             power::Int,
             toughness::Int,
             type = [:creature],
             loyalty = nothing,
             token = false) =
             Card(name,
                  cost,
                  color,
                  supertype,
                  type,
                  subtype,
                  ability,
                  power,
                  toughness,
                  loyalty,
                  token)
            
""" Constructor for planeswalkers. """
PlaneswalkerCard(name::String,
                 cost::Vector{Symbol},
                 color::Vector{Symbol},
                 supertype::Vector{Symbol},
                 subtype::Vector{Symbol},
                 ability::Vector{Ability},
                 loyalty::Int,
                 type = [:Planeswalker],
                 power = nothing,
                 toughness = nothing,
                 token = false) =
                 Card(name,
                      cost,
                      color,
                      supertype,
                      type,
                      subtype,
                      ability,
                      power,
                      toughness,
                      loyalty,
                      token)

""" Renvoie l'index d'une carte dans un vecteur de cartes à partir de son id. """
id_to_index(card_id::Int, vector::Vector{Card}) = findfirst(x -> x.id == card_id, vector)

""" Renvoie l'objet carte dans un vecteur de cartes à partir de son id. """
id_to_object(card_id::Int, vector::Vector{Card}) = vector[id_to_index(card_id, vector)]

""" Show une carte. """
function show(card::Card)
    for color in card.color
        print(color, " ")
    end
    print("  ", card.name, "   ")
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