--------------------
-- Aura Handler
--					Class to handle all auras ingame.
--------------------
print("Auras Handler Loaded")
function getAuras(unit)
	local aurastable = {}
	if not unit then unit = "player" end

	for i=1,40 do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit,i)
		if name then
			aurastable[spellId] = { name = name, count = count, duration = duration, unitCaster = unitCaster, isStealable = isStealable }
		else
			i = 41
		end
	end
	return aurastable
end

----------------------------
-- Function to set the current Auras to the units, triggered by combat log events
--		Does not work properly, we want to inster into buff table using spellid so we dont need to iterate through
--		
----------------------------
function setAuras(unit, spellId, auratype, stacks)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit,GetSpellInfo(spellId))
	-- for now we only do player buffs, later we do it for all units
	-- Todo :  WE need to be able to insert via spellid instead of iterating through the list if possible
	if unit == "player" then
	--	player.buff.spellId = { name = name, count = count, duration = duration, unitCaster = unitCaster, isStealable = isStealable, auratype = auratype, stacks = stacks }
	end


	--if unit == "target"
	--if unit == "enemies"
end
function removeAuras(unit, spellId)
	if unit == "player" then
		--player.buff[spellId] = nil
	end
end


--- if isBuffed()
function isBuffed(UnitID,SpellID,TimeLeft,Filter)
  	if not TimeLeft then TimeLeft = 0 end
  	if type(SpellID) == "number" then SpellID = { SpellID } end
	for i=1,#SpellID do
		local spell,rank = GetSpellInfo(SpellID[i])
		if spell then
			local buff = select(7,UnitBuff(UnitID,spell,rank,Filter))
			if buff and ( buff == 0 or buff - GetTime() > TimeLeft ) then return true end
		end
	end
end


function UnitBuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitBuff(unit,spellName)
	else
		local exactSearch = strfind(strupper(filter),"EXACT")
		local playerSearch = strfind(strupper(filter),"PLAYER")
		if exactSearch then
			for i=1,40 do
				local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitBuff(unit,i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitBuff(unit,i)
						end
					end
				else
					return nil
				end
			end
		else
			return UnitBuff(unit,spellName,nil,filter)
		end
	end
end

-- if getBuffDuration("target",12345) < 3 then
function getBuffDuration(Unit,BuffID,Source)
	if UnitBuffID(Unit,BuffID,Source) ~= nil then
		return select(6,UnitBuffID(Unit,BuffID,Source))*1
	end
	return 0
end

-- if getBuffRemain("target",12345) < 3 then
function getBuffRemain(Unit,BuffID,Source)
	if UnitBuffID(Unit,BuffID,Source) ~= nil then
		return (select(7,UnitBuffID(Unit,BuffID,Source)) - GetTime())
	end
	return 0
end

-- if getBuffStacks(138756) > 0 then
function getBuffStacks(unit,BuffID,Source)
	if UnitBuffID(unit,BuffID,Source) then
		return (select(4,UnitBuffID(unit,BuffID,Source)))
	else
		return 0
	end
end



-- if getDebuffDuration("target",12345) < 3 then
function getDebuffDuration(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return select(6,UnitDebuffID(Unit,DebuffID,Source))*1
	end
	return 0
end

-- if getDebuffRemain("target",12345) < 3 then
function getDebuffRemain(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) ~= nil then
		return (select(7,UnitDebuffID(Unit,DebuffID,Source)) - GetTime())
	end
	return 0
end

-- if getDebuffStacks("target",138756) > 0 then
function getDebuffStacks(Unit,DebuffID,Source)
	if UnitDebuffID(Unit,DebuffID,Source) then
		return (select(4,UnitDebuffID(Unit,DebuffID,Source)))
	else
		return 0
	end
end
function UnitDebuffID(unit,spellID,filter)
	local spellName = GetSpellInfo(spellID)
	if filter == nil then
		return UnitDebuff(unit,spellName)
	else
		local exactSearch = strfind(strupper(filter),"EXACT")
		local playerSearch = strfind(strupper(filter),"PLAYER")

		if exactSearch then
			for i=1,40 do
				local _,_,_,_,_,_,_,buffCaster,_,_,buffSpellID = UnitDebuff(unit,i)
				if buffSpellID ~= nil then
					if buffSpellID == spellID then
						if (not playerSearch) or (playerSearch and (buffCaster == "player")) then
							return UnitDebuff(unit,i)
						end
					end
				else
					return nil
				end
			end
		else
			return UnitDebuff(unit,spellName,nil,filter)
		end
	end
end

-- if canDispel("target",SpellID) == true then
function canDispel(Unit,spellID)
  	local HasValidDispel = false
  	local ClassNum = select(3,UnitClass("player"))
	if ClassNum == 1 then --Warrior
		typesList = { }
	end
	if ClassNum == 2 then --Paladin
		typesList = { }
	end
	if ClassNum == 3 then --Hunter
		typesList = { }
	end
	if ClassNum == 4 then --Rogue
		-- Cloak of Shadows
		if spellID == 31224 then typesList = { "Poison","Curse","Disease","Magic" } end
	end
	if ClassNum == 5 then --Priest
		typesList = { }
	end
	if ClassNum == 6 then --Death Knight
		typesList = { }
	end
	if ClassNum == 7 then --Shaman
		if spellID == 51886 then typesList = { "Curse" } end -- Cleanse Spirit
	end
	if ClassNum == 8 then --Mage
		typesList = { }
	end
	if ClassNum == 9 then --Warlock
		typesList = { }
	end
	if ClassNum == 10 then --Monk
		-- Detox
		if spellID == 115450 then typesList = { "Poison","Disease" } end
		-- Diffuse Magic
		if spellID == 122783 then typesList = { "Magic" } end
	end
	if ClassNum == 11 then --Druid
		-- Remove Corruption
		if spellID == 2782 then typesList = { "Poison","Curse" } end
		-- Nature's Cure
		if spellID == 88423 then typesList = { "Poison","Curse","Magic" } end
		-- Symbiosis: Cleanse
		if spellID == 122288 then typesList = { "Poison","Disease" } end
	end
	local function ValidType(debuffType)
		if typesList == nil then
			return false
		else
	  		for i = 1,#typesList do
	  			if typesList[i] == debuffType then
	  				return true
	  			else
	  				return false
	  			end
	  		end
	  	end
  	end
	local ValidDebuffType = false
	local i = 1
  	while UnitDebuff(Unit,i) do
  		local _,_,_,_,debuffType,_,_,_,_,_,debuffid = UnitDebuff(Unit,i)
  		-- Blackout Debuffs
  		if debuffType and ValidType(debuffType)
  			and debuffid ~= 138732 --Ionization from Jin'rokh the Breaker - ptr
			and debuffid ~= 138733 --Ionization from Jin'rokh the Breaker - live
		then
  			HasValidDispel = true
  			break
  		end
  		i = i + 1
  	end
	return HasValidDispel
end

function hasBloodLust()
    if UnitBuffID("player",2825)        -- Bloodlust
    or UnitBuffID("player",80353)       -- Timewarp
    or UnitBuffID("player",32182)       -- Heroism
    or UnitBuffID("player",90355)       -- Ancient Hysteria
    or UnitBuffID("player",146555)      -- Drums of Rage
    then
        return true
    else
        return false
    end
end

-- if isDeBuffed("target",{123,456,789},2,"player") then
function isDeBuffed(UnitID,DebuffID,TimeLeft,Filter)
	if not TimeLeft then
		TimeLeft = 0
	end
	if type(DebuffID) == "number" then
		DebuffID = { DebuffID }
	end
	for i=1,#DebuffID do
		local spell,rank = GetSpellInfo(DebuffID[i])
		if spell then
			local debuff = select(7,UnitDebuff(UnitID,spell,rank,Filter))
			if debuff and ( debuff == 0 or debuff - GetTime() > TimeLeft ) then
				return true
			end
		end
	end
end

--if isLongTimeCCed("target") then
-- CCs with >=20 seconds
function isLongTimeCCed(Unit)
	if Unit == nil then
		return false
	end
	local longTimeCC = {
		339,	-- Druid - Entangling Roots
		102359,	-- Druid - Mass Entanglement
		1499,	-- Hunter - Freezing Trap
		19386,	-- Hunter - Wyvern Sting
		118,	-- Mage - Polymorph
		115078,	-- Monk - Paralysis
		20066,	-- Paladin - Repentance
		10326,	-- Paladin - Turn Evil
		9484,	-- Priest - Shackle Undead
		605,	-- Priest - Dominate Mind
		6770,	-- Rogue - Sap
		2094,	-- Rogue - Blind
		51514,	-- Shaman - Hex
		710,	-- Warlock - Banish
		5782,	-- Warlock - Fear
		5484,	-- Warlock - Howl of Terror
		115268,	-- Warlock - Mesmerize
		6358,	-- Warlock - Seduction
	}
	for i=1,#longTimeCC do
		--local checkCC=longTimeCC[i]
		if UnitDebuffID(Unit,longTimeCC[i])~=nil then
			return true
		end
	end
	return false
end