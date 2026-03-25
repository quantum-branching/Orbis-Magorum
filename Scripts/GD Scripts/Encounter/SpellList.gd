##This script controls combat, mostly spells, allowing characters to cast a variety of spells.
extends ItemList
#region Initializing Variables that are set by CallSpell() or CallMana()
##ManaCost is the Mana Cost of the spell.
var ManaCost :int = 0
##SpellDamage is the amount of damage the spell does immediately.
var SpellDamage :float = 0
##SpellHealing is the amount of healing the spell does immediately.
var SpellHealing :float = 0
##SpellHoTVal is the amount of healing done per second when the spell is healing over time.
var SpellHoTVal :float = 0
##SpellHoTTime is the time that the healing over time takes to heal for its full value.
var SpellHoTTime :float = 0
##SpellAbsorb is the amount of health that can be absorbed by a spell.
var SpellAbsorb :float = 0
##SpellDoTVal is the amount of damage done per second when the spell is doing damage over time.
var SpellDoTVal :float = 0
##SpellDoTTime is the time that the damage over time takes to damage for its full value.
var SpellDoTTime :float = 0
##ManaOTValue is the amount of mana that is gained while the player.
var ManaOTValue :float = 0
##LeechAmount is the ratio of damage healed to damage done during a leech spell.
var LeechAmount :float = 0
##LeechTime is the duration of the leech spell (Add 3 more seconds than description calls for).
var LeechTime :float = 0
##ManaLeech is the ratio of mana gained to damage done during mana leech spell.
var ManaLeech :float = 0
##ManaSpellDamageMod is the spell damage modifier caused by a mana modifying spell.
var ManaSpellDamageMod :float = 1
##ManaSpellAvoidance is equal to the likelyhood of being hit by an attack when mana is regenerating from a mana spell.
var ManaSpellAvoidance:float = 1
##BattleDamage is a damage modifier that last the entire battle.
var BattleDamageMod:float = 1
##TimeDamageMod is a damage modifier that lasts a specific duration.
var TimeDamageMod :float = 1
##TimeDamageModTime is the duration that a damage modifier lasts (Add 3 more seconds than description calls for).
var TimeDamageModTime :float = 0
##CounterDamageMod is a damage modifier that lasts until there is no more counters.
var CounterDamageMod :float = 1
##CounterDamageModCounter is the amount of counters the damage modifiers has (Add 1 more than description calls for).
var CounterDamageModCounter :float = 0
##TimeReductionMod is the amount of damage reduction (from 0.0 to 1.0) a character obtains from a certain time sensetive spell.
var TimeReductionMod:float = 0.0
##TimeReductiontime is the amount of time that the damage reduction lasts (Add 3 more seconds than the description calls for).
var TimeReductionTime:float = 0.0
##This is the string that should pop-up as an error upon use.
var Error :String = ""
##SpecificSpellDamageMod is the modifier to the spell in the slot  [code]SpecificSpellDamageSlot[/code]  for  [code]SpecificSpellDamageTime[/code] seconds. [br][br][b]Example: [/b][codeblock]var Time = 0
##var Damage:float = 3:
##func _process(delta):
##    Time = Time+delta
##    if Time <= SpecificSpellDamageTime
##        var Mod = SpecificSpellDamageMod
##        if Slot == SpecificSpellDamageSlot:
##            Damage = Damage*Mod[/codeblock]
var SpecificSpellDamageMod = 1
##SpecificSpellDamageSlot is the slot of the spell that is modified by  [code]SpecificSpellDamageMod[/code]. [br][br][b]Example: [/b][codeblock]var Time = 0
##var Damage:float = 3:
##func _process(delta):
##    Time = Time+delta
##    if Time <= SpecificSpellDamageTime
##        var Mod = SpecificSpellDamageMod
##        if Slot == SpecificSpellDamageSlot:
##            Damage = Damage*Mod[/codeblock]
var SpecificSpellDamageSlot = 0
##SpecificSpellDamageTime is the amount of time that the spell in the slot  [code]SpecificSpellDamageSlot[/code]  is modified. [br][br][b]Example: [/b][codeblock]var Time = 0
##var Damage:float = 3:
##func _process(delta):
##    Time = Time+delta
##    if Time <= SpecificSpellDamageTime
##        var Mod = SpecificSpellDamageMod
##        if Slot == SpecificSpellDamageSlot:
##            Damage = Damage*Mod[/codeblock]
var SpecificSpellDamageTime = 0
#endregion

