function bb.read.commonReaders()
	---------------
	--[[ Readers ]]
	---------------

	-----------------------
	--[[ Loss of control ]]
	local frame = CreateFrame('Frame')
	frame:RegisterEvent("LOSS_OF_CONTROL_UPDATE")
	local function lostControl(self,event,...)
		print(...)
	end
	frame:SetScript("OnEvent",lostControl)

	----------------
	--[[ Auto Join]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("LFG_PROPOSAL_SHOW")
	local function MerchantShow(self,event,...)
		if getOptionCheck("Accept Queues") == true then
			if event == "LFG_PROPOSAL_SHOW" then
				readyToAccept = GetTime()
			end
		end
	end
	Frame:SetScript("OnEvent",MerchantShow)

	--------------
	--[[ Eclipse]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("ECLIPSE_DIRECTION_CHANGE")
	local function Eclipse(self, event, ...)
		if event == "ECLIPSE_DIRECTION_CHANGE" then
			if select(1,...) == "sun" then
				eclipseDirection = 1
			else
				eclipseDirection = 0
			end
		end
	end
	Frame:SetScript("OnEvent", Eclipse)

	--------------------------
	--[[ isStanding Frame --]]
	DontMoveStartTime = nil
	CreateFrame("Frame"):SetScript("OnUpdate", function ()
	    if GetUnitSpeed("Player") == 0 then
	        if not DontMoveStartTime then
	            DontMoveStartTime = GetTime()
	        end
	        isMovingStartTime = 0
	    else
	        if isMovingStartTime == 0 then
	            isMovingStartTime = GetTime()
	        end
	        DontMoveStartTime = nil
	    end
	end)

	----------------------
	--[[ timer Frame --]]
	CreateFrame("Frame"):SetScript("OnUpdate", function ()
	    if uiDropdownTimer ~= nil then
	        uiTimerStarted = GetTime()
	    end
	    if uiTimerStarted and GetTime() - uiTimerStarted >= 0.5 then
	        clearChilds(uiDropdownTimer)
	        uiDropdownTimer = false
	        uiTimerStarted = nil
	    end
	end)

	-----------------------
	--[[ Merchant Show --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("MERCHANT_SHOW")
	local function MerchantShow(self,event,...)
		if event == "MERCHANT_SHOW" then
			if getOptionCheck("Auto-Sell/Repair") then
				SellGreys()
			end
		end
	end
	Frame:SetScript("OnEvent",MerchantShow)

	-------------------------
	--[[ Entering Combat --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	local function EnteringCombat(self,event,...)
		if event == "PLAYER_REGEN_DISABLED" then
			
			player.inCombat = true
			player.combatStarted = GetTime()
			BadRobot_data["Combat Started"] = GetTime()
			ChatOverlay("|cffFF0000Entering Combat")
		end
	end
	Frame:SetScript("OnEvent",EnteringCombat)

	-----------------------
	--[[ Leaving Combat --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	local function LeavingCombat(self,event,...)
		if event == "PLAYER_REGEN_ENABLED" then
			-- wipe interupts table
			bb.im:debug("Wiping casters table as we left combat.")
			table.wipe(bb.im.casters)
	        -- start loot manager
	        if lM then
	            if not IsMounted("player") then
	                lM.shouldLoot = true
	                lM.looted = 0
	            end
	        end

	        player.combatStarted = 0
	        player.inCombat =  false


			potionReuse = true
			AgiSnap = 0
			usePot = true
			leftCombat = GetTime()
			BadRobot_data.successCasts = 0
			BadRobot_data.failCasts = 0
			BadRobot_data["Combat Started"] = 0
			ChatOverlay("|cff00FF00Leaving Combat")
			-- clean up out of combat
	        Rip_sDamage = {}
	        Rake_sDamage = {}
	        Thrash_sDamage = {}
	        petAttacking = false
		end
	end
	Frame:SetScript("OnEvent",LeavingCombat)

	---------------------------
	--[[ UI Error Messages --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("UI_ERROR_MESSAGE")
	local function UiErrorMessages(self,event,...)
		lastError = ...; lastErrorTime = GetTime()
	  	local param = (...)
	end
	Frame:SetScript("OnEvent", UiErrorMessages)

	------------------------
	--[[ Spells Changed --]]
	local Frame = CreateFrame('Frame')
	Frame:RegisterEvent("LEARNED_SPELL_IN_TAB")
	local function SpellsChanged(self, event, ...)
		if not configReloadTimer or configReloadTimer <= GetTime() - 1 then
			currentConfig, configReloadTimer = nil, GetTime()
		end
	end
	Frame:SetScript("OnEvent", SpellsChanged)

	--- under devlopment not working as of now
	--[[ Addon reader ]]
	-- local Frame = CreateFrame('Frame')
	-- Frame:RegisterEvent("CHAT")
	--    "GROUP_ROSTER_UPDATE",
	--    "INSTANCE_GROUP_SIZE_CHANGED",
	--     "CHAT_MSG_ADDON",
	--     "BN_CHAT_MSG_ADDON",
	--     "PLAYER_REGEN_DISABLED",
	--     "PLAYER_REGEN_ENABLED",
	--     "INSTANCE_ENCOUNTER_ENGAGE_UNIT",
	--     "UNIT_TARGETABLE_CHANGED",
	--     "ENCOUNTER_START",
	--     "ENCOUNTER_END",
	--     --"SPELL_UPDATE_CHARGES",
	--     "UNIT_DIED",
	--     "UNIT_DESTROYED",
	--     "UNIT_HEALTH mouseover target focus player",
	--     "CHAT_MSG_WHISPER",
	--     "CHAT_MSG_BN_WHISPER",
	--     "CHAT_MSG_MONSTER_YELL",
	--     "CHAT_MSG_MONSTER_EMOTE",
	--     "CHAT_MSG_MONSTER_SAY",
	--     "CHAT_MSG_RAID_BOSS_EMOTE",
	--     "RAID_BOSS_EMOTE",
	--     "PLAYER_ENTERING_WORLD",
	--     "LFG_ROLE_CHECK_SHOW",
	--     "LFG_PROPOSAL_SHOW",
	--     "LFG_PROPOSAL_FAILED",
	--     "LFG_PROPOSAL_SUCCEEDED",
	--     "UPDATE_BATTLEFIELD_STATUS",
	--     "CINEMATIC_START",
	--     "LFG_COMPLETION_REWARD",
	--     --"WORLD_STATE_TIMER_START",
	--     --"WORLD_STATE_TIMER_STOP",
	--     "CHALLENGE_MODE_START",
	--     "CHALLENGE_MODE_RESET",
	--     "CHALLENGE_MODE_END",
	--     "ACTIVE_TALENT_GROUP_CHANGED",
	--     "UPDATE_SHAPESHIFT_FORM",
	--     "PARTY_INVITE_REQUEST",
	--     "LOADING_SCREEN_DISABLED"
	-- )
	local function addonReader(...)
	    function DBM:AddMsg(text, prefix)
	        prefix = prefix or (self.localization and self.localization.general.name) or "Deadly Boss Mods"
	        local frame = _G[tostring(DBM.Options.ChatFrame)]
	        print("!!")
	        frame = frame and frame:IsShown() and frame or DEFAULT_CHAT_FRAME
	        frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(prefix), tostring(text)), 0.41, 0.8, 0.94)
	    end
	    print(...)
	end
	--Frame:SetScript("OnEvent", addonReader)

	---------------------------
	--[[ Combat Log Reader --]]
	local superReaderFrame = CreateFrame('Frame')
	superReaderFrame:RegisterEvent("PLAYER_TOTEM_UPDATE")
	superReaderFrame:RegisterEvent("UNIT_AURA")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")

	superReaderFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	local function SuperReader(self,event,...)

		-------------------------------------------------
		---------------------------------
		-- Bad Robot Unit Aura Events, seems that buffs are added the same time as cast success
		---------------------------------
		if event == "UNIT_AURA" then
			local SourceUnit 	= select(1,...)
					
			if SourceUnit == "player" then
				--print("Aura Changed : " ..GetTime())
			end
		end
		---------------------------------
		-- Bad Robot Spell Events
		---------------------------------
		if event == "UNIT_SPELLCAST_SENT" then
			local SourceUnit 	= select(1,...)
			local SpellName 	= select(2,...)
			local SpellCastTarget 	= select(4,...)
			local SpellID 		= select(7,GetSpellInfo("SpellName"))

			
			if SourceUnit == "player" then
				spellcast:insertSpellCastSent(SpellID, GetTime(), SpellCastTarget)
				print("Unit Sent : " ..GetTime())
			end
		end

		if event == "UNIT_SPELLCAST_START" then
			local SourceUnit 	= select(1,...)
			local SpellLinID 	= select(4,...)
			local SpellID 	= select(5,...)

			if SourceUnit == "player" then
				spellcast:insertSpellCastStart(SpellID, GetTime())
			end
		end

		if event == "UNIT_SPELLCAST_SUCCEEDED" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
				spellcast:insertSpellCastSucceeded(SpellID, GetTime())
			end
		end
		
		if event == "UNIT_SPELLCAST_INTERRUPTED" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
				spellcast:insertSpellCastInterrupted(SpellID, GetTime())
			end
		end

		if event == "UNIT_SPELLCAST_STOP" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
				spellcast:insertSpellCastStop(SpellID, GetTime())
			end
		end
		
		if event == "UNIT_SPELLCAST_FAILED" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			
			if SourceUnit == "player" then
				spellcast:insertSpellCastFailed(SpellID, GetTime())		
			end
		end			

		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
				spellcast:insertSpellChannelStart(SpellID, GetTime())
				--print("Channel Start")
			end
		end

		if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
				spellcast:insertSpellChannelStopp(SpellID, GetTime())
				--print("Channel STOP")
			end
		end

		if event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
			local SourceUnit 	= select(1,...)
			local SpellID 		= select(5,...)
			if SourceUnit == "player" then
				spellcast:insertSpellChannelUpdate(SpellID, GetTime())
				--print("Channel Update")
			end
		end

		if event == "SPELL_FAILED_IMMUNE" then
			local SourceUnit	= select(1,...)
			local SpellID 		= select(5,...)
		end
	end
	superReaderFrame:SetScript("OnEvent", SuperReader)
end