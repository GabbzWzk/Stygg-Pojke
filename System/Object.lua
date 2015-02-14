function GetObjectExists(Unit)
	if select(2,pcall(ObjectExists,Unit)) == 1 then
    	return true
  	else
    	return false
  	end
end

function GetObjectFacing(Unit)
	if GetObjectExists(Unit) then
    	return select(2,pcall(ObjectFacing,Unit))
  	else
    	return false
  	end
end

function GetObjectPosition(Unit)
	if GetObjectExists(Unit) then
    	return select(2,pcall(ObjectPosition,Unit))
  	else
    	return false
  	end
end

function GetObjectType(Unit)
  	if GetObjectExists(Unit) then
    	return select(2,pcall(ObjectType,Unit))
  	else
    	return false
  	end
end

function GetObjectIndex(Index)
  	if GetObjectExists(select(2,pcall(ObjectWithIndex,Index))) then
    	return select(2,pcall(ObjectWithIndex,Index))
  	else
    	return false
  	end
end

function GetObjectCount()
	return select(2,pcall(ObjectCount))
end

function IGetLocation(Unit)
	return GetGetObjectPosition(Unit)
end

-- if getDistance("player","target") <= 40 then
function getDistance(Unit1,Unit2)
  -- If both units are visible
  if GetObjectExists(Unit1) and UnitIsVisible(Unit1) == true and (Unit2 == nil or (GetObjectExists(Unit2) and UnitIsVisible(Unit2) == true)) then
    -- If Unit2 is nil we compare player to Unit1
    if Unit2 == nil then
            Unit2 = Unit1
            Unit1 = "player"
        end
        -- if unit1 is player, we can use our lib to get precise range
    if Unit1 == "player" and (isDummy(Unit2) or UnitCanAttack(Unit2,"player") == true) then
      return rc:GetRange(Unit2) or 1000
        -- else, we use FH positions
    else
            local X1,Y1,Z1 = GetObjectPosition(Unit1)
            local X2,Y2,Z2 = GetObjectPosition(Unit2)
            return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2)) - ((UnitCombatReach(Unit1)) + (UnitCombatReach(Unit2)))
    end
  else
    return 100
  end
end

function getRealDistance(Unit1,Unit2)
  if GetObjectExists(Unit1) and UnitIsVisible(Unit1) == true
      and GetObjectExists(Unit2) and UnitIsVisible(Unit2) == true then
    local X1,Y1,Z1 = GetObjectPosition(Unit1)
    local X2,Y2,Z2 = GetObjectPosition(Unit2)
        return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2)) - (UnitCombatReach(Unit1) + UnitCombatReach(Unit2))
  else
    return 100
  end
end

function getDistanceToObject(Unit1,X2,Y2,Z2)
  if Unit1 == nil then
    Unit1 = "player"
  end
  if ObjectExists(Unit1) and UnitIsVisible(Unit1) then
    local X1,Y1 = GetObjectPosition(Unit1)
    return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2))
  else
    return 100
  end
end

-- if getFacing("target","player") == false then
function getFacing(Unit1,Unit2,Degrees)
  if Degrees == nil then
    Degrees = 90
  end
  if Unit2 == nil then
    Unit2 = "player"
  end
  if GetObjectExists(Unit1) and UnitIsVisible(Unit1) and GetObjectExists(Unit2) and UnitIsVisible(Unit2) then
    local Angle1,Angle2,Angle3
    local Angle1 = GetObjectFacing(Unit1)
    local Angle2 = GetObjectFacing(Unit2)
    local Y1,X1,Z1 = GetObjectPosition(Unit1)
        local Y2,X2,Z2 = GetObjectPosition(Unit2)
      if Y1 and X1 and Z1 and Angle1 and Y2 and X2 and Z2 and Angle2 then
          local deltaY = Y2 - Y1
          local deltaX = X2 - X1
          Angle1 = math.deg(math.abs(Angle1-math.pi*2))
          if deltaX > 0 then
              Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
          elseif deltaX <0 then
              Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
          end
          if Angle2-Angle1 > 180 then
            Angle3 = math.abs(Angle2-Angle1-360)
          else
            Angle3 = math.abs(Angle2-Angle1)
          end
          if Angle3 < Degrees then
            return true
          else
            return false
          end
      end
  end
end

-- if getLineOfSight("target"[,"target"]) then
function getLineOfSight(Unit1,Unit2)
  if Unit2 == nil then
    if Unit1 == "player" then
      Unit2 = "target"
    else
      Unit2 = "player"
    end
  end
  local skipLoSTable = {
    76585,-- Ragewing
  }
  for i = 1,#skipLoSTable do
    if getUnitID(Unit1) == skipLoSTable[i] or getUnitID(Unit2) == skipLoSTable[i] then
      return true
    end
  end
  if GetObjectExists(Unit1) and UnitIsVisible(Unit1) and GetObjectExists(Unit2) and UnitIsVisible(Unit2) then
    local X1,Y1,Z1 = GetObjectPosition(Unit1)
    local X2,Y2,Z2 = GetObjectPosition(Unit2)
    if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 2, 0x10) == nil then
      return true
    else
      return false
    end
  else
    return true
  end
end

-- if getGround("target"[,"target"]) then
function getGround(Unit)
  if GetObjectExists(Unit) and UnitIsVisible(Unit) then
    local X1,Y1,Z1 = GetObjectPosition(Unit)
    if TraceLine(X1,Y1,Z1,X1,Y1,Z1-2, 0x10) == nil and TraceLine(X1,Y1,Z1,X1,Y1,Z1-2, 0x100) == nil then
      return nil
    else
      return true
    end
  end
end

function getGroundDistance(Unit)
  if GetObjectExists(Unit) and UnitIsVisible(Unit) then
    local X1,Y1,Z1 = GetObjectPosition(Unit)
    for i = 1,100 do
      if TraceLine(X1,Y1,Z1,X1,Y1,Z1-i/10, 0x10) ~= nil or TraceLine(X1,Y1,Z1,X1,Y1,Z1-i/10, 0x100) ~= nil then
        return i/10
      end
    end
  end
end

-- if getPetLineOfSight("target"[,"target"]) then
function getPetLineOfSight(Unit)
  if GetObjectExists(Unit) and UnitIsVisible("pet") and UnitIsVisible(Unit) then
    local X1,Y1,Z1 = GetObjectPosition("pet")
    local X2,Y2,Z2 = GetObjectPosition(Unit)
    if TraceLine(X1,Y1,Z1 + 2,X2,Y2,Z2 + 2, 0x10) == nil then
      return true
    else
      return false
    end
  else
    return true
  end
end



--- Round
function round2(num,idp)
  mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
