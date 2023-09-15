""" Initialise un joueur. """
function initialize_player(name::String, deck_list::DeckList, format::String)
    try
        global g; check_step(:white, ["Initialisation"], g.step)
    catch error
        (error == UndefVarError(:g)) && (global g = Game())
    end

    (starting_life,deck_size) = (20,60)
    (format == "commander") && ((starting_life,deck_size) = (40,100))
    (format ∉ deck_list.formats) && throw(ArgumentError("Deck list is valid in formats $(deck_list.formats), not $format."))

    deck = create_deck!(g, deck_list, deck_size, name)
    player = Player(name, deck_list.name, starting_life, deck)
    push!(g.players, player)

    shuffle_lib!(player)
    draw!(player, 7)
    show(player)
    println()
    return player
end

""" Obtient un ordre de tours de jeu, et le premier joueur décide qui commence. """
function get_turn_order!()
    global g; check_step(:white, ["Initialisation/start"], g.step)
    
    shuffle!(g.players)
    (length(g.players) > 2) && show_turn_order()
    println("$(g.players[1].name), choisi qui commence.")

    next_step!(g)
    return
end

""" Décide quel joueur commence. """
function choose_starting_player!(p::Player)
    global g; check_step(:white, ["Initialisation/choose_starter"], g.step)

    g.starter = p.name
    g.priority = p.name
    while (active_p(g).name != p.name)
        next_active_p!(g)
    end
    println("$(p.name) commence.")
    show_hand(p)
    println()

    next_step!(g)
    return
end

""" Effectue un London mulligan. """
function mulligan!(p::Player)
    global g; check_step(:white, ["Initialisation/hand_decisions"], g.step)
    (p.name != active_p(g).name) && throw(ErrorException("It's $(active_p(g).name)'s turn to choose to keep or mulligan."))
    (p.mulligan == 7) && throw(ErrorException("You can't mulligan plus que 7 fois."))

    for card_id in deepcopy([card.id for card in p.hand])
        hand_to_libtop!(p, card_id)
    end
    shuffle_lib!(p)
    draw!(p, 7)
    p.mulligan += 1
    show_hand(p)
    println()
    return
end

""" Conserve la main de départ.
    Si le joueur a mulliganer, il doit indiquer les indices des cartes qu'il place en-dessous de la librairie. """
function keep_hand!(p::Player, bottom_ids...)
    global g; check_step(:white, ["Initialisation/hand_decisions"], g.step)
    bottom_ids = collect(bottom_ids)
    (p.name != active_p(g).name) && throw(ErrorException("It's $(active_p(g).name)'s turn to choose to keep or mulligan."))
    (p.mulligan != length(bottom_ids)) && throw(ErrorException("Autant d'indices de cartes à mettre en-dessous de la librairie que de mulligans effectués doivent être indiqués. $(p.mulligan) ici."))
    !all([card_id ∈ [card.id for card in p.hand] for card_id in bottom_ids]) && throw(ErrorException("La carte of id $(card_id) is not dans la main."))

    for card_id in bottom_ids
        hand_to_libbot!(p, card_id)
    end

    next_active_p!(g)
    (active_p(g).name == g.starter) ? next_step!(g) : show_hand(active_p(g))
    return
end

""" Passe la priorité au prochain joueur.
    Le joueur qui la détient actuellement et qui passe est en argument. """
function pass_priority!(p::Player)
    global g; check_step(:black, ["Initialisation"], g.step)
    (g.priority != p.name) && throw(ErrorException("Un joueur ne peut passer la priorité que s'il la détient. $(g.priority) ici."))

    p.prioritypass = true

    next = 0
    for (i,player) in enumerate(g.players)
        (player.name == p.name) && (next = i+1)
    end
    (next > length(g.players)) && (next = 1)
    g.priority = g.players[next].name

    if all_passed_priority(g)
        reset_priority!(g)
        if length(g.stack) > 0
            resolve_stack_top!(g)
        else
            next_step!(g)
        end
    end
    return
