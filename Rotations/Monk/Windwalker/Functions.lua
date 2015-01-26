if select(3,UnitClass("player")) == 10 then
        
    ------Member Check------
    function CalculateHP(unit)
      incomingheals = UnitGetIncomingHeals(unit) or 0
      return 100 * ( UnitHealth(unit) + incomingheals ) / UnitHealthMax(unit)
    end

    function GroupInfo()
        members, group = { { Unit = "player", HP = CalculateHP("player") } }, { low = 0, tanks = { } }
        group.type = IsInRaid() and "raid" or "party"
        group.number = GetNumGroupMembers()
        if group.number > 0 then
            for i=1,group.number do
                if canHeal(group.type..i) then
                    local unit, hp = group.type..i, CalculateHP(group.type..i)
                    members[#members+1] = { Unit = unit, HP = hp }
                    if hp < 90 then group.low = group.low + 1 end
                    if UnitGroupRolesAssigned(unit) == "TANK" then table.insert(group.tanks,unit) end
                end
            end
            if group.type == "raid" and #members > 1 then table.remove(members,1) end
            table.sort(members, function(x,y) return x.HP < y.HP end)
        end
    end

    function isAggroed(unit)
        local members = members
        if hasAggro == nil then hasAggro = false end
        for i=1,#members do
            local threat = select(3,UnitDetailedThreatSituation(members[i].Unit,unit))
            if threat~=nil then
                if threat>=100 then
                    hasAggro = true
                end
            end
        end
        if hasAggro==true then
            return true
        else
            return false
        end
    end

    -- function getDistance2(Unit1,Unit2)
    --     if Unit2 == nil then Unit2 = "player"; end
    --     if ObjectExists(Unit1) and ObjectExists(Unit2) then
    --         local X1,Y1,Z1 = ObjectPosition(Unit1);
    --         local X2,Y2,Z2 = ObjectPosition(Unit2);
    --         local unitSize = 0;
    --         if UnitGUID(Unit1) ~= UnitGUID("player") and UnitCanAttack(Unit1,"player") then
    --             unitSize = UnitCombatReach(Unit1);
    --         elseif UnitGUID(Unit2) ~= UnitGUID("player") and UnitCanAttack(Unit2,"player") then
    --             unitSize = UnitCombatReach(Unit2);
    --         end
    --         local distance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2))
    --         if distance < max(5, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 4/3) then
    --             return 4.9999
    --         elseif distance < max(8, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 6.5) then
    --             if distance-unitSize <= 5 then
    --                 return 5
    --             else
    --                 return distance-unitSize
    --             end
    --         elseif distance-(unitSize+UnitCombatReach("player")) <= 8 then
    --             return 8
    --         else
    --             return distance-(unitSize+UnitCombatReach("player"))
    --         end
    --     else
    --         return 1000;
    --     end
    -- end
    -- -- if getEnemiesTable("target",10) >= 3 then
    -- function getEnemiesTable(Unit,Radius)
    --     local enemiesTable = {};
    --     if ObjectExists("target") == true and getCreatureType("target") == true then
    --         if UnitCanAttack("player","target") == true and UnitIsDeadOrGhost("target") == false then
    --             local myDistance = getDistance("player","target")
    --             if myDistance <= Radius then
    --                 table.insert(enemiesTable, { unit = "target" , range = myDistance });
    --             end
    --         end
    --     end
    --     for i=1,ObjectCount() do
    --         if bit.band(ObjectType(ObjectWithIndex(i)), ObjectTypes.Unit) == 8 then
    --             local thisUnit = ObjectWithIndex(i);
    --             if UnitGUID(thisUnit) ~= UnitGUID("target") and getCreatureType(thisUnit) == true then
    --                 if UnitCanAttack("player",thisUnit) == true and UnitIsDeadOrGhost(thisUnit) == false then
    --                     local myDistance = getDistance("player",thisUnit)
    --                     if myDistance <= Radius then
    --                         table.insert({ unit = thisUnit , range = myDistance });
    --                     end
    --                 end
    --             end
    --         end
    --     end
    --     return enemiesTable;
    -- end

    function canToD()
        local thisUnit = dynamicTarget(5,true)
        if (getHP(thisUnit)<=10 or UnitHealth(thisUnit)<=UnitHealthMax("player")) and not UnitIsPlayer(thisUnit) then
            return true
        else
            return false
        end
    end

    function canEnhanceToD()
        local thisUnit = dynamicTarget(5,true)
        local boostedHP = UnitHealthMax("player")+(UnitHealthMax("player")*0.2)
        if (getHP(thisUnit)<=10 or (UnitHealth(thisUnit)<=boostedHP)) and UnitHealth(thisUnit) > UnitHealthMax("player") and not UnitIsPlayer(thisUnit) then
            return true
        else
            return false
        end
    end

    function useAoE()
        if ((BadBoy_data['AoE'] == 1 and #getEnemies("player",8) >= 3) or BadBoy_data['AoE'] == 2) and UnitLevel("player")>=46 then
            return true
        else
            return false
        end
    end


    function useCDs()
        if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
            return true
        else
            return false
        end
    end

    function useDefensive()
        if BadBoy_data['Defensive'] == 1 then
            return true
        else
            return false
        end
    end

    function useInterrupts()
        if BadBoy_data['Interrupts'] == 1 then
            return true
        else
            return false
        end
    end

    function getFacingDistance()
        if UnitIsVisible("player") and UnitIsVisible("target") then
            local Y1,X1,Z1 = ObjectPosition("player");
            local Y2,X2,Z2 = ObjectPosition("target");
            local Angle1 = ObjectFacing("player")
            local deltaY = Y2 - Y1
            local deltaX = X2 - X1
            Angle1 = math.deg(math.abs(Angle1-math.pi*2))
            if deltaX > 0 then
                Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2)+math.pi)
            elseif deltaX <0 then
                Angle2 = math.deg(math.atan(deltaY/deltaX)+(math.pi/2))
            end
            return round2(math.tan(math.abs(Angle2 - Angle1)*math.pi/180)*targetDistance*10000)/10000
        else
            return 1000
        end
    end

    function canFSK(unit)
        if ((targetDistance <= 8 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 5 and getFacing("player",unit)))
            and not hasGlyph(1017)
            and getSpellCD(_FlyingSerpentKick)==0
            and getFacingDistance() < 5
            and select(3,GetSpellInfo(_FlyingSerpentKick)) ~= "INTERFACE\\ICONS\\priest_icon_chakra_green"
            and not UnitIsDeadOrGhost(unit)
            and getTimeToDie(unit) > 2
            and not IsSwimming()
        then
            return true
        else
            return false
        end
    end

    function canContFSK(unit)
        if ((targetDistance <= 8 and isInCombat("player")) or (targetDistance < 60 and targetDistance > 5 and getFacing("player",unit)))
            and not hasGlyph(1017)
            and getFacingDistance() < 5
            and not UnitIsDeadOrGhost(unit)
            and getTimeToDie(unit) > 2
            and not IsSwimming()
        then
            return true
        else
            return false
        end
    end

    function getOption(spellID)
        return tostring(select(1,GetSpellInfo(spellID)))
    end


        -- function castTimeRemain(unit)
        --  if select(6,UnitCastingInfo(unit)) then
        --      castEndTime = select(6,UnitCastingInfo(unit))
        --      return ((castEndTime/1000) - GetTime())
        --  else
        --      return 0
        --  end
        -- end
        -- if castTimeRemain("target")>0 and castTimeRemain("target")<1 then
        --  RunMacroText("/kneel")
        --  ChatOverlay("Kneeling to the Flame")
        -- end
        --Trapping
        -- if trapTimer==nil then trapTimer = 0 end
        -- if trapping==nil or not isInCombat("player") then trapping = false end
        -- if UnitCreatureType("target")=="Beast" and GetItemCount(113991) > 0 then
        --  if canUse(113991) 
        --      and ((getDistance("player","target")<5 and getHP("target")<100) 
        --          or (getDistance("player","target")<40 and getDistance("player","target")>=5)) 
        --      and getHP("target")>0 
        --  then
        --      useItem(113991)
        --      trapTimer=GetTime()
        --  end
        --  if getDistance("player","target")<40 and getDistance("player","target")>=5 
        --      and trapTimer <= GetTime()-4 
        --  then
        --      if castSpell("target",_Provoke,false,false,false) then trapping = true return end
        --  end
        -- end

end