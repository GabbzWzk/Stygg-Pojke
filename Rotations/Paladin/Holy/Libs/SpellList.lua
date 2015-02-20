if select(3,UnitClass("player")) == 2 then

  function castLightOfDawn()
    if castSpell("player",_LightOfDawn,true,false) then
        return true
      end
  end

  function castLayOnHands(unit)
    return castSpell(unit,633,true,false) == true or false
  end

  function castHolyRadiance(unit) --Todo: Not its on unit but we should be able to set smart checks, ie best target for HolyRaidances
    if castSpell(unit,_HolyRadiance,true,false) then
      return true
    end
  end

  -- Holy Shock
  function castHolyShock(unit)
    if castSpell(unit, _HolyShock, true, false) then
      return true
    end
  end

  -- Holy Light
  function castHolyLight(unit)
    if castSpell(unit, _HolyLight, true, true) then 
      return true
    end
  end

  -- Flash Of Light
  function castFlashOfLight(unit)
    if castSpell(unit, _FlashOfLight, true, false) then
      return true
    end
  end
end
