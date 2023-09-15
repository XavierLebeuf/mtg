# DOUBLE-FACED
FUShatterskull = GenCard("Shatterskull Smashing", [:X, :R, :R], [:R], Symbol[], [:sorcery], Symbol[], Ability[])
FDShatterskull = LandCard("Shatterskull, the Hammer Pass", Symbol[], Symbol[], [tap_addR])
FUKFable = GenCard("Fable of the Mirror-Breaker", [:GE, :GE, :R], [:R], Symbol[], [:enchantment], [:saga], Ability[])
FDKFable = Card("Reflection of Kiki-Jiki", Symbol[], [:R], Symbol[], [:enchantment, :creature], [:goblin, :shaman], Ability[], 2, 2, nothing, false)

# LANDS
Mountain = LandCard("Mountain", [:basic], Symbol[], [tap_addR])
Nykthos = LandCard("Nykthos, Shrine to Nyx", [:legendary], Symbol[], [tap_addCL])
HavenSpiritD = LandCard("Haven of the Spirit Dragon", Symbol[], Symbol[], [tap_addCL])
SokenzaCD = LandCard("Sokenza, Crucible of Defiance", [:legendary], Symbol[], [tap_addR])

# CREATURES
AtsushiBS = CreatureCard("Atsushi, the Blazing Sky", [:GE, :GE, :R, :R], [:R], [:legendary], [:dragon, :spirit], Ability[], 4, 4)
ScourgeV = CreatureCard("Scourge of Valkas", [:GE, :GE, :R, :R, :R], [:R], Symbol[], [:dragon], Ability[], 4, 4)
ManaformH = CreatureCard("Manaform Hellkite", [:GE, :GE, :R, :R], [:R], Symbol[], [:dragon], Ability[], 4, 4)
SlumberingD = CreatureCard("Slumbering Dragon", [:R], [:R], Symbol[], [:dragon], Ability[], 3, 3)
ShivanDev = CreatureCard("Shivan Devastator", [:X, :R], [:R], Symbol[], [:dragon, :hydra], Ability[], 0, 0)
DBroodmother = CreatureCard("Dragon Broodmother", [:GE, :GE, :R, :R, :G], [:R, :G], Symbol[], [:dragon], Ability[], 4, 4)
DragonEgg = CreatureCard("Dragon Egg", [:GE, :GE, :R], [:R], Symbol[], [:dragon, :egg], Ability[], 0, 2)

# PLANESWALKER
SarkhanF = PlaneswalkerCard("Sarkhan, Fireblood", [:GE, :R, :R], [:R], [:legendary], [:sarkhan], Ability[], 3)

# NON CREATURE NON LAND NON PLANESWALKER CARDS
OrbDragonK = GenCard("Orb of Dragonkind", [:GE, :R], [:R], Symbol[], [:artifact], Symbol[], Ability[])
DTempest = GenCard("Dragon Tempest", [:GE, :R], [:R], Symbol[], [:enchantment], Symbol[], Ability[])
StrikeIR = GenCard("Strike It Rich", [:R], [:R], Symbol[], [:sorcery], Symbol[], [create_treasure])

# TOKENS
Dragon2 = Card("Dragon", Symbol[], [:R], Symbol[], [:creature], [:dragon], Ability[], 2, 2, nothing, true)
Dragon5 = Card("Dragon", Symbol[], [:R], Symbol[], [:creature], [:dragon], Ability[], 5, 5, nothing, true)
Dragon1 = Card("Dragon", Symbol[], [:R], Symbol[], [:creature], [:dragon], Ability[], 1, 1, nothing, true)
DragonX = Card("Dragon", Symbol[], [:R], Symbol[], [:creature], [:dragon], Ability[], 0, 0, nothing, true)
Treasure = Card("Treasure", Symbol[], [:CL], Symbol[], [:artifact], Symbol[], Ability[], nothing, nothing, nothing, true)