end

""" Jouer une land. """
function play!(p::Player, card_id::Int)
    global g; check_step(:white, ["main"], g.step)
    (:land ∉ id_to_object(card_id, p.hand).type) && throw(ErrorException("Seulement les lands peuvent être played. $(id_to_object(card_id, p.hand).name) doit être casté."))
    !(p.name == g.priority && active_p(g).name == p.name) && throw(ErrorException("Un joueur ne peut que jouer une land lorsqu'il a priorité durant son tour."))
    (length(g.stack) != 0) && throw(ErrorException("Un joueur ne peut que jouer une land lorsque le stack est vide."))
    p.playedland && throw(ErrorException("Une seul land peut être jouée par tour"))

    move_card!(card_id, p.hand, g.battlefield)
    p.playedland = true
    return
end

""" Activate an avtivated ability d'un permanent sur le battlefield. """
function activate!(p::Player, card_id::Int, ability_index::Int, targets::Vector{Any})
    global g;
    card = id_to_object(card_id, g.battlefield)
    ability = card.ability[ability_index]
    (p.name != card.controller) && throw(ErrorException("Un joueur ne peut qu'activer une abilité d'un permanent qu'il contrôle."))
    (p.name != g.priority) && throw(ErrorException("Un joueur ne peut qu'activer une abilité lorsqu'il a la priorité."))
    (:batt ∉ ability.zone) && throw(ErrorException("Cette abilité ne s'active pas from the battlefield."))

    ability = substitute_args(g, ability, targets)
    for (i, func) in enumerate(ability.costfunc)
        func(ability.costargs[i,:]...)
    end
    if ability.manaability
        for (i, func) in enumerate(ability.effectfunc)
            func(ability.effectargs[i,:]...)
        end
    else
        #push_stack!(ability)
    end
    return
end

""" Activate la première abilité si elle n'a pas de targets d'un permanent sur le battlefield. """
activate!(p::Player, card_id::Int) = activate!(p, card_id, 1, Any[])

""" Activate la première abilité d'un permanent sur le battlefield. """
activate!(p::Player, card_id::Int, targets::Vector{Any}) = activate!(p, card_id, 1, targets)

""" Activate une abilité si elle n'a pas de targets d'un permanent sur le battlefield. """
activate!(p::Player, card_id::Int, ability_index::Int) = activate!(p, card_id, ability_index, Any[])

""" Cast a spell de la main avec targets. """
function cast!(p::Player, card_id::Int, mana_ids::Vector{Int}, targets::Vector{Any})
    global g;
    card = id_to_object(card_id, p.hand)
    (card.type != :instant) && check_step(:white, ["main"], g.step)
    (length(g.stack) != 0 && card.type != :instant) && throw(ErrorException("Un joueur ne peut que caster une carte de type $(card.type) lorsque le stack est vide."))
    (p.name != g.priority) && throw(ErrorException("Un joueur ne peut que caster un spell lorsqu'il a la priorité."))

    pay_mana!(p, card, mana_ids)
    unique_card = deepcopy(card)
    push!(g.cache, popat!(p.hand, id_to_index(card_id, p.hand)))
    for (i,ability) in enumerate(unique_card.ability)
        if ability.type == :spell
            unique_card.ability[i] = substitute_args(g, ability, targets)
        end
    end
    push!(g.stack, unique_card)
    return
end

""" Cast un spell sans targets de la main avec toute la mana de la mana pool. """
cast!(p::Player, card_id::Int) = cast!(p, card_id, collect(1:length(p.manapool)), Any[])

""" Cast un spell sans targets de la main. """
cast!(p::Player, card_id::Int, mana_ids::Vector{Int}) = cast!(p, card_id, mana_ids, Any[])

""" Cast un spell avec tarets de la main avec toute la mana de la mana pool. """
cast!(p::Player, card_id::Int, targets::Vector{Any}) = cast!(p, card_id, collect(1:length(p.manapool)), targets)