-- Interrupts Manager(im)
-- By CodeMyLife

-- This interupt reader intend to take as few ressources as possible while giving a lot of possibilities.
-- The frame (bb.im) is the only global variable and is nested in bb global.
-- As of now, many profiles use castInterrupt. This is not the only way to get into the manager but we should tune castInterrupt if needed rather than getting directly into the table.
-- castInterrupt is currently linked to bb.im.castInterrupt so no rework should be needed profiles side.

-- define main frame
bb.im = CreateFrame('Frame')
-- local the frame while we load it.
local im = bb.im
im:RegisterEvent("PLAYER_REGEN_ENABLED") -- wipe when we get out of combat(its needed because enemiesTable will also be cleared)
im:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") -- pulse when combat log events occurs
local function spellCastListener(self,category,...)
	-- if event is a combatlog event
	if category == "COMBAT_LOG_EVENT_UNFILTERED" then
		-- prevent nils of bot not started
		if enemiesTable == nil then
			return false
		end
		-- commonly used locals inside listener
		local event = select(2,...)
		local sourceGUID = select(4,...)
		local spellID = select(12,...)
		local unitType = select(1,strsplit("-", sourceGUID or ""))
		-- make sure it is a spell cast
		if event == "SPELL_CAST_START" then
			-- refresh enemies with current enemiesTable
		    im.enemiesTable = enemiesTable
		    -- manage cast
		    return im:manageCast(...)
		end
		-- if its a success cast, remove unit from the casters
		if event == "SPELL_CAST_SUCCESS" then
			if unitType == "Creature" then
			-- unitType == "Player"
				return im:removeCaster(sourceGUID," has finished casting.")
			end
		end
		-- if it has been interrupt, remove unit from the casters
		if event == "SPELL_INTERRUPT" then
			return im:removeCaster(sourceGUID," has been interrupted.1")
		end
	-- if event is player regen enabled
	end
end
-- pulse frame on event
im:SetScript("OnEvent",spellCastListener)

-- function to compare spells to casting units
function castInterrupt(spell,percent,keepInfo)
	return im.castInterrupt(spell,percent,keepInfo)
end

-- local that will be used inside function environment
local canCast = canCast
local castSpell = castSpell
local getDistance = getDistance
local getOptionCheck = getOptionCheck
local getOptionValue = getOptionValue
local getRealDistance = getRealDistance
local getSpellCD = getSpellCD
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local getUnitID = getUnitID
local print = print
local ObjectExists,ObjectPosition = ObjectExists,ObjectPosition
local select = select
local tinsert,tremove,sort = tinsert,tremove,table.sort
local UnitCastingInfo,UnitChannelInfo = UnitCastingInfo,UnitChannelInfo
local interruptCandidates = interruptCandidates


-- no external access after here
setfenv(1,im)

-- uncomment these to see debug
-- showDebug = true
-- showForced = true

-- this will be the local casters table stored as upvalue
casters = { }

function castAoEInterrupt(spell,targets,radius)
	-- first make sure we will be able to cast the spell
	if canCast(spell,false,false) == true and #casters > 0 then
		-- ToDo if the user sets its selector to target, only interupt current target.
		local selectedMode,selectedTargets = getOptionValue("Interrupts Handler"),{}
		if selectedMode == 1 then
			selectedTargets = { "target" }
		elseif selectedMode == 2 then
			selectedTargets = { "target","mouseover","focus" }
		elseif selectedMode == 3 then
			selectedTargets = { "target","mouseover" }
		end
		-- make sure we cover melee range
		local allowedDistance = select(6,GetSpellInfo(spell))
		if allowedDistance < 5 then
			allowedDistance = 5
		end
		-- define castersAround for each casters
		getCastersAround(radius)
		-- iterate casters and find best occurance to cast on
		local bestAoEInterruptTarget,bestAoEInterruptUnits = casters[1].unit,0
		for i = 1, #casters do
			if GetObjectExists(casters[i].unit) then
				local thisCaster = casters[i]
				if selectedMode == 4 or isSelectedTarget(thisCaster.guid) then
					-- make sure unit is in a cluster > targets
					if thisCaster.castersAround > targets then
						-- see if we are in range
						if getDistance("player",thisCaster.unit) < allowedDistance then
							if thisCaster.castersAround > bestAoEInterruptUnits then
								bestAoEInterruptTarget = thisCaster.unit
								bestAoEInterruptUnits = thisCaster.castersAround
							end
						end
					end
				end
			end
		end
		if bestAoEInterruptUnits > targets and GetObjectExists(bestAoEInterruptTarget) then
			if castSpell(bestAoEInterruptTarget,spell,false,false) then
				im:debug("Cast AoE Interrupt on "..bestAoEInterruptTarget.."("..bestAoEInterruptUnits..") with "..spell..".",true)
				return true
			end
		end
	end
	return false
end

