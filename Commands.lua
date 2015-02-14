print("Command Module Loaded")

---------------------------------
-- Macro Toggle ON/OFF
--------------------------------
SLASH_BadRobot1 = "/BadRobot"
function SlashCmdList.BadRobot(msg, editbox, ...)
	print(...)
	mainButton:Click()
end

SLASH_AoE1 = "/aoe"
function SlashCmdList.AoE(msg, editbox)
	ToggleValue("AoE")
end

SLASH_FHStop1 = "/fhstop"
function SlashCmdList.FHStop(msg, editbox)
	StopFalling()
	StopMoving()
end
	SLASH_Cooldowns1 = "/Cooldowns"
function SlashCmdList.Cooldowns(msg, editbox)
	ToggleValue("Cooldowns")
end

SLASH_DPS1 = "/DPS"
function SlashCmdList.DPS(msg, editbox)
	ToggleValue("DPS")
end
	SLASH_BlackList1, SLASH_BlackList2 = "/blacklist", "/bbb"
function SlashCmdList.BlackList(msg, editbox)
	if BadRobot_data.blackList == nil then BadRobot_data.blackList = { } end
		if msg == "dump" then
		print("|cffFF0000BadRobot Blacklist:")
		if #BadRobot_data.blackList == (0 or nil) then print("|cffFFDD11Empty") end
		if BadRobot_data.blackList then
			for i = 1, #BadRobot_data.blackList do
				print("|cffFFDD11- "..BadRobot_data.blackList[i].name)
			end
		end
	elseif msg == "clear" then
		BadRobot_data.blackList = { }
		print("|cffFF0000BadRobot Blacklist Cleared")
	else
		if UnitExists("mouseover") then
			local mouseoverName = UnitName("mouseover")
			local mouseoverGUID = UnitGUID("mouseover")
			-- Now we're trying to find that unit in the blackList table to remove
			local found
			for k,v in pairs(BadRobot_data.blackList) do
				-- Now we're trying to find that unit in the Cache table to remove
				if UnitGUID("mouseover") == v.guid then
					tremove(BadRobot_data.blackList, k)
					print("|cffFFDD11"..mouseoverName.."|cffFF0000 Removed from Blacklist")
					found = true
					--blackList[k] = nil
				end
			end
			if not found then
				print("|cffFFDD11"..mouseoverName.."|cffFF0000 Added to Blacklist")
				tinsert(BadRobot_data.blackList, { guid = mouseoverGUID, name = mouseoverName})
			end
		end
	end
end

SLASH_Pause1 = "/Pause"
function SlashCmdList.Pause(msg, editbox)
	if BadRobot_data['Pause'] == 0 then
        ChatOverlay("\124cFFED0000 -- Paused -- ")
		BadRobot_data['Pause'] = 1
	else
        ChatOverlay("\124cFF3BB0FF -- Pause Removed -- ")
		BadRobot_data['Pause'] = 0
	end
end

SLASH_Power1 = "/Power"
function SlashCmdList.Power(msg, editbox)
	if BadRobot_data['Power'] == 0 then
        ChatOverlay("\124cFF3BB0FF -- BadRobot Enabled -- ")
		BadRobot_data['Power'] = 1
	else
        ChatOverlay("\124cFFED0000 -- BadRobot Disabled -- ")
		BadRobot_data['Power'] = 0
	end
end
