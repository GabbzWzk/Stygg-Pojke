function HolyPaladinRaidHealing()  

  ----------------------------
  -- Get General Healing Targets, lowestHP, LowestTank, highestTankHP, highestTankUnit, AverageHealth, 
  ---------------------------
  lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, highestTankHP, highestTankUnit, averageHealth = getLowestSingleTargetHealingCandidates()
  aoeCandidateTenYards, numberOfUnitsInRangeTenYards = getAoeHealingCandidateNova(2, 90, 10) -- Minimum 2 Targets within 10 yards from friend
  lightOfDawnTargets = getAoeHealingCandidateLightOfDawn(2, 90, 30) -- Minimum 2 Targets within 30 yards from player     

  -------------------------
  -- Fast Heals First if someone is close to dying, however we should not perhaps cast this if the whole raid is getting pounded
  --          Todo: We should have a lower critical if we are getting aoed, something focus heal if lowest is 10/20 health under average and under critical health level
  ---------------------------------------------------
  -- Cast Land On Hands, using configurable values
  -- Todo Fix this, using core. and its not done in holy
  ----------------------
  --if enhancedLayOnHands() then
  --  return true
  --end

  --We are raid healing with beacon on tanks, so if they lowestunit and lowesttank have smaller changes then we should cast on lowestunit since we heal tank as well
  ----------------------
  -- Healing Target Logic
  --	We have beacon on tanks so unless they are critical health we should heal raid instead of tanks, 50% if our heals are healing each Beacon
  --	We should have Tanks set to target and for
  --	We need to have some beacon checks and decide who to heal
  -----------------------
  if lowestTankHP < (lowestHP + 5) then
    healingtarget = lowestTankUnit
    healingtargethp = lowestTankHP
  else
    healingtarget = lowestUnit
    healingtargethp = lowestHP
  end
  
  ------------------------
  -- We should single heal any target under a specific health.
  ------------------------
  if healingtargethp < getValue("Critical Health Level") and not (averageHealth < getValue("Critical Health Level"))  then
    print("Criticals Heals")
	-- Add Holy Prism
    if UnitBuffID("player",_InfusionOfLight) then
      if castHolyLight(healingtarget) then
        return true
      end
    end
    if canCast(_HolyShock) then
      if castHolyShock(healingtarget) then
        return true
      end
    end 
    if castFlashOfLight(healingtarget) then --This our highest HPS, So we should switch beacon for mana reasons and under se certain level we should FoL only.
      return true
    end
  end
  ------------------------------
  -- End of Critical heals
  ------------------------------
  
  ------------------------------
  -- First we should see if there is any AoE healing, assuming we have beacon it should be decent tank healing
  ------------------------------
  --if castHolyPrism(healingtarget) then
  --  return true
  --end

	if UnitBuffID("player",_Daybreak) and canCast(_HolyShock) then --Daybreak procc turns holy shock into AoE
		if aoeCandidateTenYards and numberOfUnitsInRangeTenYards > 1 and _HolyPower < 5 then
			if castHolyShock(aoeCandidateTenYards) then
				return true
			end
		end
	end
	
	if aoeCandidateTenYards and numberOfUnitsInRangeTenYards > 4 and _HolyPower < 5 then
        if castHolyRadiance(aoeCandidateTenYards) then
			return true
        end
    end

	if lightOfDawnTargets > 6 and _HolyPower > 2 then
        if castLightOfDawn() then
			return true
        end
    end
  ------------------------------
  -- Holy Prism
  --		How should we do this? Manual for now
  --		If no aoe heals then on Tanks
  --		If AoE check number of targets around enemies and cast on best match
  ------------------------------
 -- if getOptionCheck("Holy Prism") and castHolyPrism(healingtarget) then
 --   return true
 -- end
  ---------------------------------
  --  Eternal Flame on Tanks of no HoT present and we dont overheal 
  ----------------------------------
  if _HolyPower > 2 or UnitBuffID("player", _DivinePurposeBuff) then
	if lowestTankHP < getValue("Eternal Flame") and not UnitBuffID(lowestTankUnit, _EternalFlame) then -- Should be timeremaining < 3 seconds
      if castEternalFlame(lowestTankUnit) then
        return true
      end
	elseif lowestHP < getValue("Eternal Flame") and not UnitBuffID(lowestUnit, _EternalFlame) then
	  if castEternalFlame(lowestUnit) then
        return true
      end
	elseif highestTankHP < getValue("Eternal Flame") and not UnitBuffID(highestTankUnit, _EternalFlame) then
	  if castEternalFlame(highestTankUnit) then
        return true
      end
	end
  end
  -------------------
  -- Cast Holyshock on if we have less then 5 HoPo
  -------------------
  if _HolyPower < 5 then	--Need to add CD on HolyShock and 
    if castHolyShock(healingtarget)  then
      return true
    end
  end
  ------------------------------
  -- Holy Light as filler if any one is hurt or we have full mana
  ------------------------------
  if getValue("Holy Light") > healingtargethp or player.mana > 99 then -- We should add casting if we have full mana so we create mastery shields 
    if castHolyLight(healingtarget) then
      return true
    end
  end
  -- Crusader strike for HoPo with low HP or no valid targets to heal
end

function HolyPaladinTankHealing()
end

function HolyPaladinFreeForAllHealing()
end