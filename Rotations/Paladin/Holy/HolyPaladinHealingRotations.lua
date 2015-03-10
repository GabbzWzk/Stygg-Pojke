-- Todos:
--          Vi måste använda DP buffen, så kolla om vi snart ska få slut på den och kasta Eternal Flame eller Light of Dawn
--          Kolla om vi ska heala någon som har Beacon så kan vi kasta FoL om vi har en hög mana även om de inte är i låg kritisk health
--          Kolla om vi är mana säkra så kan vi lägga in fler FoL och även Holy Raidance.
--          Kasta FoL och Raidance om key press, dvs kasta mycket HPS
--          Sätt config check for radiance, och mana values.
--          How to heal during Avenging Wrath
--
function HolyPaladinRaidHealing()  

  ----------------------------
  -- Get General Healing Targets, lowestHP, LowestTank, highestTankHP, highestTankUnit, AverageHealth, 
  ---------------------------
  lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, highestTankHP, highestTankUnit, averageHealth = getLowestSingleTargetHealingCandidates()
  aoeCandidateTenYards, numberOfUnitsInRangeTenYards = getAoeHealingCandidateNova(2, 90, 10) -- Minimum 2 Targets within 10 yards from friend
  lightOfDawnTargets = getAoeHealingCandidateLightOfDawn(2, 90, 30) -- Minimum 2 Targets within 30 yards from player   
  playerHP = 100*UnitHealth("player")/UnitHealthMax("player")  

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

  ---------------------------------------
  -- Lay on Hands logic here
  ---------------------------------------
  if isChecked("Lay On Hands") then
    -- Lay on Hands Targets 1- me only 2- me prio 3- tank and heal 4- all
    local LoHTargets = getValue("LoH Targets")
    local LoHValue = getValue("Lay On Hands")
    if LoHTargets == 1 then -- Only on player
      if playerHP <= LoHValue then
        if castLayOnHands("player") then
          return true
        end
      end
    elseif LoHTargets == 2 then -- Me Prio
      if playerHP <= LoHValue then
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
    elseif LoHTargets == 3 then -- Me, Tanks or Healers
      if playerHP <= LoHValue then
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
    elseif LoHTargets == 4 then -- All
      for i = 1, #nNova do
        if nNova[i].hp <= LoHValue then
          if castLayOnHands(nNova[i].unit) then
            return true
          end
        end
      end
    end
  end
  
  ----------------------------
  -- Healing CDs logic here
  -----------------------------
  -- We should look at how many injured and how much and then blow them if necessary
  -- Should have config values for on CD(Trivial Content), number of injuries and HP, or manually

  -----------------------
  -- Critical heals, here is where we need to focus on a target since he is low, blowing high mana heals if necessary.
  --      We need to have different levels here
  -----------------------------

  ------------------------
  -- We should single heal any target under a specific health.
  ------------------------
  if healingtargethp < getValue("Critical Health Level") and not (averageHealth < getValue("Critical Health Level"))  then
	-- Add Holy Prism
  -- Add Eternal flame
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
   ------------------------------
  -- Holy Prism
  --    Two modes, either on enemies to AoE heal only or Wise where we check on CD if there are multiple heals on enemies or if lowest unit is beneath value
  --    If AoE check number of targets around enemies and cast on best match
  ------------------------------
  if isChecked("Holy Prism Mode") and canCast(_HolyPrism) then
    -- Cast on enemies first
    if getValue("Holy Prism Mode") == 1 or getValue("Holy Prism Mode") == 3 then -- AoE heal around best enemy
      if castWiseAoEHeal(enemiesTable,_HolyPrism,15,95,2,5,false) then
        print("Prism on Enemy")
        return true
      end
    end
  end

	if UnitBuffID("player",_Daybreak) and canCast(_HolyShock) then --Daybreak procc turns holy shock into AoE
		if aoeCandidateTenYards and numberOfUnitsInRangeTenYards > 1 and _HolyPower < 5 then
			if castHolyShock(aoeCandidateTenYards) then
				return true
			end
		end
	end
	if getValue("Healing Mode") == 3 then -- Burst Healing so use Radiance
  	if aoeCandidateTenYards and numberOfUnitsInRangeTenYards > 5 and _HolyPower < 5 then
      if castHolyRadiance(aoeCandidateTenYards) then
  	    return true
      end
    end
  end

	if (lightOfDawnTargets > 5 and _HolyPower > 2) then
    if castLightOfDawn() then
		  return true
    end
  end
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

    if _HolyPower == 5 or UnitBuffID("player", _DivinePurposeBuff) then
      if playerHP < getValue("Eternal Flame") and not UnitBuffID("player", _EternalFlame) then
        if castEternalFlame("player") then
          return true
        end
      end
      if lowestTankHP < getValue("Eternal Flame") then -- Should be timeremaining < 3 seconds
        if castEternalFlame(lowestTankUnit) then
          return true
        end
      end
    end
  end

  ---------------------
  -- Holy Prism Single target
  ---------------------
  if getValue("Holy Prism Mode") == 2 or getValue("Holy Prism Mode") == 3 then -- Single target heal or wise target and no AoE candidates
    if healingtargethp < 90 then
      if castHolyPrism(healingtarget)  then
        print("Prism on Friend")
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