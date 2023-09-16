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

""" Checks state-based actions. """
function check_state_based_actions(g::Game)
    for p in g.players
        (p.life <= 0 || p.poison >= 10 || p.drawfail) && popat!(g.players, findfirst(x -> x == p))
        for (i,card) in enumerate(p.grave)
            card.token && popat!(p.grave, i)
        end
    end
    #check if a copy of a spell is in a zone other than the stack, it ceases to exist.
    for (i,card) in enumerate(deepcopy(g.battlefield))
        if :creature ∈ card.type
            if card.toughness <= 0 || card.toughness - card.damage <= 0
                popat!(g.battlefield, i)
                cache_to_zone(g, :grave, card.id)
            end
        elseif :planeswalker ∈ card.type && card.loyalty <= 0
            popat!(g.battlefield, i)
            cache_to_zone(g, :grave, card.id)
        end
        #check deathtouch damage
        #check legendairies
        #check for illegal auras
        #check for illegal equipments
        #check for attached things that cant attached
        #cancel +1/+1 and -1/-1 counters
        #check if a permanent with an ability that says it can’t have more than N counters of a certain kind on it
        #check for lore in sagas
        #check venture marker on dongeons
        #check battles
        #check roles
    end
    (length(g.players) == 1) && println("$(active_p(g).name) has won.")
end

""" Substitue un symbole pour l'objet approprié. """
function substitute_arg(g::Game, ability::Ability, arg::Any, user_inputs::Vector{T}) where T
    (typeof(arg) != Symbol) && (return arg)
    (arg ∈ colors || arg ∈ zones) && (return arg)
    (arg == :gm) && (return g)
    (arg == :pp) && (return str_to_p(g, ability.parentplayer))
    (arg == :pc) && (return ability.parentcardid)
    (arg == :va) && (return Any[])
    (arg == :ui) && (return user_inputs)
    (arg == :u1) && (return user_inputs[1])
    (arg == :u2) && (return user_inputs[2])
    (arg == :tr) && (return Treasure)
    throw(ErrorException("System error: argument symbole $arg non reconnu."))
end

""" Créée une abilité unique en substituant les arguments symboles. """
function substitute_args(g::Game, ability::Ability, user_inputs::Vector{T}) where T
    substituted_costargs = Vector(undef, length(ability.costargs))
    substituted_effectargs = Vector(undef, length(ability.effectargs))

    for (i,args) in enumerate(ability.costargs)
        substituted_costargs[i] = [substitute_arg(g, ability, arg, user_inputs) for arg in args]
    end
    for (i,args) in enumerate(ability.effectargs)
        substituted_effectargs[i] = [substitute_arg(g, ability, arg, user_inputs) for arg in args]
    end

    unique_ability = deepcopy(ability)
    unique_ability.costargs = substituted_costargs
    unique_ability.effectargs = substituted_effectargs
    return unique_ability
end

""" Vérifie si le paiement du cost d'une carte ou d'une abilité est élligible si l'on veut payer avec pool. """
function check_pay_mana(pool::Vector{Mana}, object::Union{Card, Ability})
    local cost, card
    pool = deepcopy(pool)
    if typeof(object) == Card
        cost = deepcopy(object.cost)
        card = object
        (length(cost) == 0) && throw(ErrorException("Cette carte n'a pas de mana cost, elle ne peut pas être castée."))
        (length(pool) != length(cost)) && throw(ErrorException("Il y a soit trop, ou pas asssez d'indices de mana."))
        for mana in pool

            if restricted(mana)
                (length(mana.activateTypeRestrictionWhite) > 0) && throw(ErrorException("Une restriction de mana empêche de payer pour autre chose qu'une activated ability."))
                for type in mana.castTypeRestrictionWhite
                    (type ∉ vcat(card.supertype, card.type, card.subtype)) && throw(ErrorException("Une restriction de mana empêche de payer le coût d'une carte de type $type."))
                end
                for type in mana.castTypeRestrictionBlack
                    (type ∈ vcat(card.supertype, card.type, card.subtype)) && throw(ErrorException("Une restriction de mana empêche de payer le coût d'une carte de type $type."))
                end
            end
        end
    elseif typeof(object) == Ability
        for (i,cost_func) in enumerate(object.costfunc)
            if cost_func == pay_mana!
                cost = deepcopy(object.costargs[i])
                (length(cost) == 0) && throw(ErrorException("Cette abilité n'a pas de mana cost."))
                (length(pool) != length(cost)) && throw(ErrorException("Il y a soit trop, ou pas asssez d'indices de mana."))
                for mana in pool

                    if restricted(mana)
                        (length(mana.castTypeRestrictionWhite) > 0) && throw(ErrorException("Une restriction de mana empêche de payer pour autre chose que caster un spell."))
                        if object.zone == :battlefield
                            card = id_to_object(object.parentcardid, g.battlefield)
                        else
                            card = id_to_object(object.parentcardid, getfield(str_to_p(g, object.parentplayer), zone))
                        end
                        for type in mana.activateTypeRestrictionWhite
                            (type ∉ vcat(card.supertype, card.type, card.subtype)) && throw(ErrorException("Une restriction de mana empêche de payer le coût d'une une activated ability d'une carte de type $type."))
                        end
                        for type in mana.activateTypeRestrictionBlack
                            (type ∈ vcat(card.supertype, card.type, card.subtype)) && throw(ErrorException("Une restriction de mana empêche de payer le coût d'une une activated ability d'une carte de type $type."))
                        end
                    end
                end
            end
        end
    end
    for (i,cost_symbol) in enumerate(cost)
        if cost_symbol ∈ colors
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
                if (pool_mana.type ∈ colors) && !paid
                    cost[i] = :paid
                    pool_mana.type = :paid
                    paid = true
                end
            end
        end
    end
    !all(cost .== :paid) && throw(ErrorException("L'ensemble de manas sélectionné ne permet pas de payer le cout."))
end

""" Resolve l'objet qui est sur le dessus du stack. """
function resolve_stack_top!(g::Game)
    object = pop!(g.stack)
    if typeof(object) == Ability
        for (i, func) in enumerate(object.effectfunc)
            func(object.effectargs[i]...)
        end
    elseif typeof(object) == Card
        for ability in object.ability
            if ability.type == :spell
                for (i, func) in enumerate(ability.effectfunc)
                    func(ability.effectargs[i]...)
                end
            end
        end
        (sum([type ∈ permanents for type in object.type]) >= 1) ? push!(g.battlefield, object) : cache_to_zone(g, :grave, object.id)
    end
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

""" Place une carte de la cache sur le battlefield ou dans la zone de son owner. """
function cache_to_zone(g::Game, zone::Symbol, card_id::Int)
    for (i,cached_card) in enumerate(g.cache)
        if cached_card.id == card_id
            g.id += 1
            cached_card.id = g.id
            cached_card.controller = cached_card.owner
            for ability in cached_card.ability
                ability.parentcardid = g.id
            end
            if zone == :battlefield
                push!(g.battlefield, popat!(g.cache, i))
            else
                push!(getfield(str_to_p(g, cached_card.owner), zone), popat!(g.cache, i))
            end
        end
    end
end