function HolyPaladinRaidHealing()       

  -------------------
  -- First check if someone is close to dying
  -------------------

  ------------------------------
  -- First we should see if there is any AoE healing, assuming we have beacon it should be decent tank healing
  ------------------------------
  if castHolyPrism(nil) then
    return true
  end

  -- AoE healing
  if castAoEHeals() then
    return true
  end

      --[[holy_shock,if=holy_power<=3]] -- Should add not cast if 5 HoPo
      if getOptionCheck("Holy Shock") and _HolyPower < 5 and castHolyShock(nil, getValue("Holy Shock"))  then
        return true
      end

      --Todo Need to add a check if we have 5 then use it
      if getOptionCheck("Eternal Flame") and castEternalFlame(getValue("Eternal Flame")) then
        return true
      end

      --[[flash_of_light,if=target.health.pct<=30]]
      if isChecked("Flash Of Light") and castFlashOfLight(nil, getValue("Flash Of Light")) then
        return true
      end

      if getOptionCheck("Holy Prism") and HolyPrism(getValue("Holy Prism")) then
        return true
      end

      if getOptionCheck("Holy Light") and castHolyLight(getValue("Holy Light")) then
        return true
      end
      -- Crusader strik for HoPo
end

function HolyPaladinTankHealing()
end

function HolyPaladinFreeForAllHealing()
end