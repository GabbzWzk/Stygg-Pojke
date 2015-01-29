-------------------------------------------------------------------------------------
-- BadRobots Unit Handler, based on teh work of Bubba(BadRobotNova) and CodeMyLife
-------------------------------------------------------------------------------------
if not BadRobotmetaTable then

	-- localizing the commonly used functions while inside loops
	local getDistance,tinsert,tremove,UnitGUID,UnitClass,UnitIsUnit = getDistance,tinsert,tremove,UnitGUID,UnitClass,UnitIsUnit
	local UnitDebuff,UnitExists,UnitHealth,UnitHealthMax = UnitDebuff,UnitExists,UnitHealth,UnitHealthMax
	local GetSpellInfo,GetTime,UnitDebuffID,getBuffStacks = GetSpellInfo,GetTime,UnitDebuffID,getBuffStacks

	BadRobotNova = {} -- This is our main Table that the world will see
	BadRobotmemberSetup = {} -- This is one of our MetaTables that will be the default user/contructor
	BadRobotmemberSetup.cache = { } -- This is for the cache Table to check against
	BadRobotmetaTable = {} -- This will be the MetaTable attached to our Main Table that the world will see

	BadRobotmetaTable.__call = function(_, ...) -- (_, forceRetable, excludePets, onlyInRange) [Not Implemented]
		local group =  IsInRaid() and "raid" or "party" -- Determining if the UnitID will be raid or party based
		local groupSize = IsInRaid() and GetNumGroupMembers() or GetNumGroupMembers() - 1 -- If in raid, we check the entire raid. If in party, we remove one from max to account for the player.
		if group == "party" then tinsert(BadRobotNova, BadRobotmemberSetup:new("player")) end -- We are creating a new User for player if in a Group
		for i=1, groupSize do -- start of the loop to read throught the party/raid
			local groupUnit = group..i
			local groupMember = BadRobotmemberSetup:new(groupUnit)
			if groupMember then tinsert(BadRobotNova, groupMember) end -- Inserting a newly created Unit into the Main Frame
		end
	end

	BadRobotmetaTable.__index =  {-- Setting the Metamethod of Index for our Main Table
		name = "Healing Table",
		author = "Bubba",
	}

	-- Creating a default Unit to default to on a check
	BadRobotmemberSetup.__index = {
		name = "noob",
		hp = 100,
		unit = "noob",
		role = "NOOB",
		range = false,
		guid = 0,
		guidsh = 0,
		class = "NONE",
	}

	-- If ever somebody enters or leaves the raid, wipe the entire Table
	local updateHealingTable = CreateFrame("frame", nil)
	updateHealingTable:RegisterEvent("GROUP_ROSTER_UPDATE")
	updateHealingTable:SetScript("OnEvent", function()
		table.wipe(BadRobotNova)
		table.wipe(BadRobotmemberSetup.cache)
		SetupTables()
	end)

	-- This is for those NPC units that need healing. Compare them against our list of Unit ID's
	local function SpecialHealUnit(tar)
		for i=1, #novaEngineTables.SpecialHealUnitList do
			if getGUID(tar) == novaEngineTables.SpecialHealUnitList[i] then
				return true
			end
		end
	end

	-- We are checking if the user has a Debuff we either can not or don't want to heal them
	local function CheckBadDebuff(tar)
		for i=1, #novaEngineTables.BadDebuffList do
			if UnitDebuff(tar, GetSpellInfo(novaEngineTables.BadDebuffList[i])) or UnitBuff(tar, GetSpellInfo(novaEngineTables.BadDebuffList[i])) then
				return false
			end
		end
		return true
	end

	local function CheckCreatureType(tar)
		local CreatureTypeList = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
		for i=1, #CreatureTypeList do
			if UnitCreatureType(tar) == CreatureTypeList[i] then return false end
		end
		if not UnitIsBattlePet(tar) and not UnitIsWildBattlePet(tar) then return true else return false end
	end

	-- Verifying the target is a Valid Healing target
	function HealCheck(tar)
		if ((UnitIsVisible(tar)
		  and not UnitIsCharmed(tar)
		  and UnitReaction("player",tar) > 4
		  and not UnitIsDeadOrGhost(tar)
		  and UnitIsConnected(tar))
		  or novaEngineTables.SpecialHealUnitList[tonumber(select(2,getGUID(tar)))] ~= nil	or (getOptionCheck("Heal Pets") == true and UnitIsOtherPlayersPet(tar) or UnitGUID(tar) == UnitGUID("pet")))
		  and CheckBadDebuff(tar)
		  and CheckCreatureType(tar)
		  and getLineOfSight("player", tar)
		then return true
		else return false end
	end

	function BadRobotmemberSetup:new(unit)
		-- Seeing if we have already cached this unit before
		if BadRobotmemberSetup.cache[getGUID(unit)] then return false end
		local o = {}
		setmetatable(o, BadRobotmemberSetup)
		if unit and type(unit) == "string" then
			o.unit = unit
		end

		-- This is the function for Dispel checking built into the player itself.
		function o:Dispel()
			for i = 1, #novaEngineTables.DispelID do
				if UnitDebuff(o.unit,GetSpellInfo(novaEngineTables.DispelID[i].id)) ~= nil and novaEngineTables.DispelID[i].id ~= nil then
					if select(4,UnitDebuff(o.unit,GetSpellInfo(novaEngineTables.DispelID[i].id))) >= novaEngineTables.DispelID[i].stacks then
						if novaEngineTables.DispelID[i].range ~= nil then
							if #getAllies(o.unit,novaEngineTables.DispelID[i].range) > 1 then
								return false
							end
						end
						return true
					end
				end
			end
			return false
		end

		-- We are checking the HP of the person through their own function.
		function o:CalcHP()
			-- Place out of range players at the end of the list -- replaced range to 40 as we should be using lib range
 			if not UnitInRange(o.unit) and getDistance(o.unit) > 40 and not UnitIsUnit("player", o.unit) then
 				return 250,250,250
 			end
			-- Place Dead players at the end of the list
			if HealCheck(o.unit) ~= true then
				return 250,250,250
			end
			-- incoming heals
			local incomingheals
			if getOptionCheck("No Incoming Heals") ~= true and UnitGetIncomingHeals(o.unit,"player") ~= nil then
				incomingheals = UnitGetIncomingHeals(o.unit,"player")
			else
				incomingheals = 0
			end
			-- absorbs
			local nAbsorbs
			if getOptionCheck("No Absorbs") ~= true then
				nAbsorbs = (UnitGetTotalAbsorbs(o.unit)*0.25)
			else
				nAbsorbs = 0
			end
			-- calc base + absorbs + incomings
			local PercentWithIncoming = 100 * ( UnitHealth(o.unit) + incomingheals + nAbsorbs ) / UnitHealthMax(o.unit)
			-- Using the group role assigned to the Unit
			if o.role == "TANK" then
				PercentWithIncoming = PercentWithIncoming - 5
			end
			-- Using Dispel Check to see if we should give bonus weight
			if o.dispel then
				PercentWithIncoming = PercentWithIncoming - 2
			end
			-- Using threat to remove 3% to all tanking units
			if o.threat == 3 then
				PercentWithIncoming = PercentWithIncoming - 3
			end
			-- Tank in Proving Grounds
			if o.guidsh == 72218  then
				PercentWithIncoming = PercentWithIncoming - 5
			end
			local ActualWithIncoming = ( UnitHealthMax(o.unit) - ( UnitHealth(o.unit) + incomingheals ) )
			-- Malkorok shields logic
			local SpecificHPBuffs = {
				{buff = 142865,value = select(15,UnitDebuffID(o.unit,142865))}, -- Strong Ancient Barrier (Green)
				{buff = 142864,value = select(15,UnitDebuffID(o.unit,142864))}, -- Ancient Barrier (Yellow)
				{buff = 142863,value = select(15,UnitDebuffID(o.unit,142863))}, -- Weak Ancient Barrier (Red)
			}
			if UnitDebuffID(o.unit, 142861) then -- If Miasma found
				for i = 1,#SpecificHPBuffs do -- start iteration
					if UnitDebuffID(o.unit, SpecificHPBuffs[i].buff) ~= nil then -- if buff found
						if SpecificHPBuffs[i].value ~= nil then
							PercentWithIncoming = 100 + (SpecificHPBuffs[i].value/UnitHealthMax(o.unit)*100) -- we set its amount + 100 to make sure its within 50-100 range
							break
						end
					end
				end
				PercentWithIncoming = PercentWithIncoming/2 -- no mather what as long as we are on miasma buff our life is cut in half so unshielded ends up 0-50
			end

			-- Debuffs HP compensation
			local HpDebuffs = novaEngineTables.SpecificHPDebuffs
			for i = 1, #HpDebuffs do
				local _,_,_,count,_,_,_,_,_,_,spellID = UnitDebuffID(o.unit,HpDebuffs[i].debuff)
				if spellID ~= nil and (HpDebuffs[i].stacks == nil or (count and count >= HpDebuffs[i].stacks)) then
					PercentWithIncoming = PercentWithIncoming - HpDebuffs[i].value
					break
				end
			end
			if getOptionCheck("Blacklist") == true and BadRobot_data.blackList ~= nil then
				for i = 1, #BadRobot_data.blackList do
					if o.guid == BadRobot_data.blackList[i].guid then
						PercentWithIncoming,ActualWithIncoming,nAbsorbs = PercentWithIncoming + getValue("Blacklist"),ActualWithIncoming + getValue("Blacklist"),nAbsorbs + getValue("Blacklist")
						break
					end
				end
			end
			return PercentWithIncoming,ActualWithIncoming,nAbsorbs
		end

		-- returns unit GUID
		function o:nGUID()
	  		local nShortHand = ""
	  		if UnitExists(unit) then
	    		targetGUID = UnitGUID(unit)
	    		nShortHand = UnitGUID(unit):sub(-5)
	  		end
	  		return targetGUID, nShortHand
		end

		-- Returns unit class
		function o:GetClass()
			if UnitGroupRolesAssigned(o.unit) == "NONE" then
				if UnitIsUnit("player",o.unit) then
					return UnitClass("player")
				end
				if novaEngineTables.roleTable[UnitName(o.unit)] ~= nil then
					return novaEngineTables.roleTable[UnitName(o.unit)].class
				end
			else
				return UnitClass(o.unit)
			end
		end

		-- return unit role
		function o:GetRole()
			if UnitGroupRolesAssigned(o.unit) == "NONE" then
				-- if we already have a role defined we dont scan
				if novaEngineTables.roleTable[UnitName(o.unit)] ~= nil then
					return novaEngineTables.roleTable[UnitName(o.unit)].role
				end
			else
				return UnitGroupRolesAssigned(o.unit)
			end
		end

		-- sets actual position of unit in engine, shouldnt refresh more than once/sec
		function o:GetPosition()
			if UnitIsVisible(o.unit) then
				o.refresh = GetTime()
				local x,y,z = ObjectPosition(o.unit)
				x = math.ceil(x*100)/100
				y = math.ceil(y*100)/100
				z = math.ceil(z*100)/100
				return x,y,z
			else
				return 0,0,0
			end
		end

		-- Group Number of Player: getUnitGroupNumber(1)
		function o:getUnitGroupNumber()
			-- check if in raid
			if IsInRaid() and UnitInRaid(o.unit) ~= nil then
				return select(3,GetRaidRosterInfo(UnitInRaid(o.unit)))
			end
			return 0
		end

		-- Updating the values of the Unit
		function o:UpdateUnit()
			-- assign Name of unit
			o.name = UnitName(o.unit)
			-- assign real GUID of unit
			o.guid = o:nGUID()
			-- assign unit role
			o.role = o:GetRole()
			-- subgroup number
			o.subgroup = o:getUnitGroupNumber()
			-- Short GUID of unit for the SetupTable
			o.guidsh = select(2, o:nGUID())
			-- set to true if unit should be dispelled
			o.dispel = o:Dispel(o.unit)
			-- Unit's threat situation(1-4)
			o.threat = UnitThreatSituation(o.unit)
			-- Unit HP
			o.hp = o:CalcHP()
			-- Unit Absorb
			o.absorb = select(3, o:CalcHP())
			-- Target's target
			o.target = tostring(o.unit).."target"
			-- Unit Class
			o.class = o:GetClass()
			-- Unit is player
			o.isPlayer = UnitIsPlayer(o.unit)
			-- precise unit position
			if o.refresh == nil or o.refresh < GetTime() - 1 then
				o.x,o.y,o.z = o:GetPosition()
			end
			-- add unit to setup cache
			BadRobotmemberSetup.cache[select(2, getGUID(o.unit))] = o -- Add unit to SetupTable
		end
		-- Adding the user and functions we just created to this cached version in case we need it again
		-- This will also serve as a good check for if the unit is already in the table easily
		--print(UnitName(unit), select(2, getGUID(unit)))
		BadRobotmemberSetup.cache[select(2, o:nGUID())] = o
		return o
	end

	-- Setting up the tables on either Wipe or Initial Setup
	function SetupTables() -- Creating the cache (we use this to check if some1 is already in the table)
		setmetatable(BadRobotNova, BadRobotmetaTable) -- Set the metaTable of Main to Meta
		function BadRobotNova:Update()
			-- This is for special situations, IE world healing or NPC healing in encounters
			local selectedMode,SpecialTargets = getOptionValue("Special Heal"), {}
			if getOptionCheck("Special Heal") == true then
				if selectedMode == 1 then
					SpecialTargets = { "target" }
				elseif selectedMode == 2 then
					SpecialTargets = { "target","mouseover","focus" }
				elseif selectedMode == 3 then
					SpecialTargets = { "target","mouseover" }
				else
					SpecialTargets = { "target","focus" }
				end
			end
			for p=1, #SpecialTargets do
				-- Checking if Unit Exists and it's possible to heal them
				if UnitExists(SpecialTargets[p]) and HealCheck(SpecialTargets[p]) then
					if not BadRobotmemberSetup.cache[select(2, getGUID(SpecialTargets[p]))] then
						local SpecialCase = BadRobotmemberSetup:new(SpecialTargets[p])
						if SpecialCase then
							-- Creating a new user, if not already tabled, will return with the User
							for j=1, #BadRobotNova do
								if BadRobotNova[j].unit == SpecialTargets[p] then
									-- Now we add the Unit we just created to the Main Table
									for k,v in pairs(BadRobotmemberSetup.cache) do
										if BadRobotNova[j].guidsh == k then
											BadRobotmemberSetup.cache[k] = nil
										end
									end
									tremove(BadRobotNova, j)
									break
								end
							end
						end
						tinsert(BadRobotNova, SpecialCase)
						novaEngineTables.SavedSpecialTargets[SpecialTargets[p]] = select(2,getGUID(SpecialTargets[p]))
					end
				end
			end

			for p=1, #SpecialTargets do
				local removedTarget = false
				for j=1, #BadRobotNova do
					-- Trying to find a case of the unit inside the Main Table to remove
					if BadRobotNova[j].unit == SpecialTargets[p] and (BadRobotNova[j].guid ~= 0 and BadRobotNova[j].guid ~= UnitGUID(SpecialTargets[p])) then
						tremove(BadRobotNova, j)
						removedTarget = true
						break
					end
				end
				if removedTarget == true then
					for k,v in pairs(BadRobotmemberSetup.cache) do
						-- Now we're trying to find that unit in the Cache table to remove
						if SpecialTargets[p] == v.unit then
							BadRobotmemberSetup.cache[k] = nil
						end
					end
				end
			end

			for i=1, #BadRobotNova do
				-- We are updating all of the User Info (Health/Range/Name)
				BadRobotNova[i]:UpdateUnit()
			end

			-- We are sorting by Health first
			table.sort(BadRobotNova, function(x,y)
				return x.hp < y.hp
			end)

			-- Sorting with the Role
			if getOptionCheck("Sorting with Role") then
				table.sort(BadRobotNova, function(x,y)
					if x.role and y.role then return x.role > y.role
					elseif x.role then return true
					elseif y.role then return false end
				end)
	        end
			if getOptionCheck("Special Priority") == true then
			 	if UnitExists("focus") and BadRobotmemberSetup.cache[select(2, getGUID("focus"))] then
					table.sort(BadRobotNova, function(x)
						if x.unit == "focus" then
							return true
						else
							return false
						end
					end)
				end
				if UnitExists("target") and BadRobotmemberSetup.cache[select(2, getGUID("target"))] then
					table.sort(BadRobotNova, function(x)
						if x.unit == "target" then
							return true
						else
							return false
						end
					end)
				end
				if UnitExists("mouseover") and BadRobotmemberSetup.cache[select(2, getGUID("mouseover"))] then
					table.sort(BadRobotNova, function(x)
						if x.unit == "mouseover" then
							return true
						else
							return false
						end
					end)
				end
			end
			if pulseNovaDebugTimer == nil or pulseNovaDebugTimer <= GetTime() then
				pulseNovaDebugTimer = GetTime() + 0.5
				pulseNovaDebug()
			end
            -- update these frames to current BadRobotNova values via a pulse in nova engine
		end
		-- We are creating the initial Main Table
		BadRobotNova()
	end
	-- We are setting up the Tables for the first time
	SetupTables()
end











































































































