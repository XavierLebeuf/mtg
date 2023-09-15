tap_addR = ActivatedAbility(true, [:batt], [tap_untapped!], [:gm :pc], [add_mana!], [:pp :R])
tap_addCL = ActivatedAbility(true, [:batt], [tap_untapped!], [:gm :pc], [add_mana!], [:pp :CL])
create_treasure = SpellAbility([create_token!], [:gm :pp :tr])
#flashback
#sac_treasure