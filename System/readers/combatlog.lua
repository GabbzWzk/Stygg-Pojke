bb.class = select(3, UnitClass("player"))
bb.guid = UnitGUID("player")

-- specific reader location
bb.read = { }
bb.read.combatLog = { }
bb.read.debugTable = { }
bb.read.enraged = { }

local cl = bb.read

-- will update the bb.read.enraged list
function bb.read.enrageReader(...)
    if getOptionCheck("Enrages Handler") then
        local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
                destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
        -- here we will take all spell aura and check if we hold this aura in our enrage table
        -- if we find a match, we set the unit to whitelist with time remaining on the buff
        if param == "SPELL_AURA_APPLIED" and destName ~= nil then
            if dispellOffensiveBuffs[spell] ~= nil then
                -- find unit in engine, if its not there, dont add it.
                if destination ~= nil then
                    tinsert(bb.read.enraged, 1, {guid = destination,spellType = dispellOffensiveBuffs[spell],buffID = spell})
                end
            end
        end
        if param == "SPELL_AURA_REMOVED" then
            -- look for a match to remove
            local targets = bb.read.enraged
            if #targets > 0 then
                for i = #targets,1,-1 do
                    if targets[i].guid == destination and targets[i].buffID == spell then
                        tremove(bb.read.enraged, i)
                    end
                end
            end
        end
        -- once a buff fades or is dispelled, we want to remove it from whitelist if its there
    end
end

function bb.read.combatLog()
---------------------------
--[[ Combat Log Reader --]]
local frame = CreateFrame('Frame')
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
local function reader(self,event,...)

    local cl = bb.read
	-- this reader intend to hold all the combatlog related stuff. this is gonna be used
	-- with as few checks as possible per class/spec as in raiding environment we have already enough to check

	-- pulse common stuff for all classes
	cl:common(...)

	-- best way is to split per class so lets make a selector for it
	local class = bb.class
    if class == 1 then -- Warrior
    	cl:Warrior(...)
    elseif class == 2 then -- Paladin
    	cl:Paladin(...)
    elseif class == 3 then -- Hunter
    	cl:Hunter(...)
    elseif class == 4 then -- Rogue
    	cl:Rogue(...)
    elseif class == 5 then -- Priest
    	cl:Priest(...)
    elseif class == 6 then -- Deathknight
    	cl:Deathknight(...)
    elseif class == 7 then -- Shaman
    	cl:Shaman(...)
    elseif class == 8 then -- Mage
    	cl:Mage(...)
    elseif class == 9 then -- Warlock
    	cl:Warlock(...)
    elseif class == 10 then -- Monk
    	cl:Monk(...)
    elseif class == 11 then -- Druid
    	cl:Druid(...)
    end
end
-- add event to the reader
frame:SetScript("OnEvent", reader)

