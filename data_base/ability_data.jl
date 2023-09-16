# ACTIVATED ABILITIES

tap_addR = ActivatedAbility("Tap for one red",
    true, [:battlefield], [tap_untapped!], [[:gm, :pc]], [add_mana!], [[:pp, :R]])
tap_addCL = ActivatedAbility("Tap for one colorless",
    true, [:battlefield], [tap_untapped!], [[:gm, :pc]], [add_mana!], [[:pp, :CL]])
tap_sac_addA = ActivatedAbility("Tap sac for one mana of any color",
    true, [:battlefield], [tap_untapped!, sacrifice!], [[:gm, :pc], [:gm, :pp, :pc]], [add_mana!], [[:pp, :u1]])
#m1_loot = ActivatedAbility("-1 loyalty may discard, if do, draw",
#    false, [:batllefield], [modify_loyalty!], [[:gm, :pc, -1]], [], [[]])
#p1_addRR = ActivatedAbility("+1 loyalty add A*A* for casting dragons",
#    false, [:batllefield], [modify_loyalty!], [[:gm, :pc, +1]], [], [[]])
#m7_create_4drag = ActivatedAbility("-7 loylty create 4 5/5 dragons",
#    false, [:batllefield], [modify_loyalty!], [[:gm, :pc, -7]], [], [[]])

# STATIC ABILITIES

# Keywords
#flashback2R = StaticAbility("Flashback 2R", [:GE, :GE, :R])
#flying = StaticAbility("Flying",
#haste = StaticAbility("Haste",
#defender = StaticAbility("Defender",
#trample = StaticAbility("Trample",

# Specific
#etb_with_Xc = StaticAbility("Etb avec X +1/+1c",
#attack_if_5c = StaticAbility("Can only attack if 5 +1/+1c",
#block_if_5c = StaticAbility("Can only block if 5 +1/+1c",

# SPELL ABILITIES

create_treasure = SpellAbility("Create treasure", [create_token!], [[:gm, :pp, :tr]])