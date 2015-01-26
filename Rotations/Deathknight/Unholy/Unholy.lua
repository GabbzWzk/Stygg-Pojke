if select(3,UnitClass("player")) == 6 then
  function UnholyDK()
    if currentConfig ~= "Unholy Chumii" then
      UnholyConfig();
      currentConfig = "Unholy Chumii";
    end
    UnholyToggles()
    GroupInfo()
    getRuneInfo()
  ------------------------------------------------------------------------------------------------------
  -- Locals --------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    local php = getHP("player")
    local power, powmax, powgen = getPower("player"), UnitPowerMax("player"), getRegen("player")
    local ttm = getTimeToMax("player")
    local enemies, enemiesList = #getEnemies("player",8), getEnemies("player",8)
    local GT = GetTime()
    local OUTBREAK_START, OUTBREAK_DURATION = GetSpellCooldown(_Outbreak)
    local OUTBREAK_COOLDOWN = (OUTBREAK_START - GT + OUTBREAK_DURATION)
    local SOULREAPER_START, SOULREAPER_DURATION = GetSpellCooldown(_SoulReaper)
    local SOULREAPER_COOLDOWN = (SOULREAPER_START - GT + SOULREAPER_DURATION)
    local BREATHOFSIN_START, BREATHOFSIN_DURATION = GetSpellCooldown(_BreathOfSindragosa)
    local BREATHOFSIN_COOLDOWN = (BREATHOFSIN_START - GT + BREATHOFSIN_DURATION)
    local DND_START, DND_DURATION = GetSpellCooldown(_DeathAndDecay)
    local DND_COOLDOWN = (DND_START - GT + DND_DURATION)
    local level = UnitLevel("player")
    --General Target Variables
    local tarUnit = {
      ["dyn0"] = "target", --No Dynamic
      ["dyn5"] = dynamicTarget(5,true), --Melee
      ["dyn10AoE"] = dynamicTarget(10,false), --Defensive Abilites
      ["dyn30"] = dynamicTarget(30,true), --Death Grip
      ["dyn30AoE"] = dynamicTarget(30,false), --Control Undead
    }
    local tarDist = {
      ["dyn0"] = getDistance("player",tarUnit.dyn0),
      ["dyn5"] = getDistance("player",tarUnit.dyn5),
      ["dyn10AoE"] = getDistance("player",tarUnit.dyn10AoE),
      ["dyn30"] = getDistance("player",tarUnit.dyn30),
      ["dyn30AoE"] = getDistance("player",tarUnit.dyn30AoE),
    }
    local thp = getHP(tarUnit.dyn5)
    local ttd = getTimeToDie(tarUnit.dyn5)
    local GCD = 1.5/(1+UnitSpellHaste("player")/100)
    local dRunes, bRunes, fRunes, uRunes = getRunes("death"), getRunes("blood") + getRunes("death"), getRunes("frost") + getRunes("death"), getRunes("unholy") + getRunes("death")
    local bPercent, fPercent, uPercent = getRunePercent("blood") + getRunes("death"), getRunePercent("frost") + getRunes("death"), getRunePercent("unholy") + getRunes("death")
    local bcStack = getBuffStacks("player",_BloodCharge,"player")
    local howRemain = getBuffRemain("player",_HornOfWinter)
    local empRemain = getBuffRemain("player",_EmpowerRuneWeapon)
    local dsRemain = getBuffRemain("player",_DarkSuccor)
    local amsRemain, amsCooldown = getBuffRemain("player",_AntiMagicShell), getSpellCD(_AntiMagicShell)
    local bosRemain, bosCooldown = getBuffRemain("player",_BreathOfSindragosa), getSpellCD(_BreathOfSindragosa)
    local bosDebuffRemain = getDebuffRemain("target",_BreathOfSindragosaAura,"player")
    local strPotRemain = getBuffRemain("player",156428)
    local srCooldown = getSpellCD(_SoulReaper)
    local obCooldown = getSpellCD(_Outbreak)
    local plCooldown = getSpellCD(_PlagueLeech)
    local ubCooldown = getSpellCD(_UnholyBlight)
    local dCooldown = getSpellCD(_Defile)
    local raCooldown = getSpellCD(_RaiseAlly)
    local dfCooldown = getSpellCD(_Defile)
    local erwCooldown = getSpellCD(_EmpowerRuneWeapon)
    local suddendoom = getBuffRemain("player",_SuddenDoom)
    local blight, bloodtap, runic, necrotic, defile, sindragosa = getTalent(1,3), getTalent(4,1), getTalent(4,2), getTalent(7,1), getTalent(7,2), getTalent(7,3)
    --Specific Target Variables
    local ciRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_ChainsOfIce,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_ChainsOfIce,"player"),
      ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_ChainsOfIce,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_ChainsOfIce,"player"),
      ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_ChainsOfIce,"player"),
    }
    local ffRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_FrostFever,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_FrostFever,"player"),
      ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_FrostFever,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_FrostFever,"player"),
      ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_FrostFever,"player"),
    }
    local bpRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_BloodPlague,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_BloodPlague,"player"),
      ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_BloodPlague,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_BloodPlague,"player"),
      ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_BloodPlague,"player"),
    }
    local necRemain = {
      ["dyn0"] = getDebuffRemain(tarUnit.dyn0,_NecroticPlague,"player"),
      ["dyn5"] = getDebuffRemain(tarUnit.dyn5,_NecroticPlague,"player"),
      ["dyn10AoE"] = getDebuffRemain(tarUnit.dyn10AoE,_NecroticPlague,"player"),
      ["dyn30"] = getDebuffRemain(tarUnit.dyn30,_NecroticPlague,"player"),
      ["dyn30AoE"] = getDebuffRemain(tarUnit.dyn30AoE,_NecroticPlague,"player"),
    }
    local hasDisease = {
      ["dyn0"] = ((ffRemain.dyn0>0 and bpRemain.dyn0>0) or necRemain.dyn0>0),
      ["dyn5"] = ((ffRemain.dyn5>0 and bpRemain.dyn5>0) or necRemain.dyn5>0),
      ["dyn10AoE"] = ((ffRemain.dyn10AoE>0 and bpRemain.dyn10AoE>0) or necRemain.dyn10AoE>0),
      ["dyn30"] = ((ffRemain.dyn30>0 and bpRemain.dyn30>0) or necRemain.dyn30>0),
      ["dyn30AoE"] = ((ffRemain.dyn30AoE>0 and bpRemain.dyn30AoE>0) or necRemain.dyn30AoE>0),
    }

    local opener = {
      sumgargop = 49206,
      outbreakop = 77575,
      feststrikeop1 = 85948,
      scourgeop1 = 55090,
      feststrikeop2 = 85948,
      scourgeop2 = 55090,
    }
  ------------------------------------------------------------------------------------------------------
  -- Food/Invis Check ----------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if canRun() ~= true or UnitInVehicle("Player") then
      return false;
    end
    if IsMounted("player") then
      return false;
    end
  ------------------------------------------------------------------------------------------------------
  -- Pause ---------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if isChecked("Pause Key") == true and SpecificToggle("Pause Key") == true then
      ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end
    if isChecked("2nd Pause Key") == true and SpecificToggle("2nd Pause Key") == true then
      ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
    end
  ------------------------------------------------------------------------------------------------------
  -- Spell Queue ---------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if _Queues == nil then
     _Queues = {
     [_BloodBoil]  = false,
     }
    end
  ------------------------------------------------------------------------------------------------------
  -- Input / Keys --------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    -- Defile
    if isKnown(_Defile) == true then
      if isChecked("DnD / Defile Key") == true and SpecificToggle("DnD / Defile Key") == true then
        if not IsMouselooking() then
            CastSpellByName(GetSpellInfo(43265))
            if SpellIsTargeting() then
                CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
                return true;
            end
        end
      end
    end
  -- DnD
    if isKnown(_Defile) == false then
      if isChecked("DnD / Defile Key") == true and SpecificToggle("DnD / Defile Key") == true then
        if not IsMouselooking() then
            CastSpellByName(GetSpellInfo(43265))
            if SpellIsTargeting() then
                CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
                return true;
            end
        end
      end
    end
    -- DnD
    if isKnown(_AntiMagicZone) == true then
      if isChecked("AMZ Key") == true and SpecificToggle("AMZ Key") == true then
        if not IsMouselooking() then
            CastSpellByName(GetSpellInfo(51052))
            if SpellIsTargeting() then
                CameraOrSelectOrMoveStart() CameraOrSelectOrMoveStop()
                return true;
            end
        end
      end
    end
  ------------------------------------------------------------------------------------------------------
  -- Ress/Dispell --------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------
  -- Buffs ---------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if isChecked("Horn of Winter") == true and (lastHOW == nil or lastHOW <= GetTime() - 5) then
      for i = 1, #nNova do
          if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{57330,19506,6673}) and (UnitInRange(nNova[i].unit) or UnitIsUnit(nNova[i].unit,"player")) then
            if castSpell("player",_HornOfWinter,true) then lastHOW = GetTime(); return; end
        end
      end
    end
  ------------------------------------------------------------------------------------------------------
  -- Out of Combat -------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if not isInCombat("player") then

    end -- Out of Combat end
  ------------------------------------------------------------------------------------------------------
  -- In Combat -----------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
    if isInCombat("player") then
  ------------------------------------------------------------------------------------------------------
  -- Dummy Test ----------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if isChecked("DPS Testing") == true then
        if UnitExists("target") then
          if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
            StopAttack()
            ClearTarget()
            --print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
          end
        end
      end
  ------------------------------------------------------------------------------------------------------
  -- Queued Spells -------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------
  -- Defensive Cooldowns -------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if useDefensive() == true then
        -- Icebound Fortitude
        if isChecked("Icebound Fortitude") == true then
          if php <= getValue("Icebound Fortitude") then
            if castSpell("player",_IceboundFortitude,true) then
              return;
            end
          end
        end
        -- Anti Magic Shell
        if isChecked("Anti Magic Shell") == true then
          if php <= getValue("Anti Magic Shell") then
            if castSpell("player",_AntiMagicShell,true) then
              return;
            end
          end
        end
        -- Healthstone
        if isChecked("Healthstone / Potion") == true and php <= getValue("Healthstone / Potion")
        and isInCombat("player") and hasHealthPot() then
          if canUse(5512) then
              UseItemByName(tostring(select(1,GetItemInfo(5512))))
          elseif canUse(healPot) then
              UseItemByName(tostring(select(1,GetItemInfo(healPot))))
          end
        end
        -- Death Pact
        if isChecked("Death Pact") == true then
          if php <= getValue("Death Pact") then
            if castSpell("player",_DeathPact,true) then
              return
            end
          end
        end
        -- Death Siphon
        if isChecked("Death Siphon") == true then
          if php <= getValue("Death Siphon") then
            if castSpell("target",_DeathSiphon,false,false) then
              return;
            end
          end
        end
        -- Death Strike
        if isChecked("Death Strike") == true then
          if php <= getValue("Death Strike") then
            if castSpell("target",_DeathStrike,true) then
              return;
            end
          end
        end
        -- -- Death Strike (Dark Succor)
        -- if isChecked("Death Strike (Dark Succor)") == true then
        --   if UnitBuffID("player",_DarkSuccor) then
        --     if php <= getValue("Death Strike (Dark Succor)") then
        --       if castSpell("player",_DeathStrike,true) then
        --         return;
        --       end
        --     end
        --   end
        -- end
      end -- isChecked("Defensive Mode") end
  ------------------------------------------------------------------------------------------------------
  -- Offensive Cooldowns -------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if useCDs() == true then
        -- Orc / Troll Racial
        if isChecked("Racial (Orc/Troll)") then
          if select(2, UnitRace("player")) == "Troll" then
            if castSpell("player",26297,true) then
              return;
            end
          elseif select(2, UnitRace("player")) == "Orc" then
            if castSpell("player",20572,true) then
              return;
            end
          end
        end
        -- summon_gargoyle
        if isChecked("Summon Gargoyle") then
          if castSpell("player",_SummonGargoyle,true) then
            --print("Gargoyle AoE")
            return
          end
        end
         -- empower_rune_weapon,if=blood<1&unholy<1&frost<1
        if isChecked("Empower Rune Weapon") then
          if bRunes < 1 and uRunes < 1 and fRunes < 1 then
            if castSpell("player",_EmpowerRuneWeapon,true) then
              --print("ERW")
              return
            end
          end
        end
        --On use Trinkets
        if canTrinket(13) and useCDs() then
          RunMacroText("/use 13")
          if IsAoEPending() then
            local X,Y,Z = ObjectPosition(Unit)
            CastAtPosition(X,Y,Z)
          end
        end
        if canTrinket(14) and useCDs() then
          RunMacroText("/use 14")
          if IsAoEPending() then
            local X,Y,Z = ObjectPosition(Unit)
            CastAtPosition(X,Y,Z)
          end
        end
      end -- useCDs() end
  ------------------------------------------------------------------------------------------------------
  -- Do everytime --------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if not UnitExists("pet") then
        if castSpell("player",_RaiseDead,true) then
          --print("Call Pet")
          return
        end
      end
      -- dark_transformation
      if castSpell("player",_DarkTransformation,true) then
        --print("Transformation AoE")
        return
      end
  ------------------------------------------------------------------------------------------------------
  -- Interrupts ----------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      -- Mind Freeze
      if isChecked("Mind Freeze") == true then
        castInterrupt(_MindFreeze, getValue("Mind Freeze"))
      end
      -- Mind Freeze
      if isChecked("Strangulate") == true then
        castInterrupt(_Strangulate, getValue("Strangulate"))
      end
  ------------------------------------------------------------------------------------------------------
  -- Rotation ------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
      if getValue("Rotation") == 1 then