#region Initializing Variables that are used during action cooldown.
##This variable times each action to drive the turn-based engine.
var GlobalCD :float = 0
##This variable changes the VFX that is played by [color=63c259]Spell Icon[/color]. [codeblock]##if SpellType == 1:
##    pass #Shoot Magic Ball
##if SpellType == 2:
##    pass #Shoot Arrow
##if SpellType == 11:
##    pass #Cast AOE at self
##if SpellType == 12:
##    pass #Cast Heal at self
##if SpellType == 21:
##    pass #Cast Falling Spell at opponent[/codeblock]
var SpellType:int = 0
#endregion

#region Defining Custom Functions
##This function turns an image name from the Spell Folder into a file that can be used in code. [br][br][b]Example:[/b][codeblock] set_item_icon(SpellNo:int - 1,FileSyntax(IconName:String))[/codeblock]
func FileSyntax(Name:String) -> Resource:
	return load("".join(["res://Images/UI/Spells/",Name,".png"]))

##This function sets the icons for the spells based on a class. These images are set when loading up this script. [br][br][b]Example:[/b][codeblock]func _ready():
##    SetImage(Character.ClassNo)[/codeblock]
func SetImage(Class:int) -> void:
	set_item_icon(0,FileSyntax("Melee"))
	if Class == 1:
		set_item_icon(1,FileSyntax("Thorns"))
		set_item_icon(2,FileSyntax("Lightning"))
		set_item_icon(3,FileSyntax("Carnivorous Instincts"))
		set_item_icon(4,FileSyntax("Rejuvinate"))
		set_item_icon(5,FileSyntax("Mend Wounds"))
		set_item_icon(6,FileSyntax("Shapeshift"))
		set_item_icon(7,FileSyntax("Photosynthesis"))
	if Class == 2:
		set_item_icon(1,FileSyntax("Trap"))
		set_item_icon(2,FileSyntax("Focus"))
		set_item_icon(3,FileSyntax("Rapid Fire"))
		set_item_icon(4,FileSyntax("Evasion"))
		set_item_icon(5,FileSyntax("Leeching Arrow"))
		set_item_icon(6,FileSyntax("Poison Tipped Arrow"))
		set_item_icon(7,FileSyntax("Cheap Shot"))
	if Class == 3:
		set_item_icon(1,FileSyntax("Frost Nova"))
		set_item_icon(2,FileSyntax("Fire Ball"))
		set_item_icon(3,FileSyntax("Arcane Missiles"))
		set_item_icon(4,FileSyntax("Frostbolt"))
		set_item_icon(5,FileSyntax("Freeze Wounds"))
		set_item_icon(6,FileSyntax("Arcane Blast"))
		set_item_icon(7,FileSyntax("Arcane Intellect"))
	if Class == 4:
		set_item_icon(1,FileSyntax("Judgement"))
		set_item_icon(2,FileSyntax("Holy Strike"))
		set_item_icon(3,FileSyntax("Holy Wrath"))
		set_item_icon(4,FileSyntax("Divine Shield"))
		set_item_icon(5,FileSyntax("Renew Faith"))
		set_item_icon(6,FileSyntax("Flash Heal"))
		set_item_icon(7,FileSyntax("Desperate Prayer"))
	if Class == 5:
		set_item_icon(1,FileSyntax("Holy Nova"))
		set_item_icon(2,FileSyntax("Smite"))
		set_item_icon(3,FileSyntax("Holy Strike"))
		set_item_icon(4,FileSyntax("Holy Shield"))
		set_item_icon(5,FileSyntax("Flash Heal"))
		set_item_icon(6,FileSyntax("Priest Heal"))
		set_item_icon(7,FileSyntax("Blessing of Tranquility"))
	if Class == 6:
		set_item_icon(1,FileSyntax("Ambush"))
		set_item_icon(2,FileSyntax("Quick Stab"))
		set_item_icon(3,FileSyntax("Venomous Dagger"))
		set_item_icon(4,FileSyntax("Focus"))
		set_item_icon(5,FileSyntax("Assassins Resolve"))
		set_item_icon(6,FileSyntax("Evasion"))
		set_item_icon(7,FileSyntax("Adrenaline Rush"))
	if Class == 7:
		set_item_icon(1,FileSyntax("Astral Wrath"))
		set_item_icon(2,FileSyntax("Lightning"))
		set_item_icon(3,FileSyntax("Spectral Wolf"))
		set_item_icon(4,FileSyntax("Elemental Bulwark"))
		set_item_icon(5,FileSyntax("Cleanse"))
		set_item_icon(6,FileSyntax("Elemental Vortex"))
		set_item_icon(7,FileSyntax("Tidal Blessing"))
	if Class == -7:
		set_item_icon(1,FileSyntax("Flurry"))
		set_item_icon(2,FileSyntax("Bite"))
		set_item_icon(3,FileSyntax("Spectral Wolf"))
		set_item_icon(4,FileSyntax("Wild Instincts"))
		set_item_icon(5,FileSyntax("Rejuvinate"))
		set_item_icon(6,FileSyntax("Carnivorous Instincts"))
		set_item_icon(7,FileSyntax("Tidal Blessing"))

