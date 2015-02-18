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
  if lowestTankHP < (lowestHP + 5) then
    healingtarget = lowestTankUnit
    healingtargethp = lowestTankHP
  else
    healingtarget = lowestUnit
    healingtargethp = lowestHP
  end
  
  if healingtargethp < getValue("Critical Health Level") and not (averageHealth < getValue("Critical Health Level"))  then
    print("Criticals Heals")
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
        
    if castFlashOfLight(healingtarget) then
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

  -- AoE healing
  if castAoEHeals() then
    return true
  end

  -------------------
  -- Cast Holyshock on if we have less then 5 HoPo
  -------------------
  if HolyPower < 5 then
    if castHolyShock(healingtarget)  then
      return true
    end
  end
  ---------------------------------
  --  Eternal Flame should be cast on tank taking damage, 
  --      If we have 3 HoPo then check if Healing target needs the healing, if not then lowest Tank has less then value and not the HoT, if not then check other tank same thing.
  --      if We have 5 HoPo then cast it on tanks.
  --      We should also check if we have the Divine Purpose buff and if so cast Eternal Flame regardless HoPo
  ---------------------------------
  if _HolyPower > 2 and healingtargethp < getValue("Eternal Flame") then
      if castEternalFlame(lowestTankHP) then
        return true
      end
  end

  ------------------------------
  -- Holy Prism, first is on AoE but we should cast it if we can
  ------------------------------
  if getOptionCheck("Holy Prism") and castHolyPrism(healingtarget) then
    return true
  end
  
  ------------------------------
  -- Holy Light as filler if any one is hurt or we have full mana
  ------------------------------
  if getValue("Holy Light") then -- We should add casting if we have full mana so we create mastery shields 
    if castHolyLight(healingtarget) then
      return true
    end
  end
      -- Crusader strik for HoPo
end

function HolyPaladinTankHealing()
end

function HolyPaladinFreeForAllHealing()
end