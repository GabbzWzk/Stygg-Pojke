if select(3, UnitClass("player")) == 4 then

	function useCDs()
	    if (BadBoy_data['Cooldowns'] == 1 and isBoss()) or BadBoy_data['Cooldowns'] == 2 then
	        return true
	    else
	        return false
	    end
	end

	function useAoE()
	    if (BadBoy_data['AoE'] == 1 and #getEnemies("player",5) >= 2) or BadBoy_data['AoE'] == 2 then
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

	function getDistance2(Unit1,Unit2)
	    if Unit2 == nil then Unit2 = "player"; end
	    if UnitExists(Unit1) and UnitExists(Unit2) then
	        local X1,Y1,Z1 = ObjectPosition(Unit1);
	        local X2,Y2,Z2 = ObjectPosition(Unit2);
	        local unitSize = 0;
	        if UnitGUID(Unit1) ~= UnitGUID("player") and UnitCanAttack(Unit1,"player") then
	            unitSize = UnitCombatReach(Unit1);
	        elseif UnitGUID(Unit2) ~= UnitGUID("player") and UnitCanAttack(Unit2,"player") then
	            unitSize = UnitCombatReach(Unit2);
	        end
	        local distance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2))
	        if distance < max(5, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 4/3) then
	            return 4.9999
	        elseif distance < max(8, UnitCombatReach(Unit1) + UnitCombatReach(Unit2) + 6.5) then
	            if distance-unitSize <= 5 then
	                return 5
	            else
	                return distance-unitSize
	            end
	        elseif distance-(unitSize+UnitCombatReach("player")) <= 8 then
	            return 8
	        else
	            return distance-(unitSize+UnitCombatReach("player"))
	        end
	    else
	        return 1000;
	    end
	end

	function poisonData()
		if getOptionValue("Lethal")==1 then
			_LethalPoison = _InstantPoison
		end
		--if getOptionValue("Lethal")==2 then
		--	_LethalPoison = _WoundPoison
		--end
		if getOptionValue("Non-Lethal")==1 then
			_NonLethalPoison = _CripplingPoison
		end
		if getOptionValue("Non-Lethal")==2 then
			_NonLethalPoison = _LeechingPoison
		end
	end

end
