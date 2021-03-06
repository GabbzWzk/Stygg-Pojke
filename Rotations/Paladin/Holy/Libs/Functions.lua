if select(3,UnitClass("player")) == 2 then
  function PaladinHolyFunctions()
    
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


    -- Eternal Flame
    -- ToDo: we need a better handling over eternal flame
    

    function castEternalFlame(unit)
      if (eternalFlameTimer == nil or eternalFlameTimer <= GetTime() - 1.3) then
        eternalFlameTimer = GetTime()
      else
        return false
      end
      if castSpell(unit,_EternalFlame,true,false) then
        return true
      end
	  return false
    end

    -- Word Of Glory
    function WordOfGlory(hpValue)
      if _HolyPower > 3 then
        for i = 1, #nNova do
          if nNova[i].hp < hpValue or (nNova[i].hp < 100 and _HolyPower == 5) then
            if castSpell(nNova[i].unit, _WordOfGlory, true, false) then return end
          end
        end
      end
    end

    function HolyPrism(hpValue)
      if getValue("Holy Prism Mode") == 1 then -- Cast on friend with enemies around him, we default uses the tank for now, but should use enemiesengine i guess
        if lowestTankHP < hpValue then
          if castSpell(lowestTankUnit, _HolyPrism, true, false) then
            return true
          end
      end
      end
      if getValue("Holy Prism Mode") == 2 then -- Cast on tanks target
      --Should check friendly targets around the tanks target
      --if castSpell(lowestTankUnit, _HolyPrism, true, false) then
      --	return true
      --end
      end
      if getValue("Holy Prism Mode") == 3 then --Wise
        --Todo, here we should check how many enemies around lowest HP units and if x then go for it
        --or check if many people need healing and there is a mob close to them
        for i = 1, #nNova do
          if nNova[i].hp < hpValue then
            if castSpell(nNova[i].unit, _HolyPrism, true, false) then return end
          end
        end
      end
    end

    -- Beacon Of Light
    function BeaconOfLight()
      local beaconTarget, beaconRole, beaconHP = "player", "HEALER", 100*UnitHealth("player")/UnitHealthMax("player")
      --3 different modes, tank, focus and wise
      -- Find if we have any, note if its a tank.
      for i = 1, #nNova do
        if UnitBuffID(nNova[i].unit,_BeaconOfLight,"player") then
          beaconLightTarget, beaconLightRole, beaconLightHP = nNova[i].unit, nNova[i].role, nNova[i].hp
        end
        if UnitBuffID(nNova[i].unit,_BeaconOfFaith,"player") then
          beaconFaithTarget, beaconFaithRole, beaconFaithHP = nNova[i].unit, nNova[i].role, nNova[i].hp
        end
      end
      -- if we are not beacon on a tank and on tanks is checked we find a proper tank if focus dont exists.
      if getValue("Beacon Of Light") == 1 then
        if beaconLightRole ~= "TANK" then
          for i = 1, #nNova do
            if nNova[i].role == "TANK" and not UnitBuffID("focus",_BeaconOfLight,"player") and not UnitBuffID("focus",_BeaconOfFaith,"player") then
              if castSpell(nNova[i].unit,_BeaconOfLight,true,false) then
                return true
              end
            end
          end
        end
      end

      if getValue("Beacon Of Light") == 2 then
        if UnitExists("focus") == true and UnitIsVisible("focus") and not UnitBuffID("focus",_BeaconOfLight,"player") and not UnitBuffID("focus",_BeaconOfFaith,"player") then
          if castSpell("focus",_BeaconOfLight,true,false) then
            return true
          end
        end
      end
      --Todo: Implement Wise Beacon

      if getValue("Beacon Of Light") == 3 then
        print("Wise handing of beacins Not Supported")
        return false
      end

      if isKnown(_BeaconOfFaith) then
        -- if we are not beacon on a tank and on tanks is checked we find a proper tank if focus dont exists.
        if getValue("Beacon Of Faith") == 1 then
          if beaconFaithRole ~= "TANK" and not UnitBuffID("focus",_BeaconOfLight,"player") and not UnitBuffID("focus",_BeaconOfFaith,"player") then
            for i = 1, #nNova do
              if nNova[i].role == "TANK" then
                if castSpell(nNova[i].unit,_BeaconOfFaith,true,false) then
                  return true
                end
              end
            end
          end
        end

        if getValue("Beacon Of Faith") == 2 then
          if UnitExists("focus") == true  and UnitIsVisible("focus") and not UnitBuffID("focus",_BeaconOfFaith,"player") and not UnitBuffID("focus",_BeaconOfLight,"player") then
            if castSpell("focus",_BeaconOfFaith,true,false) then
              return true
            end
          end
        end
        --Todo impolement Wise mode
        if getValue("Beacon Of Light") == 3 then
          print("Wise handing of beacins Not Supported")
          return false
        end
      end
    end

    function castDispell()
      if getOptionCheck("Dispell") and canCast(_Cleanse,false,false) and not (getBossID("boss1") == 71734 and not UnitBuffID("player",144359)) then
        if getValue("Dispell") == 2 then -- Mouse Match
          if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
            for i = 1, #nNova do
              if nNova[i].guid == UnitGUID("mouseover") and nNova[i].dispel == true then
                if castSpell(nNova[i].unit,_Cleanse, true,false) then
                  return true
                end
              end
            end
        end
        elseif getValue("Dispell") == 1 then -- Raid Match
          for i = 1, #nNova do
            if nNova[i].hp < 249 and nNova[i].dispel == true then
              if castSpell(nNova[i].unit,_Cleanse, true,false) then
                return true
              end
            end
        end
        elseif getValue("Dispell") == 3 then -- Mouse All
          if UnitExists("mouseover") and UnitCanAssist("player", "mouseover") then
            for n = 1,40 do
              local buff,_,_,count,bufftype,duration = UnitDebuff("mouseover", n)
              if buff then
                if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then
                  if castSpell("mouseover",_Cleanse, true,false) then
                    return true
                  end
                end
              else
                break
              end
            end
        end
        elseif getValue("Dispell") == 4 then -- Raid All
          for i = 1, #nNova do
            if nNova[i].hp < 249 then
              for n = 1,40 do
                local buff,_,_,count,bufftype,duration = UnitDebuff(nNova[i].unit, n)
                if buff then
                  if bufftype == "Magic" or bufftype == "Curse" or bufftype == "Poison" then
                    if castSpell(nNova[i].unit,_Cleanse, true,false) then
                      return true
                    end
                  end
                else
                  break
                end
              end
            end
        end
        end
      end

      return false
    end

    function castAoEHeals()
      -- Aoe Heals
      --	Holy Radiance  40 yards, generates 1 HoPo friendly target and 6 allies within 10 yards
      --  Light Of Dawn, cost 1 HoPo heals 6 allies within 30 yards.
      --  Holy Shock if Daybreak buff, 10 yeards of target 15% healing done for 5 allies.
      --  Lights Hammer, 30 yards, heals 6 allies within 10 yards radius.
      --  Executive Sentence?
      -- Todo !!

      print("AoE!")

      local aoeCandidateTenYards, numberOfUnitsInRangeTenYards = getAoeHealingCandidateNova(2, 90, 10) -- Minimum 2 Targets within 10 yards from friend
      local lightOfDawnTargets = getAoeHealingCandidateLightOfDawn(2, 90, 30) -- Minimum 2 Targets within 30 yards from player

      if UnitBuffID("player",_Daybreak) and canCast(_HolyShock) then --Daybreak procc turns holy shock into AoE
        if aoeCandidateTenYards and numberOfUnitsInRangeTenYards > 1 and _HolyPower < 5 then
          if castHolyShock(aoeCandidateTenYards) then
            return true
          end
        end
      end

      if lightOfDawnTargets > 3 and _HolyPower > 2 then
        if castLightOfDawn() then
          return true
        end
      end

      -- Light of Dawn here
      --[Light of Dawn] 3 HoPo heals 6 allies 30 yards from player
      --if getUnitsToHealAround("player",30, 90, maxCount)

      if aoeCandidateTenYards and numberOfUnitsInRangeTenYards > 4 and _HolyPower < 5 then
        if castHolyRadiance(aoeCandidateTenYards) then
          return true
        end
      end
      return false
    end

    function getAoeHealingCandidateNova(minimalNumberofUnits, missingHP, rangeValue)
      local bestAoECandidate = nNova[1].unit
      local bestAoeNumberOfUnits = 0
      local count = 0
      for i = 1, #nNova do
        if nNova[i].hp < 249 then
          local alliesinRange = getAllies(nNova[i].unit,rangeValue)
          count = 0
          if #alliesinRange >= minimalNumberofUnits then
            for j = 1, #alliesinRange do
              local thisunit = alliesinRange[j]
              if 100*UnitHealth(thisunit)/UnitHealthMax(thisunit) < missingHP then
                count = count + 1
              end
            end
          end
          if count > 	bestAoeNumberOfUnits then
            bestAoECandidate = nNova[i].unit
            bestAoeNumberOfUnits = count
          end
          -- Todo: Here we have not met the criteria, but we should be able to provide with the best candidate even if we dont meet the criteria
        end
      end
      if bestAoeNumberOfUnits >= minimalNumberofUnits then
        return bestAoECandidate, bestAoeNumberOfUnits
      else
        return bestAoeNumberOfUnits, count
      end
    end

    function getAoeHealingCandidateLightOfDawn(minimalNumberofUnits, missingHP, rangeValue)
      local alliesinRange = getAllies("player",rangeValue)
      local count = 0
      if #alliesinRange >= minimalNumberofUnits then
        for i = 1, #alliesinRange do
          local thisunit = alliesinRange[i]
          if 100*UnitHealth(thisunit)/UnitHealthMax(thisunit) < missingHP then
            count = count + 1
          end
        end
      end
      return count
    end

    function getLowestSingleTargetHealingCandidates()
      local lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, highestTankHP, highestTankUnit, averageHealth = 100, "player", 100, "player", 100, "player", 0
      for i = 1, #nNova do
        if nNova[i].role == "TANK" then
          if nNova[i].hp < lowestTankHP then
            lowestTankHP = nNova[i].hp
            lowestTankUnit = nNova[i].unit
          end
        end
        
        if nNova[i].hp < lowestHP then
          lowestHP = nNova[i].hp
          lowestUnit = nNova[i].unit
        end
        averageHealth = averageHealth + nNova[i].hp
      end
      averageHealth = averageHealth/#nNova

      --iterate one more time to get highest hp tank
      for i = 1, #nNova do
        if nNova[i].role == "TANK" then
          if nNova[i].unit ~= lowestTankUnit then
            highestTankHP = nNova[i].hp
            highestTankUnit = nNova[i].unit
          end
        end
      end      
      return lowestHP, lowestUnit, lowestTankHP, lowestTankUnit, highestTankHP, highestTankUnit, averageHealth
    end

    function preCombatHandlingHoly() --actions to be done prepull for holy
      --cast Eternal Flame on tanks
      if _HolyPower > 2 and castEternalFlame(100) then --Todo: We need to cast Eternal flame on both tanks.
        return true
    end
    if _HolyPower > 2 then
      if castEternalFlame(100) then
        return true
      end
    end
    if castHolyShock(nil, 100) then
      return true
    end
    if castHolyRadiance("player") then
      return true
    end
    return false
    end
  end
end