##This function calls the tooltip of a spell from a particular class. These tooltips are reset every cast. [br][br][b]Example:[/b][codeblock]for i in range(0,8):
##    set_item_tooltip(i,CallTooltip(Character.ClassNo,i+1))[/codeblock]
func CallTooltip(Class:int,SpellID:int) -> String:
	var Mana = 0
	CallMana(Class,SpellID)
	Mana = ManaCost
	var Name :String = ""
	var Rest :String = ""
	if Class == 1:
		if SpellID == 1:
			Name = "Attack"
			Rest = "Melee attack that does 2 damage"
		if SpellID == 2:
			Name = "Thorns"
			Rest = "Anyone who attacks this\ncharacter will take 2 damage\nfor the next 15 seconds."
		if SpellID == 3:
			Name = "Lightning Bolt"
			Rest = "This is a ranged attack that\ndoes 5 damage"
		if SpellID == 4:
			Name = "Carnivorous Instincts"
			Rest = "25% of the damage that you do\nwithin the next 3 attacks will\nheal you. Increases damage\ndone when in werewolf form by\n50% for the next 3 attacks."
		if SpellID == 5:
			Name = "Rejuvinate"
			Rest = "Heals you for 5 damage over the\nnext 5 seconds"
		if SpellID == 6:
			Name = "Mend Wounds"
			Rest = "Heals you for 5 damage instantly."
		if SpellID == 7:
			Name = "Shapeshifting"
			Rest = "Shifts you into a werewolf for\nthe next 30 seconds. While in\nwerewolf form you do 200% more\nmelee damage and take 50%\nless damage."
		if SpellID == 8:
			Name = "Photosynthesis"
			Rest = "Shifts you into a tree until\nyou reach your maximum mana.\nWhile a tree your Mana increases\nby 5 per second. You can not\ndo any damage while in tree form."
	if Class == 2:
		if SpellID == 1:
			Name = "Attack"
			Rest = "Melee attack that does 3 damage"
		if SpellID == 2:
			Name = "Trap"
			Rest = "Anyone who attacks this\ncharacter in the 3 seconds will\nbe trapped, unable to use \nranged attacks for the next 6\nseconds."
		if SpellID == 3:
			Name = "Focus"
			Rest = "The next attack that you do will\ndo 100% more damage."
		if SpellID == 4:
			Name = "Rapid Fire"
			Rest = "Does 6 damage."
		if SpellID == 5:
			Name = "Evasion"
			Rest = "25% of attacks in the next 12\nseconds will not hit you."
		if SpellID == 6:
			Name = "Leeching Arrow"
			Rest = "Your next attack within fifteen\nseconds will heal you for 200%\nof the damage done."
		if SpellID == 7:
			Name = "Poison Tipped Arrows"
			Rest = "The next 3 attacks will be\npoisoned, doing 85% more damage."
		if SpellID == 8:
			Name = "Cheap Shots"
			Rest = "Until you are have reached max\nmana, for each point of damage\nyou do you gain 1\nmana. However, your damage\nis reduced by 25%."
	if Class == 3:
		if SpellID == 1:
			Name = "Wand"
			Rest = "Ranged attack that does 1 damage"
		if SpellID == 2:
			Name = "Frost Nova"
			Rest = "The target is limited to ranged\nspells for the next 6 seconds."
		if SpellID == 3:
			Name = "Fire Ball"
			Rest = "Does 8 damage."
		if SpellID == 4:
			Name = "Arcane Missiles"
			Rest = "Does 5 damage and adds an Arcane\nCounter that can be used on\nArcane Blast."
		if SpellID == 5:
			Name = "Frostbolt"
			Rest = "Does 6 damage and lets you\nregenerate 1 mana per second."
		if SpellID == 6:
			Name = "Freeze Wounds"
			Rest = "Heals for 20 damage over the\nnext five seconds."
		if SpellID == 7:
			Name = "Arcane Blast"
			Rest = "Does 11 time the amount of\nArcane Counters damage. Using\nArcane Blast resets the Arcane\nCounters."
		if SpellID == 8:
			Name = "Arcane Intellect"
			Rest = "For the next 15 seconds your\nWand ability does 5 damage and\ngives you 10 mana."
	if Class == 4:
		if SpellID == 1:
			Name = "Attack"
			Rest = "Melee attack that does 4 damage"
		if SpellID == 2:
			Name = "Judgement"
			Rest = "You do 50% more damage for the\nnext 9 seconds"
		if SpellID == 3:
			Name = "Holy Strike"
			Rest = "Does 6 damage."
		if SpellID == 4:
			Name = "Holy Wrath"
			Rest = "You do 50% more damage for the\nnext 3 attacks."
		if SpellID == 5:
			Name = "Divine Shield"
			Rest = "You will avoid 75% of attacks\nthat happen in the next 6 seconds."
		if SpellID == 6:
			Name = "Renew Faith"
			Rest = "Heals for 6 damage over the\nnext 6 seconds"
		if SpellID == 7:
			Name = "Flash Heal"
			Rest = "Instantly heals 5 damage."
		if SpellID == 8:
			Name = "Desperate Prayer"
			Rest = "Restores 10 Mana per second but\nreduces damage done by 15% and\nprevents you from casting Holy Strike."
	if Class == 5:
		if SpellID == 1:
			Name = "Wand"
			Rest = "Ranged attack that does 2\ndamage."
		if SpellID == 2:
			Name = "Holy Nova"
			Rest = "Does 3 damage and increases the\nabsorption of Holy Shield by 3.\nDamage done by this attack is\nincreased by 50% when Holy\nShield is active. When Blessing\nof Regeneration is active\nyou gain 6 Mana."
		if SpellID == 3:
			Name = "Smite"
			Rest = "Does 5 damage but replaces\nblessing of tranquility."
		if SpellID == 4:
			Name = "Retribution"
			Rest = "Does 18 damage over the next\n12 seconds. The next three\nabilities that you do will\n deal 25% more damage."
		if SpellID == 5:
			Name = "Holy Shield"
			Rest = "Absorbs the next 15 damage"
		if SpellID == 6:
			Name = "Blessing of Regeneration"
			Rest = "Heals 12 damage over the next\n12 seconds. Deals 12 damage\nover the next 9 seconds when\nHoly Shield is active."
		if SpellID == 7:
			Name = "Heal"
			Rest = "Heals 10 damage but does not\nstack with Holy Shield. Each\npoint of Health that Holy Shield\ndoes not absorb due to this\nspell will be refunded as 1 mana."
		if SpellID == 8:
			Name = "Blessing of Tranquility"
			Rest = "You gain 3.3 Mana per second\nuntil Mana reaches\nMax Mana."
	if Class == 6:
		if SpellID == 1:
			Name = "Attack"
			Rest = "A melee attack that deals 2\ndamage."
		if SpellID == 2:
			Name = "Ambush"
			Rest = "You learn your opponents weak\nspots and create a plan of attack\nthat allows you to hit your\nenemy for 25% more damage for\nthe entire battle."
		if SpellID == 3:
			Name = "Quick Stab"
			Rest = "An attack using your dagger\nthat does 6 damage."
		if SpellID == 4:
			Name = "Venomous Dagger"
			Rest = "Imbues your dagger with poison\nincreasing the damage that you\ndo for the next 6 seconds."
		if SpellID == 5:
			Name = "Focus"
			Rest = "Increase your awareness and deal\n150% more damage on your next\nattack."
		if SpellID == 6:
			Name = "Assassin’s Resolve"
			Rest = "If you have the effect Quick Feet\nactive, gain a resolve that absorbs\nthe next 60 damage but removes\nthe Adrenaline Rush effect and\nabsorbs one less damage per\nmana currently available."
		if SpellID == 7:
			Name = "Quick Feet"
			Rest = "You become evasive, avoiding\n75% of attacks while Adrenaline\nRush is active. For every damage\ndone during Adrenaline Rush,\n5 mana is gained."
		if SpellID == 8:
			Name = "Adrenaline Rush"
			Rest = "As adrenaline rushed through\nyour veins, you gain 3.33 mana\nper second until you reach\nmaximum mana."
	if Class == 7:
		if SpellID == 1:
			Name = "Attack"
			Rest = "Does 3 damage."
		if SpellID == 2:
			Name = "Astral Wrath"
			Rest = "Initially does 1 damage but gains another damage for every 10 mana that you have.\n Elemental Vortex: Initially does 9 damage but looses another damage for every 10 mana that you have."
		if SpellID == 3:
			Name = "Lightning Bolt"
			Rest = "Does 5 damage.\nElemental Vortex: Does 5 damage and gain 4 mana per damage dealt until your Mana reaches Max Mana. However damage is reduced by 50% until Mana reached MaxMana."
		if SpellID == 4:
			Name = "Spectral Wolf"
			Rest = "Turns you into a spectral wolf which changes the spells you have\nElemental Vortex: Turns you into a spectral wolf which changes the spells you have and you gain 1 mana per damage dealt until your Mana reaches Max Mana."
		if SpellID == 5:
			Name = "Elemental Bulwark"
			Rest = "You take 40% less damage for the next 30 seconds. However, for the next 30 seconds you also deal 20% less damage.\nElemental Vortex: Absorb 90 damage."
		if SpellID == 6:
			Name = "Cleanse"
			Rest = "Heals 6 damage.\nElemental Vortex: Absorb 90 damage and gain 15 mana per turn until Mana reaches Max Mana."
		if SpellID == 7:
			Name = "Elemental Vortex"
			Rest = "Does 10 damage and changes the effect of the next spell."
		if SpellID == 8:
			Name = "Tidal Blessing"
			Rest = "Increases mana by 2 per damage done until your Mana reaches Max Mana.\nElemental Vortex: Gain 20 Mana per turn until your Mana reaches Max Mana. However, you deal 50% damage until your Mana reaches Max Mana."
	if Class == -7:
		if SpellID == 1:
			Name = "Attack"
			Rest = "Does 3 damage."
		if SpellID == 2:
			Name = "Flurry"
			Rest = "Deals 100% more damage for the next 15 seconds."
		if SpellID == 3:
			Name = "Bite"
			Rest = "Does 3 damage and regenerates 5 mana."
		if SpellID == 4:
			Name = "Spectral Wolf"
			Rest = "You revert from being a spectral wolf."
		if SpellID == 5:
			Name = "Wild Instincts"
			Rest = "You gain 1 health for every 2 damage dealt."
		if SpellID == 6:
			Name = "Spiritual Healing"
			Rest = "Absorbs the 30*[Level] damage."
		if SpellID == 7:
			Name = "Frenzy"
			Rest = "Deal 100% more damage for the next 9 seconds."
		if SpellID == 8:
			Name = "Tidal Blessing"
			Rest = "Increases mana by 2 per damage done until your Mana reaches Max Mana."
	return "".join([Name,"\nCosts: ",Mana," Mana\n",Rest])


