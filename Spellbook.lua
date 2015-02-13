---------------------------
-- BadRobots Spellbook	-- Used to create and maintain the players spellbook. Its bot static and dynamic,
--------------------------
print("Spellbook loaded")
-----------------------------------
-- SpellBook Class : 
-----------------------------------
spellbook = {}

function spellbook:init()

	---------------------
	-- Racials
	---------------------
	Berserkering 	= 26297	-- Troll Racial
	
	----------------------
	-- Trinkets
	----------------------
	Instability		= 177051  -- trinket 113948
	MoltenMetal		= 177081  -- trinket 113984
	HowlingSoul		= 177046  -- trinket 119194

	---------------------
	-- Glyphs
	---------------------
	GlyphConeOfCold	= 115705

	
	---------------------
	-- Mage
	---------------------
	AlterTime		= 108978
	ArcaneBrilliance= 1459
	ArcaneAffinity	= 166871
	ArcaneCharge	= 36032
	ArcanePower		= 12042
	Archmage		= 177176
	ArcaneOrb		= 153626
	ArcaneBarrage	= 44425
	ArcaneBlast		= 30451
	ArcaneExplosion	= 1449
	ArcaneMissiles	= 5143
	ArcaneMissilesP	= 79683
	BlazingSpeed	= 108843
	BrainFreeze		= 57761
	BlastWave		= 157981
	Cauterize		= 86949
	Combustion		= 11129
	CometStorm		= 153595
	ColdSnap		= 11958
	
	Evocation		= 12051 --Standard
	EvocationImp	= 157614 -- improved versions
	Evanesce		= 157913
	EnhancedFB		= 157646
	EnhancedPyro	= 157644
	Flameglow		= 140468
	FrostBomb 		= 112948
	Fireball		= 133
	Frostbolt		= 116
	FrostfireBolt	= 44614
	Frostjaw		= 102051
	FrozenOrb		= 84714
	FrozenOrbDebuff = 84721
	FingersOfFrost	= 44544
	GreaterInvisibility = 110959
	HeatingUp		= 48107
	IceShard		= 166869
	IceFloes		= 108839
	IceLance		= 30455
	IceBlock		= 45438
	IcyVeins		= 12472
	IceWard			= 111264
	IceBarrier		= 11426
	IceNova			= 157997
	Ignite			= 12654 --12846 (mastery: ignite)
	IncantersFlow 	= 1463
	InfernoBlast	= 108853
	LivingBomb		= 44457
	MirrorImage 	= 55342
	MarkOfTheT		= 159234
	NetherTempest	= 114923
	Overpowered		= 155147
	PrismaticCrystal = 155152
	PresenceOfMind  = 12043
	Pyroblast		= 11366
	PyroblastBuff	= 48108
	Pyromaniac		= 166868
	RuneOfPower		= 116011
	RingOfFrost		= 113724
	SummonPet		= 31687
	Scorch          = 2948
	Supernova 		= 157980
	ThermalVoid		= 155149
	UnstableExplo	= 157976
	UnstableMagic	= 157976
	WaterJet		= 135029
	T17_4P_Frost	= 165469
	T17_4P_Arcane	= 166872  -- Arcane Instability


end

function spellbook.update(SpellID, event)
	--print("Got Event : " ..event)
	-- Todo : Here we need to look at the spellid in the player.spell[spellID] and set values to it. This is so that we can define what will happen if the spell is
	-- cast. For example if the spell have a cd we can already set it now instead of client saying it, we could also set a debuff on target or buff on ourself to prevent lag and double cast
	-- How do we do this, we need the cd value but we also need to set actual CD, the player.spell is only the information of the spell? 
end

