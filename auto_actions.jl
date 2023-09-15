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
        (qty > 4 && :basic ∉ card.supertype) && throw(DimensionMismatch("Deck list indicates too many $(card.name) cards"))
        for _ in 1:qty
            g.id += 1
            deck_index += 1
            (deck_index > deck_size) && throw(DimensionMismatch("Deck list has more than $deck_size cards"))

            unique_card = deepcopy(card)
            unique_card.id = g.id
            unique_card.owner = owner_name
            unique_card.controller = owner_name
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

""" Brasse la library d'un joueur. """
shuffle_lib!(p::Player) = shuffle!(p.library)

""" Pige x cartes. """
function draw!(p::Player, x::Int=1)
    for _ in 1:x
        push!(p.hand, popfirst!(p.library))
    end
end

""" Affiche le nom des x premières cartes de la librairy d'un joueur. """
function look_top_lib(p::Player, x::Int)
    for i in 1:x
        println(p.library[i].name)
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

""" Vide la manapool. """
empty_manapool!(p::Player) = p.manapool = Mana[]

""" Vide toutes les manapools. """
function empty_manapools!(g::Game)
    for p in g.players
        empty_manapool!(p)
    end
end

""" Substitue un symbole pour l'objet approprié. """
function substitute_arg(g::Game, ability::Ability, arg::Any, targets...)
    (typeof(arg) != Symbol) && (return arg)
    (arg ∈ [:W, :U, :B, :R, :G, :CL]) && (return arg)
    (arg == :gm) && (return g)
    (arg == :pp) && (return str_to_p(g, ability.parentplayer))
    (arg == :pc) && (return ability.parentcardid)
    (arg == :t1) && (return targets[1])
    (arg == :t2) && (return targets[2])
    (arg == :tr) && (return Treasure)
    throw(ErrorException("System error: argument symbole $arg non reconnu."))
end

""" Créée une abilité unique en substituant les arguments symboles. """
function substitute_args(g::Game, ability::Ability, targets...)
    substituted_costargs = Matrix(undef, size(ability.costargs)...)
    substituted_effectargs = Matrix(undef, size(ability.effectargs)...)

    (nb_lines,nb_columns) = size(ability.costargs)
    for j = 1:nb_columns
        for i = 1:nb_lines
            substituted_costargs[i,j] = substitute_arg(g, ability, ability.costargs[i,j], targets)
        end
    end
    (nb_lines,nb_columns) = size(ability.effectargs)
    for j = 1:nb_columns
        for i = 1:nb_lines
            substituted_effectargs[i,j] = substitute_arg(g, ability, ability.effectargs[i,j], targets)
        end
    end

    unique_ability = deepcopy(ability)
    unique_ability.costargs = substituted_costargs
    unique_ability.effectargs = substituted_effectargs
    return unique_ability
end

""" Vérifie si un permanent est untapped avant de le tapper. """
tap_untapped!(g::Game, card_id::Int) = (id_to_object(card_id, g.battlefield).tapped == true) ? throw(ErrorException("Can't tap $card_id, it's déjà tapped.")) : id_to_object(card_id, g.battlefield).tapped = true

""" Adds a set of unrestricted mana. """
add_mana!(p::Player, set::Symbol ...) = p.manapool += [NRMana(mana_symbol) for mana_symbol in set]

""" Vérifie si le paiement est élligible, puis paye le mana cost d'une carte avec les manas d'indices mana_idx dans la mana pool. """
function pay_mana!(p::Player, card::Card, mana_idx::Vector{Int})
    pool = deepcopy(p.manapool[mana_idx])
    cost = deepcopy(card.cost)

    (length(cost) == 0) && throw(ErrorException("Cette carte n'a pas de mana cost, elle ne peut pas être castée."))
    (length(pool) != length(cost)) && throw(ErrorException("Il y a soit trop, ou pas asssez d'indices de mana."))
    for mana in pool
        if restricted(mana)
            for type in mana.typeRestrictionWhite
                (type ∉ vcat(card.supertype, card.type, card.subtype)) && throw(ErrorException("Une restriction de mana empêche de payer le coût d'une carte de type $type."))
            end
            for type in mana.typeRestrictionBlack
                (type ∈ vcat(card.supertype, card.type, card.subtype)) && throw(ErrorException("Une restriction de mana empêche de payer le coût d'une carte de type $type."))
            end
        end
    end

    for (i,cost_symbol) in enumerate(cost)
        if cost_symbol ∈ [:W, :U, :B, :R, :G, :CL]
            paid = false
            for pool_mana in pool
                if (pool_mana.type == cost_symbol) && !paid
                    cost[i] = :paid
                    pool_mana.type = :paid
                    paid = true
                end
            end
        end
    end

    for (i,cost_symbol) in enumerate(cost)
        if cost_symbol == :GE
            paid = false
            for pool_mana in pool
                if (pool_mana.type ∈ [:W, :U, :B, :R, :G, :CL]) && !paid
                    cost[i] = :paid
                    pool_mana.type = :paid
                    paid = true
                end
            end
        end
    end

    !all(cost .== :paid) && throw(ErrorException("L'ensemble de manas sélectionné ne permet pas de payer le cout."))
    deleteat!(p.manapool, sort(mana_idx))
end

""" Cast a spell. """
function resolve_stack_top!(g::Game)
    object = pop!(g.stack)
    if typeof(object) == Ability
        for (i, func) in enumerate(object.effectfunc)
            func(object.effectargs[i,:]...)
        end
    elseif typeof(object) == Card
        for ability in object.ability
            if ability.type == :spell
                for (i, func) in enumerate(ability.effectfunc)
                    func(ability.effectargs[i,:]...)
                end
            end
        end
        cache_to_grave(g, object.id)
    end
end

""" Ajoute une abilité sur le stack. """
function push_stack!(g::Game, ability::Ability)
end

""" Crée un token. """
function create_token!(g::Game, p::Player, card::Card)
    unique_token = deepcopy(card)
    unique_token.token = true
    g.id += 1
    unique_token.id = g.id
    unique_token.owner = p.name
    unique_token.controller = p.name
    for ability in unique_token.ability
        ability.parentplayer = p.name
        ability.parentcardid = g.id
    end
    push!(g.battlefield, unique_token)
end

""" Place une carte de la cache dans le graveyard de son owner. """
function cache_to_grave(g::Game, card_id::Int)
    for (i,cached_card) in enumerate(g.cache)
        if cached_card.id == card_id
            g.id += 1
            cached_card.id = g.id
            push!(str_to_p(g, cached_card.owner).grave, popat!(g.cache, i))
        end
    end
end

""" Place une carte de la cache au battlefield sous le controle de son owner. """
function cache_to_batt(g::Game, card_id::Int)
    for (i,cached_card) in enumerate(g.cache)
        if cached_card.id == card_id
            g.id += 1
            cached_card.id = g.id
            cached_card.controller = cached_card.owner
            push!(g.battlefield, popat!(g.cache, i))
        end
    end
end