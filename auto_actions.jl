""" 
    Contient les fonctions de second niveau.
    Fonctions pas prévues pour être appelées directement par l'utilisateur.
    Quelques-unes de ces fonctions sont dans les fichiers objets.
"""

""" Vérifie si une action est légale selon les phase steps.
    Par exemple, si "combat" est dans les white listed phases et la step courante est "combat/declare_attackers", l'action est légale.
    Les phases sont white listed ou black listed. """
function check_step(filter::Symbol, listed_phases::Vector{String}, step::String)
    legal = false
    if filter == :white
        for listed_phase in listed_phases
            if occursin(listed_phase, step)
                legal = true
            end
        end
        message = string("This command can only be called during the following phase(s): ", join(listed_phases, ", "), ".\n\tCurrent step: $step") 
    elseif filter == :black
        legal = true
        for listed_phase in listed_phases
            if occursin(listed_phase, step)
                legal = false
            end
        end
        message = string("This command cannot be called during the following phase(s): ", join(listed_phases, ", "), ".\n\tCurrent step: $step") 
    else
        message = "System error: Filter unknown."
    end
    
    !legal && throw(ErrorException(message))
end

""" Crée un deck à partir d'une deck list, où chaque carte est un objet différent. """
function create_deck!(g::Game, deck_list::DeckList, deck_size::Int, owner_name::String)
    deck = Vector{Card}(undef, deck_size)
    deck_index = 0
    for (qty, card) in deck_list.list
        (qty > 4 && "basic" ∉ card.supertype) && throw(DimensionMismatch("Deck list indicates too many $(card.name) cards"))
        for _ in 1:qty
            g.id += 1
            deck_index += 1
            (deck_index > deck_size) && throw(DimensionMismatch("Deck list has more than $deck_size cards"))

            unique_card = deepcopy(card)
            unique_card.id = g.id
            unique_card.owner = owner_name
            for ability in unique_card.ability
                ability.parentplayer = owner_name
                ability.parentcardid = g.id
            end
            deck[deck_index] = unique_card
        end
    end
    (deck_index != deck_size) && throw(DimensionMismatch("Deck list has $deck_index cards, but deck should contain $deck_size cards"))
    return deck
end

""" Renvoie l'object joueur à partir de son nom. Un object joueur donnée en argument est directement renvoyé. """
function str_to_p(name::Union{Player, String})
    (typeof(name) == Player) && (return name)
    for p in g.players
        (p.name == name) && (return p)
    end
    throw(ArgumentError("Aucun joueur ne se nomme « $name » dans la liste de joueurs."))
end

""" Renvoie l'index d'une carte dans un vecteur de cartes à partir de son id. """
id_to_index(card_id::Int, vector::Vector{Card}) = findfirst(x -> x.id == card_id, vector)


""" Brasse la library d'un joueur. """
shuffle_lib!(p::Player) = shuffle!(p.library)

""" Pige x cartes. """
function draw!(p::Player, x::Int=1)
    for _ in 1:x
        push!(p.hand, popfirst!(p.library))
    end
end

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

""" Reset les prioritypass de tous les joueurs à faux. """
function reset_priority!(g::Game)
    for p in g.players
        p.prioritypass = false
    end
end

""" Substitue un symbole pour l'objet approprié. """
function substitute_arg(ability::Ability, arg::Any, targets...)
    (typeof(arg) != Symbol) && (return arg)
    (arg == :pp) && (return str_to_p(ability.parentplayer))
    (arg == :pc) && (return ability.parentcardid)
    (arg == :t1) && (return targets[1])
    (arg == :t2) && (return targets[2])
    throw(ArgumentError("System errore: symbol argument unknown."))
end

""" Créée une copie de l'abilité et substitue les arguments symboles. """
function substitute_args(ability::Ability, targets...)
    ability = deepcopy(ability)
    for (i, (func, args)) in enumerate(ability.cost)
        ability.cost[i] = (func, [substitute_arg(ability, arg, targets) for arg in args])
    end
    for (i, (func, args)) in enumerate(ability.effect)
        ability.effect[i] = (func, [substitute_arg(ability, arg, targets) for arg in args])
    end
    return ability
end

""" Vérifie si un permanent est untapped avant de le tapper. """
tap_unt!(p::Player, card_id::Int) = (p.batt[id_to_index(card_id, p.batt)].tapped == true) ? throw(ErrorException("Can't tap $card_id, it's déjà tapped.")) : tap!(p, card_id)

""" Tap un permanent. """
tap!(p::Player, card_id::Int) = p.batt[id_to_index(card_id, p.batt)].tapped = true

""" Adds a set of unrestricted mana. """
add_mana!(p::Player, set::String) = p.manapool += ((set == "") ? (Mana[]) : ([Mana(string(mana)) for mana in split(set, "")]))

""" Vide la manapool. """
empty_manapool!(p::Player) = p.manapool = Mana[]

""" Vide toutes les manapools. """
function empty_manapools!(g::Game)
    for p in g.players
        empty_manapool!(p)
    end
end

""" Affiche le nom des x premières cartes de la librairy d'un joueur. """
function look_top_lib(p::Player, x::Int)
    for i in 1:x
        println(p.library[i].name)
    end
end

""" Ajoute une abilité sur le stack. """
function push_stack!(g::Game, ability::Ability)
end

""" Cast a spell. """
function resolve_stack!(g::Game)
end