-- Icy veins: http://www.icy-veins.com/wow/holy-paladin-pve-healing-guide

if select(3, UnitClass("player")) == 2 then
  function PaladinHoly()
    -- Init Holy specific funnctions, toggles and configs.
    if currentConfig ~= "Holy Gabbz & CML" then
      PaladinHolyFunctions()
      PaladinHolyToggles()
      PaladinHolyOptions()
      currentConfig = "Holy Gabbz & CML"
      --player.init()
    end

    -- Locals Variables
    _HolyPower = UnitPower("player", 9)

    -- We should start with analysing who to heal so we know what todo later
    --	We should get all tanks and have them
    -- 	Then lowest non tank
    -- 	Then best AoE Heal candidate, for each possible spell we have, Light Of Dawn, Holy Radiance and Holy Shock with Daybreak.
    -- 	Then we need to see who we have beaconed
    --	Then we need to get dispell targets.

    -- 	We should calcualte best healing options and considere mana levels
    -- What different healing roles can we have
    --	Tank healer, beacon on both tanks and heal them or if they are above 90 heal lowest raid unit.
    --		When tanks are getting lower then we switch to heal them
    -- How do we handle beacons, so if we have light and faith, if one of them are full health and we are healing a non tank?
    -- If we switch beacon it cost 1K mana but we heal for 50%
    -- We start with tank healing, ie beacon on both tanks, heal raid if tanks are above a configured value in options, if below start focusing on tanks.
    --[[Lowest]]


    -- Food/Invis Check   Hm here we are checking if we should abort the rotation pulse due to if we are a vehicle or some stuff
    if canRun() ~= true or UnitInVehicle("Player") then
      return false
    end

    if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
      return true
    end

    ---------------------------
    -- Set Tanks or prioritised healing targets. Todo : Hm not keen on auto focus, we should have Tanks as target and focus
    ----------------------------
    --[[Set Main Healing Tank via focus]]
    if IsLeftControlKeyDown() then -- Set focus, ie primary healing target with left alt and mouseover target
      if UnitIsFriend("player","mouseover") and not UnitIsDeadOrGhost("mouseover") then
        RunMacroText("/focus mouseover")
      end
    end


    --local favoriteTank = { name = "NONE" , health = 0}
    --if UnitIsDeadOrGhost("focus") then
    --  if favoriteTank.name ~= "NONE" then
    --    favoriteTank = { name = "NONE" , health = 0}
    --    ClearFocus()
    --  end
    --end

    --if UnitExists("focus") == nil and favoriteTank.name == "NONE" then
    --  for i = 1, # nNova do
    --    if UnitIsDeadOrGhost("focus") == nil and nNova[i].role == "TANK" and UnitHealthMax(nNova[i].unit) > favoriteTank.health then
    --      favoriteTank = { name = UnitName(nNova[i].unit), health = UnitHealthMax(nNova[i].unit) }
    --      RunMacroText("/focus "..favoriteTank.name)
    --    end
    --  end
    --end

    --[[Off GCD in combat]]
    if UnitAffectingCombat("player") or IsLeftControlKeyDown() then -- Only heal if we are in combat or if left control is down for out of combat rotation
      --------------------------
      -- Beacons handling, set per configured logic, Beacon on tank, focus or wise where wise is we switches beacon for mana reasons
      --------------------------
      if BeaconOfLight() then   -- Set Beacon of Light and faith on correct target
        return true
      end
      --player.update()

      --------------------
      -- Dont cast if we are already casting.
      --------------------
      if castingUnit() then -- Do not interrupt if we are already casting : Todo : We should check latency so we dont wait for casting the next spell before the one is ending.
          return false
      end   
      -------------------------
      -- If we are not in combat but have pressed leftcontol then we are in prepull scenario
      -------------------------
      if not UnitAffectingCombat("player") then -- This is for hetting Holypower and shields up
        if preCombatHandlingHoly() then
          return true
        end
      end

      ---------------------------
      -- Cast Dispell, config checks are done in function, Todo: We should create generic castDispell
      --------------------------
      if castDispell() then
        return true
      end

      --[[Auto Attack if in melee]]
      if isInMelee() and getFacing("player","target") == true then
        RunMacroText("/startattack")
      end

      ------------------------------
      -- Healing Mode checks    -- We should have 3 different healing modes, tank healing, raid healing and Free For All. We should be able to toggle groups of people to heal, Group1-8
      ------------------------------
      if BadRobot_data['Healing'] == 1 then
        -- Tank Healing
        return HolyPaladinTankHealing()
      elseif BadRobot_data['Healing'] == 2 then
        -- Raid Healing
        return HolyPaladinRaidHealing()
      else
        -- Free For All
        print("3")
        return HolyPaladinFreeForAllHealing()
      end
    end
  end
end
