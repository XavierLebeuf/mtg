# RACCOURCIS

""" Renvoie l'index d'une carte dans un vecteur de cartes à partir de son id. """
id_to_index(card_id::Int, vector::Vector{Card}) = findfirst(x -> x.id == card_id, vector)

""" Renvoie l'objet carte dans un vecteur de cartes à partir de son id. """
id_to_object(card_id::Int, vector::Vector{Card}) = vector[id_to_index(card_id, vector)]

""" Renvoie le joueur actif. """
active_p(g::Game) = g.players[1]

""" Renvoie l'object joueur à partir de son nom. Un object joueur donnée en argument est directement renvoyé. """
function str_to_p(g::Game, name::Union{Player, String})
    (typeof(name) == Player) && (return name)
    for p in g.players
        (p.name == name) && (return p)
    end
    throw(ArgumentError("Aucun joueur ne se nomme « $name » dans la liste de joueurs."))
end

""" Addition de vecteurs de mana, a+b=c. """
+(a::Vector{Mana}, b::Vector{Mana}) = vcat(a, b)

""" Checks if mana is restricted """
restricted(mana::Mana) = !(length(mana.castTypeRestrictionWhite) == 0 &&
                           length(mana.castTypeRestrictionBlack) == 0 &&
                           length(mana.activateTypeRestrictionWhite) == 0 &&
                           length(mana.activateTypeRestrictionBlack) == 0)

""" Returns the vector corresponding to the zone. """
find_zone(g::Game, p::Player, zone::Symbol) = (zone == :battlefield) ? g.battlefield : getfield(p, zone)

# AUTO ACTION FUNCTIONS COURTES

""" Brasse la library d'un joueur. """
shuffle_lib!(p::Player) = shuffle!(p.library)

""" Place une carte de la main en dessous de la librairie. """
hand_to_libbot!(p::Player, card_id::Int) = push!(p.library, popat!(p.hand, id_to_index(card_id, p.hand)))

""" Place une carte de la main sur le dessus de la librairie. """
hand_to_libtop!(p::Player, card_id::Int) = pushfirst!(p.library, popat!(p.hand, id_to_index(card_id, p.hand)))

""" Place une carte de la zone A à la zone B. """
move_card!(card_id::Int, zoneA::Vector{Card}, zoneB::Vector{Card}) = push!(zoneB, popat!(zoneA, id_to_index(card_id, zoneA)))

""" Place le joueur actif à la fin de la liste de joueurs. """
next_active_p!(g::Game) = push!(g.players, popfirst!(g.players))

""" Renvoie vrai si tous les joueurs ont passé la priorité. """
all_passed_priority(g::Game) = all([p.prioritypass for p in g.players])

""" Vide la manapool d'un joueur. """
empty_manapool!(p::Player) = p.manapool = Mana[]

""" Vérifie si un permanent est untapped avant de le tapper. """
tap_untapped!(g::Game, card_id::Int) = (id_to_object(card_id, g.battlefield).tapped == true) ? throw(ErrorException("Can't tap $card_id, it's déjà tapped.")) : id_to_object(card_id, g.battlefield).tapped = true

""" Adds a set of unrestricted mana. """
add_mana!(p::Player, set::Symbol ...) = p.manapool += [NRMana(mana_symbol) for mana_symbol in set]

""" Sacrifice d'un permanent. """
sacrifice!(g::Game, p::Player, card_id::Int) = move_card!(card_id, g.battlefield, p.grave)

""" Exile une carte. """
exile!(g::Game, p::Player, zone::Symbol, card_id::Int) = move_card!(card_id, find_zone(g, p, zone), p.exile)

""" Modifie le loyalty d'un planeswalker. """
modify_loyalty!(g::Game, card_id::Int, modifier::Int) = id_to_object(card_id, g.battlefield).loyalty += modifier

""" Pige x cartes. """
function draw!(p::Player, x::Int=1)
    try
        push!(p.hand, splice!(p.library, 1:x)...)
    catch error
        isa(error, BoundsError) ? (p.drawfail = true) : throw(error)
    end
end

""" Affiche le nom des x premières cartes de la librairy d'un joueur. """
function look_top_lib(p::Player, x::Int)
    for i in 1:x
        println(p.library[i].name)
    end
end

""" Reset les prioritypass de tous les joueurs à faux. """
function reset_priority!(g::Game)
    for p in g.players
        p.prioritypass = false
    end
end

""" Vide toutes les manapools. """
function empty_manapools!(g::Game)
    for p in g.players
        empty_manapool!(p)
    end
end

""" Vérifie si le paiement est élligible, puis paye le mana cost d'une carte ou d'une abilité avec les manas d'indices mana_idx dans la mana pool. """
function pay_mana!(p::Player, object::Union{Card, Ability}, mana_idx::Vector{Int})
    check_pay_mana(p.manapool[mana_idx], object)
    deleteat!(p.manapool, sort(mana_idx))
end