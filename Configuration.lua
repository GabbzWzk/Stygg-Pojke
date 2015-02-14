-- if isChecked("Debug") then
function isChecked(Value)
	--print(BadRobot_data.options[GetSpecialization()]["profile"..Value.."Check"])
	if BadRobot_data.options[GetSpecialization()] and BadRobot_data.options[GetSpecialization()][Value.."Check"] == 1 then
		return true
	end
end

-- if isSelected("Stormlash Totem") then
function isSelected(Value)
	if BadRobot_data["Cooldowns"] == 3 or (isChecked(Value)
	  and (getValue(Value) == 3 or (getValue(Value) == 2 and BadRobot_data["Cooldowns"] == 2))) then
		return true
	end
end

-- if getValue("player") <= getValue("Eternal Flame") then
function getValue(Value)
	if BadRobot_data.options[GetSpecialization()] then
		if BadRobot_data.options[GetSpecialization()][Value.."Status"] ~= nil then
			return BadRobot_data.options[GetSpecialization()][Value.."Status"]
		elseif BadRobot_data.options[GetSpecialization()][Value.."Drop"] ~= nil then
			return BadRobot_data.options[GetSpecialization()][Value.."Drop"]
		else
			return 0
		end
	end
end

-- used to gather informations from the bot options frame
function getOptionCheck(Value)
	if BadRobot_data.options[GetSpecialization()] and BadRobot_data.options[GetSpecialization()][Value.."Check"] == 1 then
		return true
	end
end

function getOptionValue(Value)
	if BadRobot_data.options[GetSpecialization()] and BadRobot_data.options[GetSpecialization()][Value.."Status"] then
		return BadRobot_data.options[GetSpecialization()][Value.."Status"]
	elseif BadRobot_data.options[GetSpecialization()] and BadRobot_data.options[GetSpecialization()][Value.."Drop"] then
		return BadRobot_data.options[GetSpecialization()][Value.."Drop"]
	else
		return 0
	end
end