##This function calls the mana cost of a certain spell. [br][br][b]Example:[/b][codeblock]CallMana(Character.ClassNo,Index)
##if Character.Mana >= ManaCost:
##    CallSpell(Character.ClassNo,index)
##    Character.Mana = Character.Mana - ManaCost
##    #Cast Spell
##else:
##    Error = "Too Expensive" [/codeblock][br][b]Note:[/b] This is reloaded when a spell is cast.
func CallMana(Class:int,SpellID:int) -> void:
	ManaCost = 0
	if Class == 1:
		if SpellID == 2:
			ManaCost = 15
		if SpellID == 3:
			ManaCost = 5
		if SpellID == 4:
			ManaCost = 20
		if SpellID == 5:
			ManaCost = 7
		if SpellID == 6:
			ManaCost = 10
		if SpellID == 7:
			ManaCost = 50
	if Class == 2:
		if SpellID == 2:
			ManaCost = 10
		if SpellID == 3:
			ManaCost = 5
		if SpellID == 4:
			ManaCost = 8
		if SpellID == 5:
			ManaCost = 10
		if SpellID == 6:
			ManaCost = 15
		if SpellID == 7:
			ManaCost = 7
	if Class == 3:
		if SpellID == 1 and SpecificSpellDamageMod == 5:
			ManaCost = -10
		if SpellID == 2:
			ManaCost = 25
			if ManaOTValue > 0:
				ManaCost = int(0.25 * ManaCost)
		if SpellID == 3:
			ManaCost = 10
		if SpellID == 4:
			ManaCost = 20
		if SpellID == 5:
			ManaCost = 6
		if SpellID == 6:
			ManaCost = 10 + int(Character.Mana/10)
	if Class == 4:
		if SpellID == 2:
			ManaCost = 15
		if SpellID == 3:
			ManaCost = 15
		if SpellID == 4:
			ManaCost = 20
		if SpellID == 5:
			ManaCost = 30
		if SpellID == 6:
			ManaCost = 15
		if SpellID == 7:
			ManaCost = 10
	if Class == 5:
		if SpellID == 2:
			ManaCost = 0
		if SpellID == 3:
			ManaCost = 5
		if SpellID == 4:
			ManaCost = 18
		if SpellID == 5:
			ManaCost = 15
			if ManaOTValue > 0:
				ManaCost = 0
		if SpellID == 6:
			ManaCost = 12
		if SpellID == 7:
			ManaCost = 10
	if Class == 6:
		if SpellID == 2:
			ManaCost = 60
		if SpellID == 3:
			ManaCost = 3
		if SpellID == 4:
			ManaCost = 4
		if SpellID == 5:
			ManaCost = 5
		if SpellID == 6:
			ManaCost = 0
		if SpellID == 7:
			ManaCost = 0
	if Class == 7:
		if SpellID == 2:
			ManaCost = 0
		if SpellID == 3:
			ManaCost = 0
		if SpellID == 4:
			if CounterDamageModCounter < 0:
				ManaCost = 50
			else:
				ManaCost = 0
		if SpellID == 5:
			if CounterDamageModCounter < 0:
				ManaCost = 20
			else:
				ManaCost = 0
		if SpellID == 6:
			if CounterDamageModCounter < 0:
				ManaCost = 10
			else:
				ManaCost = 0
		if SpellID == 7:
			ManaCost = 80
	if Class == -7:
		if SpellID == 2:
			ManaCost = 15
		if SpellID == 3:
			ManaCost = -5
		if SpellID == 4:
			ManaCost = 0
		if SpellID == 5:
			ManaCost = 0
		if SpellID == 6:
			ManaCost = 80
		if SpellID == 7:
			ManaCost = 40

