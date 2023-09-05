# DOUBLE-FACED
FDShatterskull = Card("Shatterskull, the Hammer Pass", "", "colorless", ["land"], [tap_addR])
FUShatterskull = Card("Shatterskull Smashing", "XRR", "R", ["sorcery"], Ability[])

# LANDS
Mountain = Card("Mountain", "", "colorless", ["basic"], ["land"], String[], [tap_addR])
Nykthos = Card("Nykthos, Shrine to Nyx", "", "colorless", ["legendary"], ["land"], String[], [tap_addC])
HavenSpiritD = Card("Haven of the Spirit Dragon", "", "colorless", ["land"], [tap_addC])
SokenzaCD = Card("Sokenza, Crucible of Defiance", "", "colorless", ["legendary"], ["land"], String[], [tap_addR])

# SPELLS
AtsushiBS = Card("Atsushi, the Blazing Sky", "2RR", "R", ["legendary"], ["creature"], ["dragon", "spirit"], Ability[], 4, 4)
ScourgeV = Card("Scourge of Valkas", "2RRR", "R", String[], ["creature"], ["dragon"], Ability[], 4, 4)
OrbD= Card("Orb of Dragonkind", "1R", "R", ["artifact"], Ability[])
KFable = Card("Fable of the Mirror-Breaker", "2R", "R", String[], ["enchantment"], String["saga"], Ability[])
ManaformH = Card("Manaform Hellkite", "2RR", "R", String[], ["creature"], ["dragon"], Ability[], 4, 4)
SlumberingD = Card("Slumbering Dragon", "R", "R", String[], ["creature"], ["dragon"], Ability[], 3, 3)
DTempest = Card("Dragon Tempest", "1R", "R", ["enchantment"], Ability[])
StrikeIR = Card("Strike It Rich", "R", "R", ["sorcery"], Ability[])
ShivanDev = Card("Shivan Devastator", "XR", "R", String[], ["creature"], ["dragon", "hydra"], Ability[], 0, 0)
DBroodmother = Card("Dragon Broodmother", "2RRRG", "RG", String[], ["creature"], ["dragon"], Ability[], 4, 4)
DragonEgg = Card("Dragon Egg", "2R", "R", String[], ["creature"], ["dragon", "egg"], Ability[], 0, 2)
SarkhanF = Card("Sarkhan, Fireblood", "1RR", "R", ["legendary"], ["planeswalker"], ["sarkhan"], Ability[])

# TOKENS
Dragon2 = Card("Dragon", "none", Mana[], "R", String[], ["creature"], ["dragon"], Ability[], 2, 2, true, false, 0)
Dragon5 = Card("Dragon", "none", Mana[], "R", String[], ["creature"], ["dragon"], Ability[], 5, 5, true, false, 0)
Dragon1 = Card("Dragon", "none", Mana[], "R", String[], ["creature"], ["dragon"], Ability[], 1, 1, true, false, 0)
DragonX = Card("Dragon", "none", Mana[], "R", String[], ["creature"], ["dragon"], Ability[], 0, 0, true, false, 0)