function spellbook:mageSpells()
	-- Todo : fill in this at start, event should update them, refresh when we leave combat etc
	-----------------------------
	-- Mage Spells 				-- Holds information about all mage spells. [spellid] = { cd, playerdebuff, targetdebuff. playerbuff, targetbuff, spammable, canMove etc Alot of the castSpell parameters should be moved here
	--							-- This list should be init at the start and then updated via events and also castSpell. This is for example if we are cast frostbolt, then BadRobot should update the target of the cast with a debuff which is then confirmed by wow client via events
	--							--	No more timers or double cast
	----------------------------

				
	local MageSpells = {
		[ArcaneBlast] 			= 	{ cd = 0, playerdebuff = 36032 },  -- Todo : We need to configure spells correctly, Arcane Blast is giving a debuff on player max stacks 4
		
		[ArcaneMissiles] 		= 	{ cd = 0 },
		[ArcaneBarrage] 		= 	{ cd = 0 },		--Removes playerdebuff 36032
		[Evocation] 			=	{ cd = 90 },	-- Channel that ticks?
		--- Talents so this is perhaps not know
		[Evanesce]				=	{ cd = 45, isKnown = getTalent(1,1) },
		[BlazingSpeed]			=	{ cd = 25, isKnown = getTalent(1,2) },
		[IceFloes]				=	{ cd = 0, isKnown = getTalent(1,3)	}, -- 3 Charges, so we set to 0 since it is a special case that need to be handled
		[AlterTime]				=	{ cd = 0, isKnown = getTalent(2,1) },
		[Flameglow]				=	{ cd = 0, isKnown = getTalent(2,2) },
		[IceBarrier]			=	{ cd = 0, isKnown = getTalent(2,3) },
		[RingOfFrost]			=	{ cd = 0, isKnown = getTalent(3,1) },
		[IceWard]				=	{ cd = 0, isKnown = getTalent(3,2) },
		[Frostjaw]				=	{ cd = 0, isKnown = getTalent(3,3) },
		[GreaterInvisibility]	=	{ cd = 0, isKnown = getTalent(4,1) },
		[Cauterize]				=	{ cd = 0, isKnown = getTalent(4,2) },
		[ColdSnap]				=	{ cd = 0, isKnown = getTalent(4,3) },
		[NetherTempest]			=	{ cd = 0, isKnown = getTalent(5,1) },
		[UnstableMagic]			=	{ cd = 0, isKnown = getTalent(5,2) },
		[Supernova]				=	{ cd = 0, isKnown = getTalent(5,3) },
		[MirrorImage]			=	{ cd = 0, isKnown = getTalent(6,1) },
		[RuneOfPower]			=	{ cd = 0, isKnown = getTalent(6,2) },
		[IncantersFlow]			=	{ cd = 0, isKnown = getTalent(6,3) },
		[Overpowered]			=	{ cd = 0, isKnown = getTalent(7,1) },
		[PrismaticCrystal]		=	{ cd = 90, isKnown = getTalent(7,2) },
		[ArcaneOrb] 			=	{ cd = 15, isKnown = getTalent(7,3) },
	}

	return MageSpells
end

function spellbook:getPlayerSpells()
	if select(3, UnitClass("player")) == 8 then -- Mage
		return spellbook:mageSpells()
	end
end

-- Todo : Should change this to spellbook:
-- if getCharges(115399) > 0 then
function getCharges(spellID)
	return select(1,GetSpellCharges(spellID))
end

-- Todo : Should change this to spellbook:
function getRecharge(spellID)
	local charges,maxCharges,chargeStart,chargeDuration = GetSpellCharges(spellID)
	if charges then
		if charges < maxCharges then
			chargeEnd = chargeStart + chargeDuration
			return chargeEnd - GetTime()
		end
	return 0
	end
end

-- if getSpellCD(12345) <= 0.4 then
function getSpellCD(SpellID)
	if GetSpellCooldown(SpellID) == 0 then
		return 0
	else
		local Start ,CD = GetSpellCooldown(SpellID)
		local MyCD = Start + CD - GetTime()
		if getOptionCheck("Latency Compensation") then
			MyCD = MyCD - getLatency()
		end
		return MyCD
	end
end