if select(3, UnitClass("player")) == 8 then

-- All
	MirrorImage 	= 55342;
	ArcaneBrilliance= 1459;

-- Frost
	CometStorm		= 153595;
	Frostbolt		= 116;
	FrostfireBolt	= 44614;
	FrozenOrb		= 84714;
	FrozenOrbDebuff = 84721;
	IceLance		= 30455;
	IceBlock		= 45438
	IcyVeins		= 12472
	IceBarrier		= 11426
-- Pet
	SummonPet		= 31687;
	WaterJet		= 135029;
-- FrTalents
	FrostBomb 		= 112948;
	IceNova			= 157997;
	ThermalVoid		= 155149;

-- Fire
	BlastWave		= 157981
	Combustion		= 11129
	Fireball		= 133
	Ignite			= 12654 --12846 (mastery: ignite)
	InfernoBlast	= 108853
	Pyroblast		= 11366
	Scorch          = 2948
	LivingBomb		= 44457
-- FiTalents

-- Arcane
	ArcaneBarrage	= 44425
	ArcaneBlast		= 30451
	ArcaneExplosion	= 1449
	ArcaneMissiles	= 5143
	ArcaneMissilesP	= 79683
	UnstableExplo	= 157976
	PresenceOfMind  = 12043
	Evocation		= 12051 --Standard
	EvocationImp	= 157614 -- improved versions
-- ArTalents
	Supernova 		= 175980;
	ArcaneOrb		= 153626;
	Overpowered		= 155147;
	NetherTempest	= 114923;
	Evanesce		= 157913;

-- Talents
	ColdSnap		= 11958;
	IceFloes		= 108839;
	PrismaticCrystal = 155152;


-- Shared


-- Utility
	T17_4P_Frost	= 165469;
	T17_4P_Arcane	= 166872;  -- Arcane Instability

-- Buffs
	-- frost
	BrainFreeze		= 57761;
	EnhancedFB		= 157646;
	FingersOfFrost	= 44544;
	IceShard		= 166869;

	-- fire
	EnhancedPyro	= 157644
	HeatingUp		= 48107
	PyroblastBuff	= 48108
	Pyromaniac		= 166868

	-- arcane
	ArcaneAffinity	= 166871;
	ArcaneCharge	= 36032;
	ArcanePower		= 12042;

	-- all
	Archmage		= 177176;
	Instability		= 177051;  -- trinket 113948
	MoltenMetal		= 177081;  -- trinket 113984
	RuneOfPower		= 116011;
	HowlingSoul		= 177046;  -- trinket 119194
	MarkOfTheT		= 159234;
	IncantersFlow 	= 1463


-- Debuffs


-- Trinkets


-- Glyphs
	GlyphConeOfCold	= 115705;

-- Racial
	Berserkering 	= 26297;	-- Troll Racial


	-- Todo : Here we should look into what the best value for clipping, 50 atm, why 50? Is it related to latency or custom lag tolerance?
	-- Further testing is needed.
	function getIncantersFlowsDirection()
		if not playerBuffIncantersFlowStacks then
			playerBuffIncantersFlowDirection = "Unknown"
			playerBuffIncantersFlowStacks = 0
			return playerBuffIncantersFlowDirection
		end
		if not lastIncantersFlowStacks then
			lastIncantersFlowStacks = playerBuffIncantersFlowStacks
			playerBuffIncantersFlowDirection = "Unknown"
		end
		if lastIncantersFlowStacks > playerBuffIncantersFlowStacks then
			playerBuffIncantersFlowDirection = "Up"
			return playerBuffIncantersFlowDirection
		end

		if lastIncantersFlowStacks < playerBuffIncantersFlowStacks then
			playerBuffIncantersFlowDirection = "Down"
			return playerBuffIncantersFlowDirection
		end

		if lastIncantersFlowStacks == playerBuffIncantersFlowStacks then
			return playerBuffIncantersFlowDirection
		end

	end

	function getNumberOfTargetsWithOutLivingBomb(table)
		local counter = 0
		for i=1,#table do
			local thisUnit = table[i]
			-- increase counter for each occurences
			if not (UnitDebuffID(thisUnit,LivingBomb,"player")) then
				counter = counter + 1
			end
		end
  		return counter
	end

	function getNumberOfTargetsWithOutCombustion(table)
		local counter = 0
		for i=1,#table do
			local thisUnit = table[i]
			-- increase counter for each occurences
			if not (UnitDebuffID(thisUnit,Combustion,"player")) then
				counter = counter + 1
			end
		end
  		return counter
	end

	function isItOkToClipp()
		local  name, _, _, _, _, endTime = UnitChannelInfo("player")
		if name then
			if (endTime - (GetTime()*1000)) > 50 then
				return false
			end
			return true		
		end
		local name, _, _, _, _, endTime = UnitCastingInfo("player")
		if name then
			if (endTime - (GetTime()*1000)) > 50 then
				return false
			end
			return true
		end
		return true
	end

	function cancelEvocation() 
		local  name, _, _, _, _, endTime = UnitChannelInfo("player")
		if name and name == "Evocation" then
			if player.mana > 92 then
				return true
			end
		end
		return false
	end

	function castArcaneBlast(target)
		if castSpell(target,ArcaneBlast,false,true) then
			return true
		end
	end

	function castArcaneOrb(target, maxArcaneCharges)
		if target and (arcaneCharge <= maxArcaneCharges) then
			if castSpell(target,ArcaneOrb,false,true) then
				return true
			end
		end
	end

	function castArcaneBarrage(target, maxArcaneCharges)
		if target and arcaneCharge >= maxArcaneCharges then
			if castSpell("target",ArcaneBarrage,false,false) then
				return true
			end
		end
	end

	function castIceFloes()
		if not IceFloesTimer or IceFloesTimer < GetTime() - 2 then
			if castSpell("player",IceFloes,true,false) then
				IceFloesTimer = GetTime()
				return true
			end 
		end
	end
	function castScorch(target)
		if castSpell(target, Scorch,false,false) then
			return true
		end 
	end

	function castFireball(target)
		if castSpell(target, Fireball,false,true) then
			return true
		end 
	end
	function castInfernoBlast(target)
		if castSpell(target, InfernoBlast,false,false) then
			return true
		end 
	end
	function castLivingBomb(target)
		if castSpell(target, LivingBomb, true, false) then
			return true
		end
	end

	function castPyroBlast(target)
		if castSpell(target, PyroBlast, false, false, true, true) then
			return true
		end
	end
end