if not useAoE() then
        -- actions.single_target=plague_leech,if=(cooldown.outbreak.remains<1)&((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))
        if hasDisease.dyn30AoE and getDisease(30,true,"min")<1 and tarDist.dyn30AoE<30 then
          if obCooldown < 1 and ((bRunes < 1 and fRunes < 1) or (bRunes < 1 and uRunes < 1) or (fRunes < 1 and uRunes < 1)) then
            if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
              --print("PL 1")
              return
            end
          end
        end
        -- actions.single_target+=/plague_leech,if=((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))&(dot.blood_plague.remains<3|dot.frost_fever.remains<3)
        -- actions.single_target+=/plague_leech,if=(dot.blood_plague.remains<1|dot.frost_fever.remains<1)
        -- actions.single_target+=/outbreak,if=!talent.necrotic_plague.enabled&(!dot.frost_fever.ticking|!dot.blood_plague.ticking)
        if not getTalent(7,1) then
          if (bpRemain.dyn30 == 0 or ffRemain.dyn30 == 0) and tarDist.dyn30AoE<30 then
            if castSpell(tarUnit.dyn30AoE,_Outbreak,true,false,false) then
              --print("OB 1")
              return
            end
          end
        end
        -- actions.single_target+=/unholy_blight,if=!talent.necrotic_plague.enabled&(dot.frost_fever.remains<3|dot.blood_plague.remains<3)
        -- actions.single_target+=/unholy_blight,if=talent.necrotic_plague.enabled&dot.necrotic_plague.remains<1
        -- actions.single_target+=/death_coil,if=runic_power>90
        if power > 90 then
          if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
            --print("DC 1")
            return
          end
        end
        -- actions.single_target+=/soul_reaper,if=(target.health.pct-3*(target.health.pct%target.time_to_die))<=45
        if level <= 99 then
          if thp <= 35 then
            if (thp-3*(thp/ttd)<=35) and uRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_SoulReaper,false,false,false) then
                --print("SR 1")
                return
              end
            end
          end
        end
        if level == 100 then
          if thp <= 45 then
            if (thp-3*(thp/ttd)<=45) and uRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_SoulReaper,false,false,false) then
                --print("SR 1")
                return
              end
            end
          end
        end
        -- actions.single_target+=/breath_of_sindragosa,if=runic_power>75
        if isChecked("Breath of Sindragosa") and useCDs() then
          if getTalent(7,3) then
            if power > 75 then
              if castSpell("player",_BreathOfSindragosa,true) then
                return
              end
            end
          end
        end
        -- actions.single_target+=/run_action_list,name=bos_st,if=dot.breath_of_sindragosa.ticking
        if bosDebuffRemain > 0 then
          -- actions.bos_st=death_and_decay,if=runic_power<88
          if power < 88 then
            if castGround("target",43265,6) then
              print("Defile / DnD BoS active")
              return
            end
          end
          -- actions.bos_st+=/festering_strike,if=runic_power<77
          if power < 77 then
            if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
              print("FS BoS active")
              return
            end
          end
          -- actions.bos_st+=/scourge_strike,if=runic_power<88
          if power < 88 then
            if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
              print("SS BoS active")
              return
            end
          end
          -- actions.bos_st+=/blood_tap,if=buff.blood_charge.stack>=5
          if bcStack >= 5 then
            if castSpell("player",_BloodTap,true) then
              print("BT BoS active")
              return
            end
          end
          -- actions.bos_st+=/plague_leech
          if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
            print("PL BoS active")
            return
          end
          -- actions.bos_st+=/empower_rune_weapon
          -- actions.bos_st+=/death_coil,if=buff.sudden_doom.react
          if UnitBuffID("player",_SuddenDoom) then
            if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
              print("DC BoS active")
              return
            end
          end
        end
        -- actions.single_target+=/death_and_decay,if=cooldown.breath_of_sindragosa.remains<7&runic_power<88&talent.breath_of_sindragosa.enabled
        if getTalent(7,3) then
          if useDefile() then
            if bosCooldown < 7 and power < 78 then
              if castGround("target",43265,6) then
                print("Defile / DnD BoS < 7")
                return
              end
            end
          end
        end
        -- actions.single_target+=/scourge_strike,if=cooldown.breath_of_sindragosa.remains<7&runic_power<88&talent.breath_of_sindragosa.enabled
        if getTalent(7,3) then
          if bosCooldown < 7 and power < 78 then
            if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
              print("SS BoS < 7")
              return
            end
          end
        end
        -- actions.single_target+=/festering_strike,if=cooldown.breath_of_sindragosa.remains<7&runic_power<76&talent.breath_of_sindragosa.enabled
        if getTalent(7,3) then
          if bosCooldown < 7 and power < 66 then
            if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
              print("FS BoS < 7")
              return
            end
          end
        end
        -- actions.single_target+=/blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
        if getTalent(4,1) then
          if (thp-3*(thp/ttd)<=45) and srCooldown == 0 then
            if bcStack >= 5 then
              if castSpell("player",_BloodTap,true) then
                --print("BT 1")
                return
              end
            end
          end
        end
        -- actions.single_target+=/death_and_decay,if=unholy=2
        -- actions.single_target+=/defile,if=unholy=2
        if useDefile() then
          if uRunes == 2 then
            if castGround("target",43265,6) then
              --print("Auto Defile / DnD 1")
              return
            end
          end
        end
        -- actions.single_target+=/plague_strike,if=(!dot.blood_plague.ticking|!dot.frost_fever.ticking)&unholy=2
        if (bpRemain.dyn5 == 0 or ffRemain.dyn5 == 0) and uRunes == 2 then
          if castSpell(tarUnit.dyn5,_PlagueStrike,false,false) then
            --print("PS 1")
            return
          end
        end
        -- actions.single_target+=/scourge_strike,if=unholy=2
        if uRunes == 2 then
          if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
            --print("SS 1")
            return
          end
        end
        -- actions.single_target+=/death_coil,if=runic_power>80
        if power > 80 then
          if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
            --print("DC 2")
            return
          end
        end
        -- actions.single_target+=/festering_strike,if=blood=2&frost=2&(((Frost-death)>0)|((Blood-death)>0))
        if bRunes == 2 and fRunes == 2 and (((fRunes - dRunes)>0) or ((bRunes - dRunes)>0)) then
          if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
            --print("FS 1")
            return
          end
        end
        -- actions.single_target+=/festering_strike,if=(blood=2|frost=2)&(((Frost-death)>0)&((Blood-death)>0))
        if (bRunes == 2 or fRunes == 2) and (((fRunes - dRunes)>0) or ((bRunes - dRunes)>0)) then
          if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
            --print("FS 2")
            return
          end
        end
        -- actions.single_target+=/defile,if=blood=2|frost=2
        if useDefile() and getTalent(7,2) then
          if bRunes == 2 or fRunes == 2 then
            if castGround("target",43265,6) then
              --print("Auto Defile 2")
              return
            end
          end
        end
        -- actions.single_target+=/plague_strike,if=(!dot.blood_plague.ticking|!dot.frost_fever.ticking)&(blood=2|frost=2)
        if (bpRemain.dyn5 == 0 or ffRemain.dyn5 == 0) and (bRunes == 2 or fRunes == 2) then
          if castSpell(tarUnit.dyn5,_PlagueStrike,false,false) then
            --print("PS 2")
            return
          end
        end
        -- actions.single_target+=/scourge_strike,if=blood=2|frost=2
        if bRunes == 2 or fRunes == 2 then
          if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
            --print("SS 2")
            return
          end
        end
        -- actions.single_target+=/festering_strike,if=((Blood-death)>1)
        if (bRunes - dRunes) > 1 then
          if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
            --print("FS 3")
            return
          end
        end
        -- actions.single_target+=/blood_boil,if=((Blood-death)>1)
        if (bRunes - dRunes) > 1 then
          if tarDist.dyn10AoE<15 then
            if castSpell("player",_BloodBoil,true,false,false) then
              --print("BB 1")
              return
            end
          end
        end
        -- actions.single_target+=/festering_strike,if=((Frost-death)>1)
        if (fRunes - dRunes) > 1 then
          if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
            --print("FS 4")
            return
          end
        end
        -- actions.single_target+=/blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
        if getTalent(4,1) then
          if (thp-3*(thp/ttd)<=45) and srCooldown == 0 then
            if bcStack >= 5 then
              if castSpell("player",_BloodTap,true) then
                --print("BT 2")
                return
              end
            end
          end
        end
        -- actions.single_target+=/death_and_decay
        -- actions.single_target+=/defile
        if useDefile() then
          if castGround("target",43265,6) then
            --print("Auto Defile / DnD 3")
            return
          end
        end
        -- actions.single_target+=/blood_tap,if=cooldown.defile.remains=0
        if getTalent(4,1) and getTalent(7,2) then
          if dfCooldown == 0 then
            if bcStack >= 5 then
              if castSpell("player",_BloodTap,true) then
                --print("BT 3")
                return
              end
            end
          end
        end
        -- actions.single_target+=/plague_strike,if=(!dot.blood_plague.ticking|!dot.frost_fever.ticking)
        if (bpRemain.dyn5 == 0 or ffRemain.dyn5 == 0) then
          if castSpell(tarUnit.dyn5,_PlagueStrike,false,false) then
            --print("PS 3")
            return
          end
        end
        -- actions.single_target+=/blood_tap,if=buff.blood_charge.stack>10&(buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1))
        if getTalent(4,1) then
          if bcStack > 10 and (UnitBuffID("player",_SuddenDoom) or (UnitBuffID("pet",_DarkTransformation) and uRunes <= 1)) then
            if castSpell("player",_BloodTap,true) then
              --print("BT 4")
              return
            end
          end
        end
        -- actions.single_target+=/death_coil,if=buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1)
        if UnitBuffID("player",_SuddenDoom) or (UnitBuffID("pet",_DarkTransformation) and uRunes <= 1) then
          if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
            --print("DC 3")
            return
          end
        end
        -- actions.single_target+=/scourge_strike,if=!((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)|(Unholy>=2)
        if (thp-3*(thp/ttd)<= 45) or uRunes >= 2 then
          if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
            --print("SS 3")
            return
          end
        end
        -- actions.single_target+=/blood_tap
        if bcStack >= 5 then
          if castSpell("player",_BloodTap,true) then
            --print("BT 5")
            return
          end
        end
        -- actions.single_target+=/festering_strike,if=!((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)|(((Frost-death)>0)&((Blood-death)>0))
        if (thp-3*(thp/ttd)<= 45) or (((fRunes - dRunes) > 0) and ((bRunes - dRunes) > 0)) then
          if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
            --print("FS 4")
            return
          end
        end
        -- actions.single_target+=/death_coil
        if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
          --print("DC 3")
          return
        end
        -- actions.single_target+=/plague_leech
        if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
          --print("PL 2")
          return
        end
        -- actions.single_target+=/scourge_strike,if=cooldown.empower_rune_weapon.remains=0
        if erwCooldown == 0 then
          if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
            --print("SS 4")
            return
          end
        end
        -- actions.single_target+=/festering_strike,if=cooldown.empower_rune_weapon.remains=0
        if erwCooldown == 0 then
          if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
            --print("FS 5")
            return
          end
        end
        -- actions.single_target+=/blood_boil,if=cooldown.empower_rune_weapon.remains=0
        if erwCooldown == 0 then
          if tarDist.dyn10AoE<15 then
            if castSpell("player",_BloodBoil,true,false,false) then
              --print("BB 2")
              return
            end
          end
        end
        -- actions.single_target+=/icy_touch,if=cooldown.empower_rune_weapon.remains=0
        if erwCooldown == 0 then
          if castSpell(tarUnit.dyn30,_IcyTouch,false,false) then
            --print("IT 1")
            return
          end
        end

      end --single end
  -- AoE -----------------------------------------------------------------------------------------------
      if useAoE() then
        -- actions.aoe=unholy_blight
        if getTalent(1,3) then
          if castSpell("player",_UnholyBlight,true) then
            --print("UB 1 AoE")
            return
          end
        end
        -- actions.aoe+=/run_action_list,name=spread,if=!dot.blood_plague.ticking|!dot.frost_fever.ticking
          -- actions.spread=blood_boil,cycle_targets=1,if=dot.blood_plague.ticking|dot.frost_fever.ticking
          if canCast(_BloodBoil) then
            local unitDebuffed = false
            local unitNotDebuffed = false
            for i = 1, #enemiesTable do
                if ObjectExists(enemiesTable[i].unit) then
                    if enemiesTable[i].distance < 8 then
                        if UnitDebuffID(enemiesTable[i].unit,55078,"player") then
                            unitDebuffed = true
                        else
                            unitNotDebuffed = true
                        end
                    end
                    if unitDebuffed == true and unitNotDebuffed == true then
                        if castSpell("player",_BloodBoil,true,false) then
                            --print("BB 1 AoE Spread Diseases")
                            return
                        end
                    end
                end
            end
        end
          -- actions.spread+=/outbreak,if=!talent.necrotic_plague.enabled&(!dot.blood_plague.ticking|!dot.frost_fever.ticking)
          if not getTalent(7,1) then
            if (bpRemain.dyn30AoE == 0 or ffRemain.dyn30AoE == 0) and tarDist.dyn30AoE<30 then
              if castSpell(tarUnit.dyn30AoE,_Outbreak,true,false,false) then
                --print("OB 1 AoE")
                return
              end
            end
          end
          -- actions.spread+=/outbreak,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
          if getTalent(7,1) then
            if necRemain.dyn30AoE == 0 and tarDist.dyn30AoE<30 then
              if castSpell(tarUnit.dyn30AoE,_Outbreak,true,false,false) then
                --print("OB 2 AoE")
                return
              end
            end
          end
          -- actions.spread+=/plague_strike,if=!talent.necrotic_plague.enabled&(!dot.blood_plague.ticking|!dot.frost_fever.ticking)
          if not getTalent(7,1) then
            if (bpRemain.dyn5 == 0 or ffRemain.dyn5 == 0) then
              if castSpell(tarUnit.dyn5,_PlagueStrike,false,false) then
                --print("PS 1 AoE")
                return
              end
            end
          end
          -- actions.spread+=/plague_strike,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
          if getTalent(7,1) then
            if necRemain == 0 then
              if castSpell(tarUnit.dyn5,_PlagueStrike,false,false) then
                --print("PS 2 AoE")
                return
              end
            end
          end
        -- actions.aoe+=/defile
        if useDefile() and getTalent(7,2) then
          if castGround("target",43265,6) then
            --print("Auto Defile 1 AoE")
            return
          end
        end
        -- actions.aoe+=/breath_of_sindragosa,if=runic_power>75
        -- actions.aoe+=/run_action_list,name=bos_aoe,if=dot.breath_of_sindragosa.ticking
        -- actions.aoe+=/blood_boil,if=blood=2|(frost=2&death=2)
        if #getEnemies("player",8) >= getValue("Blood Boil Spam") then
          if bRunes == 2 or (fRunes == 2 and dRunes == 2) then
            if tarDist.dyn10AoE<15 then
              if castSpell("player",_BloodBoil,true,false) then
                --print("BB 2 nospread")
                return
              end
            end
          end
        end
        -- actions.aoe+=/defile
        -- actions.aoe+=/death_and_decay,if=unholy=1
        if useDefile() then
          if getTalent(7,2) then
            if castGround("target",43265,6) then
              --print("Auto Defile 2 AoE")
              return
            end
          end
          if not getTalent(7,2) then
            if uRunes == 1 then
              if castGround("target",43265,6) then
                --print("Auto DnD 3 AoE")
                return
              end
            end
          end
        end
        -- actions.aoe+=/soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=45
        if level <= 99 then
          if thp <= 35 then
            if (thp-3*(thp/ttd)<=35) and uRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_SoulReaper,false,false,false) then
                --print("SR 1 AoE")
                return
              end
            end
          end
        end
        if level == 100 then
          if thp <= 45 then
            if (thp-3*(thp/ttd)<=45) and uRunes>=1 and tarDist.dyn5<5 then
              if castSpell(tarUnit.dyn5,_SoulReaper,false,false,false) then
                --print("SR 1 AoE")
                return
              end
            end
          end
        end
        -- actions.aoe+=/scourge_strike,if=unholy=2
        if uRunes == 2 then
          if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
            --print("SS 1 AoE")
            return
          end
        end
        -- actions.aoe+=/blood_tap,if=buff.blood_charge.stack>10
        if bcStack > 10 then
          if castSpell("player",_BloodTap,true) then
            --print("BT 1 AoE")
            return
          end
        end
        -- actions.aoe+=/death_coil,if=runic_power>90|buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1)
        if power > 90 or UnitBuffID("player",_SuddenDoom) or (not UnitBuffID("pet",_DarkTransformation) and uRunes <= 1) then
          if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
            --print("DC 1 AoE")
            return
          end
        end
        -- actions.aoe+=/blood_boil
        if #getEnemies("player",8) >= getValue("Blood Boil Spam") then
          if tarDist.dyn10AoE<15 then
            if castSpell("player",_BloodBoil,true,false) then
              --print("BB 3 nospread")
              return
            end
          end
        end
        -- actions.aoe+=/icy_touch
        if castSpell(tarUnit.dyn30,_IcyTouch,false,false) then
            --print("IT 1 AoE")
            return
          end
        -- actions.aoe+=/scourge_strike,if=unholy=1
        if uRunes == 1 then
          if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
            --print("SS 2 AoE")
            return
          end
        end
        -- actions.aoe+=/death_coil
        if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
          --print("DC 2 AoE")
          return
        end
        -- actions.aoe+=/blood_tap
        if bcStack >= 5 then
          if castSpell("player",_BloodTap,true) then
            --print("BT 2 AoE")
            return
          end
        end
        -- actions.aoe+=/plague_leech
        if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
          --print("PL 1 AoE")
          return
        end

      end --aoe end
      end -- rotation 1 end

      if getValue("Rotation") == 2 then
      -- Opener // 1. Army of the Dead 6s before pull 2. Pre-pot 3. Deaths Advance
        -- if getCombatTime() <=  and (isBoss() or isDummy("target")) then
          -- 4. Summon Gargoyle -- gcd
          -- 5. Outbreak -- gcd
          -- 6. Festering Strike x1 --  gcd
          -- 7. Defile if the target will remain in the ground effect for 5 ticks or more, otherwise use Scourge Strike
          -- 8. Festering Strike x1 --  gcd
          -- 9. Scourge Strike unless Defile was not used. -- gcd
          -- for i = 1, opener[i]
        -- end
      -- Plague Leech when:
      -- Two runes are fully exhausted
      -- AND/OR
      -- Diseases are about to expire
      -- AND/OR
      -- Outbreak is off cooldown or within 1 GCD of coming off cooldown
      -- AND/OR
      -- You have GCDs to fill in your rotation
      if hasDisease.dyn30AoE and getDisease(30,true,"min") < 1 and tarDist.dyn30AoE<30 then
        if obCooldown < 1 and ((bRunes < 1 and fRunes < 1) or (bRunes < 1 and uRunes < 1) or (fRunes < 1 and uRunes < 1)) then
          if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
            --print("PL 1")
            return
          end
        end
      end
      if castSpell(tarUnit.dyn30AoE,_PlagueLeech,true,false,false) then
        return
      end
      -- Soul Reaper when:
      -- The target will reach execute range within 5 seconds
      -- OR
      -- The target is at or below 45%
      -- Ko'ragh barrier < 20% (finisher can be cast if barrier<20%)
      if GetUnitName("target")=="Ko'ragh" then
        if castSpell("target",_SoulReaper,false,false) then
          return
        end
      end
      if (isBoss() and getTimeTo("target",45) < 5) or thp <= 45 then
        if castSpell(tarUnit.dyn5,_SoulReaper,false,false) then
          return
        end
      end
      -- Summon Gargoyle when:
      -- It is off-cooldown // In Offensive CDs

      -- Unholy Blight when:
      -- Disease(s) are not active on any target
      if blight and not hasDisease.dyn10AoE then
        if castSpell("player",_UnholyBlight,true) then
          return
        end
      end
      -- Outbreak when:
      -- Disease(s) are not active on any target
      if not hasDisease.dyn30AoE then
        if castSpell(tarUnit.dyn30AoE,_Outbreak,true,false,false) then
          return
        end
      end
      -- Plague Strike when:
      -- Outbreak is on cooldown
      -- AND
      -- Disease(s) are not active on any target
      if obCooldown > 0 and not hasDisease.dyn5 then
        if castSpell(tarUnit.dyn5,_PlagueStrike,false,false) then
          return
        end
      end
      -- Blood Boil when:
      -- Diseases are not active on 2 or more targets
      if useAoE then
        if #getEnemies("player",8) >= getValue("Blood Boil Spam") then
          if canCast(_BloodBoil) then
            local unitDebuffed = false
            local unitNotDebuffed = false
            for i = 1, #enemiesTable do
              if ObjectExists(enemiesTable[i].unit) then
                if enemiesTable[i].distance < 8 then
                  if UnitDebuffID(enemiesTable[i].unit,55078,"player") then
                      unitDebuffed = true
                  else
                      unitNotDebuffed = true
                  end
                end
                if unitDebuffed == true and unitNotDebuffed == true then
                  if castSpell("player",_BloodBoil,true,false) then
                      --print("BB 1 AoE Spread Diseases")
                      return
                  end
                end
              end
            end
          end
        end
      end
      -- Death and Decay when:
      -- Two or more targets are in range of each other
      -- AND
      -- The targets will remain in the ground effect for most of its duration
      -- Defile when:
      -- The target will remain in the ground effect for most of its duration
      if useDefile() then
        if getTalent(7,2) then
          if castGround("target",43265,6) then --Defile
            return
          end
        end
        if not getTalent(7,2) then
          if uRunes == 1 then
            if castGround("target",43265,6) then -- DnD
              return
            end
          end
        end
      end
      -- Scourge Strike when:
      -- Both Unholy runes are capped
      if uRunes == 2 then
        if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
          return
        end
      end
      -- Blood Boil when:
      -- Four or more targets are in cleavable range
      -- AND
      -- Both sets of Death runes are capped
      if useAoE() and #getEnemies("player",8) >= getValue("Blood Boil Spam") then
        if dRunes >= 4 then
          if castSpell("player",_BloodBoil,true) then
            return
          end
        end
      end
      -- Scourge Strike when:
      -- Both Death runes are capped
      if dRunes == 2 then
        if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
          return
        end
      end
      -- Festering Strike when:
      -- Both Blood and Frost runes are capped
      if bRunes == 2 and fRunes == 2 then
        if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
          return
        end
      end
      -- Dark Transformation when:
      -- Shadow Infusion is at 5 stacks // in Do everytime

      -- Blood Tap when:
      -- Blood Charges are at 12
      if bcStack == 12 then
        if castSpell("player",_BloodTap,true) then
          return
        end
      end
      -- Death Coil when:
      -- Sudden Doom proc is active
      -- AND/OR
      -- Runic power is greater than 90
      -- AND
      -- Blood Charges are less than or equal to 10
      if (suddendoom > 0 or power > 90) and bcStack == 10 then
        if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
          return
        end
      end
      -- Scourge Strike when:
      -- An Unholy or Death rune is recharged
      if uRunes >= 1 or dRunes >= 1 then
        if castSpell(tarUnit.dyn5,_ScourgeStrike,false,false) then
          return
        end
      end
      -- Festering Strike when:
      -- A pair of Blood and Frost runes are recharged
      if bRunes == 2 or fRunes == 2 then
        if castSpell(tarUnit.dyn5,_FesteringStrike,false,false) then
          return
        end
      end
      -- Blood Tap when:
      -- Blood Charges are at 10
      if bcStack == 10 then
        if castSpell("player",_BloodTap,true) then
          return
        end
      end
      -- Death Coil when:
      -- Runic Power is greater than or equal to 30
      if power >= 30 then
        if castSpell(tarUnit.dyn30,_DeathCoil,false,false) then
          return
        end
      end
      -- Blood Tap when:
      -- Blood Charges are at 5 or more
      if bcStack >= 5 then
        if castSpell("player",_BloodTap,true) then
          return
        end
      end
      -- Empower Rune Weapon when:
      -- All runes are exhausted
      -- AND/OR
      -- Runic Power is exhausted // in Offensives
  end


    end -- In Combat end
  end -- Spec End
end --DK End