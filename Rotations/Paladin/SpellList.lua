if select(3,UnitClass("player")) == 2 then






	-- Debuffs we want to cleanse
	shouldCleanseDebuff = {
		{ debuff = 0 }
	}








	if not initDone then
		_ArcaneTorrent				= 	155145
		_ArdentDefender             =   31850
		_AvengersShield             =   31935
		_AvengingWrath              =   31884
		_BastionOfGlory				=	114637
		_BeaconOfLight              =   53563
		_BeaconOfFaith				= 	156910
		_Berserking                 =   26297
		_BlazingContemp 			= 	166831
		_BlessingOfKings            =   20217
		_BlessingOfMight            =   19740
		_BlindingLight              =   115750
		_BloodFury                  =   20572
		_Cleanse                    =   4987
		_Consecration               =   26573
		_CrusaderStrike             =   35395
		_Denounce                   =   2812
		_DevotionAura               =   31821
		_DivineCrusader 			= 	144595
		_DivineFavor                =   31842
		_DivineLight                =   82326
		_DivineProtection           =   498
		_DivinePurpose 				= 	86172
		_DivinePurposeBuff			= 	90174
		_DivineShield               =   642
		_DivineStorm                =   53385
		_Daybreak					= 	88819
		_EternalFlame               =   114163
		_ExecutionSentence          =   114157
		_Exorcism                   =   879
		_FinalVerdict 				= 	157048
		_FistOfJustice              =   105593
		_FlashOfLight               =   19750
		_Forbearance				= 	25771
		_HandOfFreedom              =   1044
		_HandOfProtection           =   1022
		_HandOfPurity               =   114039
		_HandOfSacrifice            =   6940
		_HandOfSalvation            =   1038
		_HammerOfJustice            =   853
		_HammerOfTheRighteous       =   53595
		_HammerOfWrath              =   24275
		_HolyAvenger                =   105809
		_HolyLight                  =   82326
		_HolyPrism                  =   114165
		_HolyRadiance               =   82327
		_HolyShock                  =   20473
		_HolyWrath                  =   119072
		_GiftOfTheNaaru             =   59542
		_GuardianOfAncientKings     =   86659
		_GuardianOfAncientKingsHoly =   86669
		_GuardianOfAncientKingsRet  =   86698
		_InfusionOfLight			=	54149
		_Inquisition                =   84963
		_Judgment      	            =   20271
		_LayOnHands                 =   633
		_LightOfDawn                =   85222
		_LightsHammer               =   114158
		_MassExorcism               =   122032
		_MassResurection            =   83968
		_Rebuke                     =   96231
		_Reckoning                  =   62124
		_Redemption                 =   7328
		_RighteousFury              =   25780
		_Repentance                 =   20066
		_SanctifiedWrath            =   53376
		_SacredShield               =   20925
		_SealOfInsight              =   20165
		_SealOfRighteousness        =   20154
		_SealOfThruth               =   31801
		_SelflessHealer             =   85804
		_SelflessHealerBuff			= 	114250
		_Seraphim					=	152262
		_ShieldOfTheRighteous       =   53600
		_SpeedOfLight               =   85499
		_TemplarsVerdict            =   85256
		_TurnEvil                   =   10326
		_WordOfGlory                =   85673

		HandOfSacrifaceDebuffs = { -- Table that holds debuffs we should HoSacrifice
			{ debuff = 166675, stacks = 2 }, -- Shrapnel Blast  in Grimrail depot
		}
		protectionRemovableDebuffs = {} -- Table that holds debuffs that we should remove with protection spell
		snareToBeRemovedByHandsofFreedom = {
			162066,  -- Freezing Snare, Grim Depot
		}
		initDone = true
	end

	-- Todo : Check Glyphs(is on us or can we cast it on ground 25 yards
	function castArcaneTorrent()
		if canCast(_ArcaneTorrent) then
			if castSpell("player",_ArcaneTorrent,true) then
				return true
			end
		end
		return false
	end

	-- Avenging Wrath
	function castAvengingWrath(dynamicUnit)
		if isSelected("Avenging Wrath") and canCast(_AvengingWrath) then
			if (isDummy(dynamicUnit.dyn5) or (UnitHealth(dynamicUnit.dyn5) >= 400*UnitHealthMax("player")/100)) then
				-- avenging_wrath,sync=seraphim,if=talent.seraphim.enabled
				if (isKnown(_Seraphim) and UnitBuffID("player",_Seraphim) )
				  -- avenging_wrath,if=!talent.seraphim.enabled
				  or not isKnown(_Seraphim) then
					if castSpell("player",_AvengingWrath,true,false) then
						return true
					end
				end
			end
		end
		return false
	end

	function castStrike()
		local strike = strike
		if BadBoy_data["AoE"] == 2 or (BadBoy_data["AoE"] == 3 and numberOfTargetsForHammerOfRighteous > 2) or keyPressAoE then  --If Toggle to 2(AoE) or 3(Auto and more then 2 targets, its actually 4 but its just simplier to do aoe
			strike = _HammerOfTheRighteous
		else
			strike = _CrusaderStrike
		end
		-- Cast Crusader for Single and Hammer of Right if aoe
		if castSpell(dynamicUnit.dyn5,strike,false,false) then
			return
		end
	end


	-- DivineProtection(Ret)
	function castDivineProtection()
		if isChecked("Divine Protection") and getHP("player") <= getValue("Divine Protection") then
			if castSpell("player",_DivineProtection,true) then
				return
			end
		end
	end

	-- Divine shield
	function castDivineShield(playerHealth)
		if playerHealth < getValue("Divine Shield") then
			if castSpell("player",_DivineShield,true,false) then
				return true
			end
		end
	end

	-- Todo : Execution sentence make sure we cast on a unit with as much HP as possible
	function castExecutionSentence(unit)
		if isSelected("Execution Sentence") then
			if (isDummy(dynamicUnit.dyn40) or (UnitHealth(dynamicUnit.dyn40) >= 400*UnitHealthMax("player")/100)) then
				if castSpell(dynamicUnit.dyn40,_ExecutionSentence,false,false) then
					return true
				end
			end
		end
		return false
	end

	function castHammerOfJustice(unit)
		-- We check if we have the talent
		return false
	end

	function castHammerOfWrath(thisUnit,hpHammerOfWrath,buffAvengingWrath)
		if canCast(_HammerOfWrath) and getLineOfSight("player",thisUnit.unit) and thisUnit.distance <= 30
		  and thisUnit.hp <= 20 then
			if castSpell(thisUnit.unit,_HammerOfWrath,false,false) then
				return true
			end
		end
	end
	function castHammerOfWrathMulti()
		local hpHammerOfWrath = 20
		local buffAvengingWrath = getBuffRemain("player",_AvengingWrath)
		-- if empowered hammer of wrath, we need to get value for HoW hp at 35%
		if isKnown(157496) then
			hpHammerOfWrath = 35
		end
		for i = 1, #enemiesTable do
			-- define thisUnit
			local thisUnit = enemiesTable[i]
			if castHammerOfWrath(thisUnit,hpHammerOfWrath,buffAvengingWrath,false) then
				return true
			end
		end
		return false
	end

	function castHandOfFreedom(unit)
		if canCast(_HandOfFreedom) then
			if castSpell(unit,_HandOfFreedom,true) then
				return true
			end
		end
		return false
	end


	function castHandOfSalvation(unit)
		-- This is not coded properly yet, we need a threat list to see how has threat, then we need to make sure to handle tank switching etc.
		return false
	end

	-- Holy Avenger(Ret)
	function castHolyAvenger(holypower,dynamicUnit)
		if isSelected("Holy Avenger") then
			if (isDummy(dynamicUnit.dyn5) or (UnitHealth(dynamicUnit.dyn5) >= 400*UnitHealthMax("player")/100)) then
				-- holy_avenger,sync=seraphim,if=talent.seraphim.enabled
				if (isKnown(_Seraphim) and UnitBuffID("player",_Seraphim))
				  -- holy_avenger,if=holy_power<=2&!talent.seraphim.enabled
				  or (not isKnown(_Seraphim) and holypower <= 2) then
					if castSpell("player",_HolyAvenger,true,false) then
						return true
					end
				end
			end
		end
		return false
	end

	function castHolyPrism(unit)
		if unit then
			if castSpell(unit, _HolyPrism, true, false) then
				return true
			end
		end
		-- Cast on enemies first
		if getValue("Holy Prism Mode") == 2 or 3 then
			if castWiseAoEHeal(enemiesTable,_HolyPrism,15,95,1,5,false) then
				return true
			end
		else
			for i = 1, #nNova do
				if nNova[i].hp <= getValue("Holy Prism") then
					if castSpell(nNova[i].unit,_HolyPrism,true, false) then
						return true
					end
				end
			end
		end
		return false
	end

	function castJeopardy()
		for i = 1, #enemiesTable do
			thisEnemy = enemiesTable[i]
			if getDistance("player",thisEnemy.unit) then
				-- here i will need to compare my previous judgment target with the previous one
				-- i will declare a var in the Reader that will hold this value previousJudgmentTarget
				if previousJudgmentTarget ~= thisEnemy.guid then
					if castSpell(thisEnemy.unit,_Judgment,true,false) then
						return true
					end
				end
			end
		end
		return false
	end


	function castJudgement(unit)
		if unit == nil then
			unit = dynamicUnit.dyn30AoE
		end
		if canCast(_Judgment) and getDistance("player", unit) <= 30 then
			if castSpell(unit,_Judgment,true,false) then
				return true
			end
		end
		return false
	end

	--Todo:Add who to loh logic
	function castLayOnHands(unit)
		return castSpell(unit,633,true,false) == true or false
	end
	-- done this works with profiles
	function enhancedLayOnHands()
		if isChecked("Lay On Hands") then
			-- Lay on Hands Targets 1- me only 2- me prio 3- tank and heal 4- all
			local LoHTargets = getValue("LoH Targets")
			local LoHValue = getValue("Lay On Hands")
			if LoHTargets == 1 then
				if core.health <= LoHValue then
					if castLayOnHands("player") then
						return true
					end
				end
			elseif LoHTargets == 2 then
				if core.health <= LoHValue then
					if castLayOnHands("player") then
						return true
					end
				else
					for i = 1, #nNova do
						if nNova[i].hp <= LoHValue then
							if castLayOnHands(nNova[i].unit) then
								return true
							end
						end
					end
				end
			elseif LoHTargets == 3 then
				if core.health <= LoHValue then
					if castLayOnHands("player") then
						return true
					end
				else
					for i = 1, #nNova do
						if nNova[i].hp <= LoHValue and (nNova[i].role == "HEALER" or nNova[i].role == "TANK") then
							if castLayOnHands(nNova[i].unit) then
								return true
							end
						end
					end
				end
			elseif LoHTargets == 4 then
				for i = 1, #nNova do
					if nNova[i].hp <= LoHValue then
						if castLayOnHands(nNova[i].unit) then
							return true
						end
					end
				end
			end
		end
		return false
	end

	function castLightsHammer(unit)
		if isSelected("Light's Hammer") then
			if getGround(unit) and not isMoving(unit) and UnitExists(unit) and ((isDummy(unit) or getDistance(unit,"targettarget") <= 5)) then
				if castGround(unit,_LightsHammer,30) then
					return true
				end
			end
		end
		return false
	end


	function castRebuke(unit)
		return castInterrupt(_Rebuke, getValue("Rebuke"))
	end



	--ToDo :Sacred Shield is affected but Resolve. So we should snapshot resolve and if we are getting X procent more then we should reapply. 340% is max of resolve buff
	function castSacredShield(timeleft) -- Parameter is time left on buff
		local timeleft = timeleft or 0
		if not isBuffed("player", _SacredShield, timeleft) then
			if castSpell("player",_SacredShield,false,false) then
				return true
			end
		end
		return false
	end
	--function SacredShield()
    --       local SacredShieldCheck = BadBoy_data["Check Sacred Shield"];
    --  -      local SacredShield = BadBoy_data["Box Sacred Shield"];
    --        if UnitBuffID("player",20925) then SacredShieldTimer = select(7, UnitBuffID("player",20925)) - GetTime() else SacredShieldTimer = 0 end
    --       if SacredShieldCheck and getHP("player") <= SacredShield then
    --            if ((isMoving("player") or UnitAffectingCombat("player")) and not UnitBuffID("player",20925)) or (LastVengeance ~= nil and (GetVengeance() > (BadBoy_data["Box Sacred Vengeance"] + LastVengeance))) then
    --                LastVengeance = GetVengeance()
    --               return true;
    --            end
    --            if SacredShieldTimer <= 3 then
    --                return true;
    --            end
    --        end
    --        return false;
    --    end

	-- Todo we are only checking lowest healthm we need to switch to threat
	-- Todo Add buff cehck if target already have the buff
	-- Todo Is the talent handle correctly? 2 charges? CD starts but u have 2 charges


	function castSealOfTruth()
		--CastShapeshiftForm(1)
		if castSpell("player",_SealOfThruth,true,false) then
			return true
		end
	end

	function castSealOfRigtheousness()
		--CastShapeshiftForm(2)
		if castSpell("player",_SealOfRighteousness,true,false) then
			return true
		end
	end


	-- Seraphim
	-- I removed _HolyPower, we have it global instead.
	function castSeraphim()
		if isSelected("Seraphim") and canCast(_Seraphim) then
			if (isDummy(dynamicUnit.dyn5) or (UnitHealth(dynamicUnit.dyn5) >= 400*UnitHealthMax("player")/100)) then
				if castSpell("player",_Seraphim,true,false) then
					return true
				end
			end
		end
		return false
	end


	-- Todo: We should calculate expected heal with resolve to not overheal
	function castWordOfGlory(unit, health, HolyPower)
		if health == 0 then --Set it to 0 if we should use config set value
			health = getValue("Word Of Glory On Self")
		end
 		-- Gabbz: Handle this via config? getHP does it include incoming heals? Bastion of Glory checks?
 		-- CML: I have it in ret as  getValue("Self Glory"), you should use same name as anyway the config values are saved into specs
 		-- the getHP method will use selected healing engines values as it will first try to find the unit in nnova
		if getHP(unit) <= health and (_HolyPower > HolyPower or UnitBuffID("player", _DivinePurposeBuff)) then
			if castSpell(unit,_WordOfGlory,true,false) then
				return true
			end
		end
		return false
	end

	function checkForDebuffThatIShouldRemovewithHoF(unit)
		for i = 1, #snareToBeRemovedByHandsofFreedom do
			if UnitDebuffID(unit, snareToBeRemovedByHandsofFreedom[i]) then
				return true
			end
		end
		return false
	end

end