##This function executes most of the spell, while setting other variable to be read before the turn ends. [br][br][b]Note:[/b] Only call this when a spell is cast. Any script attached to this spell will only be called when the spell is cast.
func CallSpell(Class:int,SpellID:int) -> void:
	CallMana(Class,SpellID)
	SpellDamage = 0
	SpellHealing = 0
	Error = ""
	if Class == 1:
		if SpellID == 1:
			SpellDamage = 2
		if SpellID == 2:
			Error = "Thorns not added yet"
		if SpellID == 3:
			SpellDamage = 5
		if SpellID == 4:
			LeechAmount = .25
			LeechTime = 12
			CounterDamageMod = 1.5
			CounterDamageModCounter = 4
			ManaLeech = .85
		if SpellID == 5:
			SpellHoTVal = 1
			SpellHoTTime = 5
		if SpellID == 6:
			SpellHealing = 10
		if SpellID == 7:
			SpecificSpellDamageMod = 3
			SpecificSpellDamageSlot = 1
			SpecificSpellDamageTime = 33
			TimeReductionMod = .5
			TimeReductionTime = 33
		if SpellID == 8:
			ManaOTValue = 5
			ManaSpellDamageMod = 0
	if Class == 2:
		if SpellID == 1:
			SpellDamage = 3
		if SpellID == 2:
			Error = "Traps not added yet"
		if SpellID == 3:
			TimeDamageMod = 2
			TimeDamageModTime = 6
		if SpellID == 4:
			SpellDamage = 6
		if SpellID == 5:
			TimeReductionMod = .25
			TimeReductionTime = 15
		if SpellID == 6:
			LeechAmount = 2
			LeechTime = 18
		if SpellID == 7:
			CounterDamageMod = 1.85
			CounterDamageModCounter = 4
		if SpellID == 8:
			ManaSpellDamageMod = 0.75
			ManaLeech = 1
	if Class == 3:
		if SpellID == 1:
			SpellDamage = 1
		if SpellID == 2:
			Error = "Melee prevention not added yet"
		if SpellID == 3:
			SpellDamage = 8
		if SpellID == 4:
			SpellDamage = 5
			CounterDamageModCounter = CounterDamageModCounter + 2
		if SpellID == 5:
			SpellDamage = 6
			ManaOTValue = 1
		if SpellID == 6:
			SpellHoTVal = 4
			SpellHoTTime = 5
		if SpellID == 7:
			SpellDamage = 11 * CounterDamageModCounter
			CounterDamageModCounter = 0
		if SpellID == 8:
			SpecificSpellDamageMod = 5
			SpecificSpellDamageSlot = 1
			SpecificSpellDamageTime = 18
	if Class == 4:
		if SpellID == 1:
			SpellDamage = 4
		if SpellID == 2:
			TimeDamageMod = 1.5
			TimeDamageModTime = 12
		if SpellID == 3:
			if ManaOTValue > 0:
				SpecificSpellDamageMod = 0
				SpecificSpellDamageSlot = 3
				SpecificSpellDamageTime = 6
			SpellDamage = 6
		if SpellID == 4:
			CounterDamageMod = 1.5
			CounterDamageModCounter = 4
		if SpellID == 5:
			TimeReductionMod = .75
			TimeReductionTime = 9
		if SpellID == 6:
			SpellHoTVal = 1
			SpellHoTTime = 6
		if SpellID == 7:
			SpellHealing = 10
		if SpellID == 8:
			SpecificSpellDamageMod = 0
			SpecificSpellDamageSlot = 3
			SpecificSpellDamageTime = 6
			ManaSpellDamageMod = .85
			ManaOTValue = 10
	if Class == 5:
		if SpellID == 1:
			SpellDamage = 2
		if SpellID == 2:
			SpellDamage = 3
			if SpellAbsorb > 0:
				SpellAbsorb = 3 + SpellAbsorb
				SpellDamage = 4.5
		if SpellID == 3:
			SpellDamage = 5
			ManaOTValue = 0
		if SpellID == 4:
			SpellDoTVal = 1.5
			SpellDoTTime = 12
			CounterDamageMod = 1.25
			CounterDamageModCounter = 4
		if SpellID == 5:
			SpellAbsorb = 15
		if SpellID == 6:
			SpellHoTTime = 9
			SpellHoTVal = 4.0/3
			if SpellAbsorb > 0:
				SpellDoTTime = SpellHoTTime
				SpellDoTVal = SpellHoTVal
		if SpellID == 7:
			SpellHealing = 10
			Character.Mana = Character.Mana + min(SpellAbsorb,10)
			SpellAbsorb = max(SpellAbsorb-10,0)
		if SpellID == 8:
			ManaOTValue = 10.0/3
	if Class == 6:
		if SpellID == 1:
			SpellDamage = 2
		if SpellID == 2:
			BattleDamageMod = 1.25
		if SpellID == 3:
			SpellDamage = 6
		if SpellID == 4:
			TimeDamageMod = 1.5
			TimeDamageModTime = 9
		if SpellID == 5:
			CounterDamageMod = 2.5
			CounterDamageModCounter = 2
		if SpellID == 6:
			if ManaSpellAvoidance < 1:
				SpellAbsorb = Character.ManaMax - Character.Mana
		if SpellID == 7:
			if ManaOTValue:
				ManaSpellAvoidance = .25
				ManaLeech = 5
		if SpellID == 8:
			ManaOTValue = 10.0/3.0
	if Class == 7:
		if SpellID == 1:
			SpellDamage = 3
		if SpellID == 2:
			if CounterDamageModCounter <= 0:
				SpellDamage = 1 + Character.Mana/10
			else:
				SpellDamage = 9 - Character.Mana/10
		if SpellID == 3:
			SpellDamage = 5
			if CounterDamageModCounter > 0:
				ManaLeech = 4
				ManaSpellDamageMod = .5
		if SpellID == 4:
			Character.ClassNo = -7
			SetImage(-7)
			if CounterDamageModCounter > 0:
				ManaLeech = 1
		if SpellID == 5:
			if CounterDamageModCounter <= 0:
				TimeReductionMod = .6
				TimeReductionTime = 33
			else:
				SpellAbsorb = 90
		if SpellID == 6:
			if CounterDamageModCounter <= 0:
				SpellHealing = 6
			else:
				SpellAbsorb = 30
				ManaOTValue = 9
		if SpellID == 7:
			SpellDamage = 10
			CounterDamageModCounter = 2
		if SpellID == 8:
			if CounterDamageModCounter > 0:
				ManaLeech = 2
			else:
				ManaOTValue = 20/3.0
				ManaSpellDamageMod = 0.5
	if Class == -7:
		if SpellID == 1:
			SpellDamage = 3
		if SpellID == 2:
			TimeDamageMod = 2
			TimeDamageModTime = 12
		if SpellID == 3:
			SpellDamage = 3
			Character.Mana = Character.Mana + 5
		if SpellID == 4:
			Character.ClassNo = 7
			SetImage(7)
		if SpellID == 5:
			LeechAmount = 0.5
			LeechTime = 15
		if SpellID == 6:
			SpellAbsorb = 30
		if SpellID == 7:
			TimeDamageMod = 2
			TimeDamageModTime = 9
		if SpellID == 8:
			ManaLeech = 2