-- class functions(Alphabetically)
function cl:common(...)
    bb.read.enrageReader(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, spellType, suffixone, suffixtwo, suffixthree, suffixfour, suffifive, suffixsix, crit = ...

   

    if source == bb.guid then
	end

    ---------------------
    -- Bad Robot New Stuff
    ---------------------

    -- Added player.buff for now, later we add it for all units
    if destination == UnitGUID("player") then
        if param == "SPELL_AURA_REFRESH" then
            --print("Spell Aura Refresh "  .. spell .." " ..GetTime()) --Fired when getting Buff
            setAuras("player", spell, auratype, stacks)
        end
        
        if param == "SPELL_AURA_APPLIED" then
            --print("Spell Aura Applied "  .. spell .." " ..GetTime())
            setAuras("player", spell, auratype, stacks)
        end
        
        if param == "SPELL_AURA_APPLIED_DOSE"  then
            --print("Spell Aura Applied Dose "  .. spell .." " ..GetTime())
            setAuras("player", spell, auratype, stacks)
        end
        
        if param == "SPELL_AURA_REMOVED" then
            --print("Spell Aura Removed "  .. spell .." " ..GetTime())
            removeAuras("player", spell)
        end        
    end


    if source == bb.guid then
        -- Params 
        -- SPELL
        -- SPEL_PERIODIC
        -- SPELL_CAST_SUCCESS, 
        -- SPELL_DAMAGE, 
        -- SPELL_MISSED, 
        -- SPELL_AURA_REFRESH, 
        -- SPELL_AURA_APPLIED, 
        -- SPELL_AURA_APPLIED_DOSE, 
        -- SPELL_AURA_APPLIED_REMOVED,
        if param == "SPELL" then
            --print("Spell " .. spellName .." " ..GetTime())
        end
        if param == "SPELL_PERIODIC" then
           -- print("Spell Periodic "  .. spellName .." " ..GetTime())
            if spell == Ignite then
                --print("Fireball Spell Damage :" ..GetTime())
                --playerspellFireballInFlight = true
            end
        end
         if param == "SPELL_PERIODIC_DAMAGE" then
           -- print("Spell Periodic "  .. spellName .." " ..GetTime())
            if spell == Ignite and destination == UnitGUID("target") then -- We need to determine if this is our current target.... destination?
                print("Ignite Spell Damage :" ..suffixone .." Time : " ..GetTime())
                if suffixone ~= playerspellignitelasttick then
                    -- So the last tick and this is different, we should calculate the diff
                    -- Store the damage difference and time
                    -- This way we can see when a dip in ignite occurs and we can also see where the large ignite banks are
                    -- Each tick is 1 sec, the bank is 5 seconds? so we need to store the last 5 ticks and the time when they where added
                    -- So we now when the ticks expire, so when we have a good last tick we can cast pyrochain?
                end    
                playerspellignitelasttick = suffixone
            end
        end
        if param == "SPELL_CAST_SUCCESS"  then
            --print("Spell Cast Success "  .. spellName .." " ..GetTime())    -- 
             if spell == Fireball then
                --print("Fireball Spell Damage :" ..GetTime())
                --playerspellFireballInFlight = true
            end
        end
        if param == "SPELL_CAST_FAILED"  then
            --print("Spell Cast Failed "  .. spellName .." " ..GetTime())    -- 
            
        end
        if param == "SPELL_DAMAGE" then
           
        end
        if param == "SPELL_MISSED" then
            --print("Spell Missed "  .. spellName .." " ..GetTime())
        end
    end
    
    ---------------------
    -- Bad Robot New Stuff Ends here
    ---------------------

	-----------------------------------
	--[[ Item Use Success Recorder ]]
	if param == "SPELL_CAST_SUCCESS" and isInCombat("player") then
		if usePot == nil then
			usePot = true
		end
		if spell == 105697 then --Virmen's Bite Buff
			usePot = false
		end
		if spell == 105708 then --Healing Potions
			usePot = false
		end
	end


   ------------------
    --[[Spell Queues]]
    if getOptionCheck("Spell Queues") then
    	-----------------
    	--[[ Cast Failed --> Queue]]
       	if param == "SPELL_CAST_FAILED" then
			if _Queues[spell] ~= true and _Queues[spell] ~= nil then
				if (_Queues[spell] == false or _Queues[spell] < (GetTime() - 10)) and getSpellCD(spell) <= 3 then
					_Queues[spell] = true
					ChatOverlay("Queued "..GetSpellInfo(spell))
				end
			end
		end
		------------------
		--[[Queue Casted]]
        if param == "SPELL_CAST_SUCCESS" then
        	if source == bb.guid then
        		if _Queues == nil then _Queues = { } end
				if _Queues and _Queues[spell] ~= nil then
					if _Queues[spell] == true then
						_Queues[spell] = GetTime()
					end
				end
			end
		end
	end
end

function cl:Druid(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...
	-----------
	-- Kitty ---------------
	--[[ Bleed Recorder --]]
	if GetSpecialization() == 2 then
		-- define dot table(kitties)
	    Rip_sDamage = Rip_sDamage or {};
	    Rake_sDamage = Rake_sDamage or {}
	    --Thrash_sDamage = Thrash_sDamage or {}
		if source == bb.guid then
			function WA_calcStats()
			    local DamageMult = 1

			    local CP = GetComboPoints("player", "target")
			    if CP == 0 then CP = 5 end

			    if UnitBuffID("player",5217) then
			        DamageMult = DamageMult * 1.15
			    end

			    if UnitBuffID("player",174544) then
			        DamageMult = DamageMult * 1.4
			    end

			    WA_stats_BTactive = WA_stats_BTactive or  0
			    if UnitBuffID("player",155672) then
			        WA_stats_BTactive = GetTime()
			        DamageMult = DamageMult * 1.3
			    elseif GetTime() - WA_stats_BTactive < .2 then
			        DamageMult = DamageMult * 1.3
			    end

			    local RakeMult = 1
			    WA_stats_prowlactive = WA_stats_prowlactive or  0
			    if UnitBuffID("player",102543) then
			        RakeMult = 2
			    elseif UnitBuffID("player",5215) or UnitBuffID("player",58984) then
			        WA_stats_prowlactive = GetTime()
			        RakeMult = 2
			    elseif GetTime() - WA_stats_prowlactive < .2 then
			        RakeMult = 2
			    end

			    stats_RipTick = CP*DamageMult
			    stats_RipTick5 = 5*DamageMult
			    stats_RakeTick = DamageMult*RakeMult
			    stats_ThrashTick = DamageMult
			end
            -- snapshot on spellcast
            if spell == 1079 and param == "SPELL_CAST_SUCCESS" then
            	WA_calcStats()
                Rip_sDamage_cast = stats_RipTick
            elseif spell == 1822 and (param == "SPELL_CAST_SUCCESS" or param == "SPELL_DAMAGE" or param == "SPELL_MISSED") then
                WA_calcStats()
                Rake_sDamage_cast = stats_RakeTick
            elseif spell == 106830 and param == "SPELL_CAST_SUCCESS" then
                WA_calcStats()
                Thrash_sDamage_cast = stats_ThrashTick
            end
            -- but only record the snapshot if it successfully applied
            if spell == 1079 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
                Rip_sDamage[destination] = Rip_sDamage_cast
            elseif spell == 155722 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
                Rake_sDamage[destination] = Rake_sDamage_cast
            -- elseif spell == 106830 and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") then
            --     Thrash_sDamage[destination] = Thrash_sDamage_cast
            end
        end
    end

    -----------------------
    --[[ Moonkin ]]
    if shroomsTable == nil then
    	shroomsTable = { }
    	shroomsTable[1] = { }
    end
    if source == bb.guid and  param == "SPELL_SUMMON" and (spell == 147349 or spell == 145205) then
   		shroomsTable[1].guid = destination
   		shroomsTable[1].x = nil
   		shroomsTable[1].y = nil
   		shroomsTable[1].z = nil
    end
    if (param == "UNIT_DIED" or  param == "UNIT_DESTROYED" or GetTotemInfo(1) ~= true) and shroomsTable ~= nil and shroomsTable[1].guid == destination then
    	shroomsTable[1] = { }
    end
    if source == bb.guid and class == 11 and GetSpecialization() == 1 then
        -- Starsurge Casted
        if spell == 78674 and param == "SPELL_CAST_SUCCESS" then
            if core then
                core.lastStarsurge = GetTime()
            end
        end
    end
end

function cl:Deathknight(...)

end

function cl:Hunter(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

	--[[ Steady Focus ]]
    if spell == 77767 and param == "SPELL_CAST_SUCCESS" then
        if BadRobot_data["1stFocus"] ~= true then
            BadRobot_data["1stFocus"] = true
        else
            BadRobot_data["1stFocus"] = false
        end
    end
end

function cl:Mage(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

    if source == bb.guid then
        -- Params 
        -- SPELL
        -- SPEL_PERIODIC
        -- SPELL_CAST_SUCCESS, 
        -- SPELL_DAMAGE, 
        -- SPELL_MISSED, 
        -- SPELL_AURA_REFRESH, 
        -- SPELL_AURA_APPLIED, 
        -- SPELL_AURA_APPLIED_DOSE, 
        -- SPELL_AURA_APPLIED_REMOVED,
        if param == "SPELL" and spell == 30451 then
            --print("Spell " ..GetTime())
        end
        if param == "SPEL_PERIODIC" and spell == 30451 then
            --print("Spell Periodic " ..GetTime())
        end
        if param == "SPELL_CAST_SUCCESS" and spell == 30451 then
            --print("Spell Cast Success " ..GetTime())
        end
        if param == "SPELL_DAMAGE" and spell == 30451 then
            --print("Spell Damage " ..GetTime())
        end
        if param == "SPELL_MISSED" and spell == 30451 then
            --print("Spell Missed " ..GetTime())
        end
        if param == "SPELL_AURA_REFRESH" and spell == 36032 then
            --print("Spell Aura Refresh " ..GetTime())
        end
        if param == "SPELL_AURA_APPLIED" and spell == 36032 then
            --print("Spell Aura Applied " ..GetTime())
        end
        if param == "SPELL_AURA_APPLIED_DOSE" and spell == 36032 then
            --print("Spell Aura Applied Dose " ..GetTime())
        end
        if param == "SPELL_AURA_REMOVED" and spell == 36032 then
            --print("Spell Aura Removed " ..GetTime())
        end
    end
end

function cl:Monk(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

end

function cl:Priest(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

end

function cl:Paladin(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

    -----------------------
    --[[ Double Jeopardy ]]
    if core ~= nil and class == 2 and spell == 20271 and source == bb.guid and previousJudgmentTarget ~= destination then
        core.previousJudgmentTarget = destination
    end
end

function cl:Rogue(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

	--------------------------------------
	--[[ Pick Pocket Success Recorder ]]
	if canPickpocket == nil then
		canPickpocket = true
	end
	if param == "SPELL_CAST_SUCCESS" and spell==921 then
		canPickpocket = false
	end
end

function cl:Shaman(...) -- 7
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

    --------------------
    --[[ Fire Totem ]]
    if source == bb.guid and  param == "SPELL_SUMMON" and (spell == _SearingTotem or spell == _MagmaTotem) then
    	activeTotem = destination
    	activeTotemPosition = GetObjectPosition("player")
    end
    if param == "UNIT_DESTROYED" and activeTotem == destination then
    	activeTotem = nil
    end
end

function cl:Warlock(...) -- 9
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

	---------------------
	--[[ Pet Manager --]]
	if class == 9 then
        if source == bb.guid and param == "SPELL_CAST_SUCCESS" then
        	if spell == 688 or spell == 112866 then
        		petSummoned = 1
        		petSummonedTime = GetTime()
        	end
        	if spell == 697 or spell == 112867 then
        		petSummoned = 2
        		petSummonedTime = GetTime()
        	end
        	if spell == 691 or spell == 112869 then
        		petSummoned = 3
        		petSummonedTime = GetTime()
        	end
        	if spell == 712 or spell == 112868 then
        		petSummoned = 4
        		petSummonedTime = GetTime()
        	end
        	if spell == 30146 or spell == 112870 then
        		petSummoned = 5
        		petSummonedTime = GetTime()
        	end
		end
	end
end


function cl:Warrior(...)
    local timeStamp, param, hideCaster, source, sourceName, sourceFlags, sourceRaidFlags, destination,
            destName, destFlags, destRaidFlags, spell, spellName, _, spellType = ...

	----------------------------------
	--[[ Bleed Recorder (Warrior) --]]
	if GetSpecialization("player") == 1 then
        -- snapshot on spellcast
        if source == bb.guid and param == "SPELL_CAST_SUCCESS" then
            if spell == 115767 then
                deepWoundsCastAP = UnitAttackPower("player")
            end
        -- but only record the snapshot if it successfully applied
        elseif source == bb.guid and (param == "SPELL_AURA_APPLIED" or param == "SPELL_AURA_REFRESH") and deepWoundsCastAP ~= nil then
            if spell == 115767 then
                deepWoundsStoredAP = deepWoundsCastAP
            end
        end
    end
end

end