-- function to compare spells to casting units
function castInterrupt(spell,percent,keepInfo)
	-- first make sure we will be able to cast the spell
	if canCast(spell,false,false) == true then

		-- ToDo if the user sets its selector to target, only interupt current target.
		selectedMode,selectedTargets = getOptionValue("Interrupts Handler"),{ }
		if selectedMode == 1 then
			selectedTargets = { "target" }
		elseif selectedMode == 2 then
			selectedTargets = { "target","mouseover","focus" }
		elseif selectedMode == 3 then
			selectedTargets = { "target","mouseover" }
		end

		-- make sure we cover melee range
		local allowedDistance = select(6,GetSpellInfo(spell))
		if allowedDistance < 5 then
			allowedDistance = 5
		end

		for i = 1, #casters do
			if GetObjectExists(casters[i].unit) then
				local thisCaster = casters[i]
				if selectedMode == 4 or isSelectedTarget(thisCaster.guid) then
					-- make sure we can interupt this spell
					if thisCaster.canInterupt == true then
						-- see if the spell is about to be finished casting or is a channel
						local castPercent = (thisCaster.castEnd - GetTime())/thisCaster.castLenght
						if thisCaster.castType == "chan" or (getSpellCD(spell) < thisCaster.castEnd - GetTime()
						  and castPercent < (100 - percent)/100)
						  and getDistance("player",thisCaster.unit) < allowedDistance then
							if castSpell(thisCaster.unit,spell,false,false) then
								im:debug("Cast Interrupt "..thisCaster.unit.." with "..spell.." at "..castPercent,true)
								-- if developer need to keep this spell/unit combo
								if spell == 77606 then
									simulacrumSpell = thisCaster.cast
								end
								-- prevent intrupt on this target again by removing it
								tremove(casters,i)
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end

-- debug
function im:debug(message,force)
	if showDebug == true or (force == true and showForced == true) then
		return print("|cffFFDD11<|cffFF1100Interrupt Manager|cffFFDD11>|cffFFFFFF"..GetTime().."|cffFFDD11 "..message)
	end
end

-- remove unit from table via guid
function im:removeCaster(sourceGUID,message)
	for i = 1,#casters do
		if casters[i] and sourceGUID == casters[i].guid then
			im:debug("Remove "..sourceGUID..message)
			tremove(casters,i)
			break
		end
	end
end

-- this function will handle spell casts
function im:manageCast(...)
	
end

-- function to gather casters in a given radius around a given unit
function getCastersAround(radius)
	-- first gather all the units positions
	for i = 1,#casters do
		-- center unit
		local thatCaster = casters[i]
		-- dummy var
		local enemyCastersAround = 0
		-- other casters
		for j = 1,#casters do
			thisCaster = casters[j]
			-- if more than 0.25 remains on unit cast and its in range we count it
			if (thisCaster.castEnd - GetTime() > 0.25 or thisCaster.castType == "chan") and
			  getRealDistance(thatCaster,thisCaster) < radius then
				enemyCastersAround = enemyCastersAround + 1
			end
		end
		-- add castersAround
		thatCaster.castersAround = enemyCastersAround
	end
end

-- function that return frange from thisCaster to thatCaster using their stored positions
function getRealDistance(thatCaster,thisCaster)
	local thatCaster,thisCaster = thatCaster,thisCaster
	if GetObjectExists(thatCaster.unit) and UnitIsVisible(thatCaster.unit) == true
      and GetObjectExists(thisCaster.unit) and UnitIsVisible(thisCaster.unit) == true then
		local X1,Y1,Z1 = thatCaster.pos
		local X2,Y2,Z2 = thisCaster.pos
        return math.sqrt(((X2-X1)^2) + ((Y2-Y1)^2) + ((Z2-Z1)^2))
	else
		return 100
	end
end

-- returns name of cast/channel and casting("cast") or channelling("chan") /dump getCastingInfo("target")
function getCastingInfo(unit)
	-- if its a spell we return casting informations
	if UnitCastingInfo(unit) ~= nil then
		local unitCastName,_,_,_,unitCastStart,unitCastEnd,_,unitCastID,unitCastNotInteruptible = UnitCastingInfo(unit)
		return unitCastName,getCastLenght(unitCastStart,unitCastEnd),unitCastEnd*0.001,unitCastNotInteruptible,"cast"
	-- if its achannel we return channel info
	elseif UnitChannelInfo(unit) ~= nil then
		local unitCastName,_,_,_,unitCastStart,unitCastEnd,_,unitCastID,unitCastNotInteruptible = UnitChannelInfo(unit)
		return unitCastName,getCastLenght(unitCastStart,unitCastEnd),unitCastEnd*0.001,unitCastNotInteruptible,"chan"
	-- otherwise we return bad dummy vars
	else
		return false,250,250,true,"nothing"
	end
end
-- casting informations
function getCastLenght(castStart,castEnd)
	return (castEnd-castStart)*0.001
end
function getTimeUntilCastEnd(castEnd)
	return math.floor((castEnd*0.001 - GetTime())*100)*0.01
end

-- check if a unit is a casting candidate according to its unitID and its current spell cast
function isInteruptCandidate(Unit,SpellID)
	local unitID = getUnitID(Unit)
	for i = 1,#interruptCandidates do
		thisCandidate = interruptCandidates[i]
		if thisCandidate.unitID == 0 or unitID == thisCandidate.unitID then
			if thisCandidate.spell == 0 or GetSpellInfo(SpellID) == GetSpellInfo(thisCandidate.spell) then
				im:debug(Unit.." has been found in the candidates list.")
				return true
			end
		end
	end
	im:debug(Unit.." has not been found in the candidates list.")
	return false
end

-- see if we should prioritize these targets
function isSelectedTarget(casterGUID)
	for i = 1, #selectedTargets do
		if UnitGUID(selectedTargets[i]) == casterGUID then
			return true
		end
	end
	return false
end