#endregion

#region Run-Time/Built-in Functions
#Function that runs when the scene starts.
#NOTE: This function only runs TWICE (one at the beginning of the animation) at the beggining of the encounter.
func _ready():
	SetImage(Character.ClassNo)
	for i in range(0,8):
		set_item_tooltip(i,CallTooltip(Character.ClassNo,i+1))

#Run-Time function
func _process(delta):
	if GlobalCD == 0:
		for i in range(0,8):
			CallMana(Character.ClassNo,i+1)
		#Binds Keys to Spells
		if Input.is_physical_key_pressed(KEY_1):
			select(0)
		if Input.is_physical_key_pressed(KEY_2):
			select(1)
		if Input.is_physical_key_pressed(KEY_3):
			select(2)
		if Input.is_physical_key_pressed(KEY_4):
			select(3)
		if Input.is_physical_key_pressed(KEY_5):
			select(4)
		if Input.is_physical_key_pressed(KEY_6):
			select(5)
		if Input.is_physical_key_pressed(KEY_7):
			select(6)
		if Input.is_physical_key_pressed(KEY_8):
			select(7)
		#Checks for Selected Spells
		var Index = 0
		for i in range(0,8):
			CallMana(Character.ClassNo,i+1)
			if ManaCost > Character.Mana:
				set_item_disabled(i,true)
			else:
				set_item_disabled(i,false)
			if is_selected(i):
				Index = i + 1
		if Index > 0:
			CallMana(Character.ClassNo,Index)
			if ManaCost <= Character.Mana:
				CallSpell(Character.ClassNo,Index)
				Character.Mana = Character.Mana - ManaCost
				$"../Opponent".HP = $"../Opponent".HP - BattleDamageMod*SpellDamage*ManaSpellDamageMod*TimeDamageMod*CounterDamageMod
				if Index == SpecificSpellDamageSlot:
					$"../Opponent".HP = $"../Opponent".HP - BattleDamageMod*SpellDamage*ManaSpellDamageMod*TimeDamageMod*CounterDamageMod*(SpecificSpellDamageMod-1)
				Character.HP = Character.HP + SpellHealing + BattleDamageMod*SpellDamage*ManaSpellDamageMod*TimeDamageMod*CounterDamageMod*LeechAmount
				Character.Mana = Character.Mana + BattleDamageMod*SpellDamage*ManaSpellDamageMod*TimeDamageMod*CounterDamageMod*ManaLeech
				if Index == SpecificSpellDamageSlot:
					Character.Mana = Character.Mana + BattleDamageMod*SpellDamage*ManaSpellDamageMod*TimeDamageMod*CounterDamageMod*ManaLeech*(SpecificSpellDamageMod-1)
				if CounterDamageModCounter > 0:
					CounterDamageModCounter = CounterDamageModCounter - 1
				GlobalCD = 3
				if ManaSpellAvoidance >= 1 || randf() <= ManaSpellAvoidance:
					Character.HP = Character.HP - ManaSpellAvoidance*(1-TimeReductionMod)*max($"../Opponent".Damage-SpellAbsorb,0)
				SpellAbsorb = max(SpellAbsorb - $"../Opponent".Damage,0)
				for i in range(0,8):
					set_item_tooltip(i,CallTooltip(Character.ClassNo,i+1))
			deselect_all()
	#Most actions occur during GlobalCD
	if GlobalCD > 0:
		GlobalCD = GlobalCD - (delta * Global.CombatSpeed)
		#Prevents GlobalCD from being negative
		if GlobalCD < 0:
			GlobalCD = 0
		if SpellDoTTime > 0:
			SpellDoTTime = SpellHoTTime - (delta * Global.CombatSpeed)
			$"../Opponent".HP = $"../Opponent".HP - SpellDoTVal * (delta * Global.CombatSpeed)
			if SpellDoTTime <= 0:
				#Removes DoT after time runs out
				SpellDoTTime = 0
				SpellDoTVal = 0
		if SpellHoTTime > 0:
			SpellHoTTime = SpellHoTTime - (delta * Global.CombatSpeed)
			Character.HP = Character.HP + SpellHoTVal * (delta * Global.CombatSpeed)
			if SpellHoTTime <= 0:
				#Removes HoT after time runs out
				SpellHoTTime = 0
				SpellHoTVal = 0
		if ManaOTValue > 0:
			Character.Mana = Character.Mana + ManaOTValue * (delta * Global.CombatSpeed)
		if LeechTime > 0:
			LeechTime = LeechTime - (delta * Global.CombatSpeed)
			#Prevents LeechTime from being negative
			if LeechTime < 0:
				#Removes Leech effect after time has passed
				LeechAmount = 0
				LeechTime = 0
		if Character.HP > Character.HPMax:
			Character.HP = Character.HPMax
		if Character.Mana >= Character.ManaMax:
			#Prevents Mana from increasing above Max Mana
			Character.Mana = Character.ManaMax
			#Resets ManaSpell Modifiers after reaching Max Mana
			ManaSpellDamageMod = 1
			ManaOTValue = 0
			ManaLeech = 0
			ManaSpellAvoidance = 1
		if TimeDamageModTime > 0:
			TimeDamageModTime = TimeDamageModTime - (delta * Global.CombatSpeed)
			#Prevents TimeDamageModTime from being negative
			if TimeDamageModTime < 0:
				#Removes TimeDamageMod Buff after time has passed
				TimeDamageMod = 1
				TimeDamageModTime = 0
		if CounterDamageModCounter <= 0:
			#Prevents CounterDamageMod Counter from being negative
			CounterDamageModCounter = 0
			#Removes CounterDamageMod Modifier after running out of counters
			CounterDamageMod = 1
		if SpecificSpellDamageTime >= 0:
			SpecificSpellDamageTime = SpecificSpellDamageTime - (delta * Global.CombatSpeed)
			if SpecificSpellDamageTime <= 0:
				#Removes SpecificSpellDamage Modifier when time runs out
				SpecificSpellDamageTime = 0
				SpecificSpellDamageSlot = 0
				SpecificSpellDamageMod = 1

#endregion
