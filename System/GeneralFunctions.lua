
-- if canAttack("player","target") then
function canAttack(Unit1,Unit2)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if Unit2 == nil then
		Unit2 = "target"
	end
	-- if UnitCanAttack(Unit1,Unit2) == 1 then
	-- 	return true
	-- end
	return UnitCanAttack(Unit1,Unit2)
end



function canDisarm(Unit)
	if DisarmedTarget == nil then DisarmedTarget = 0 end
	if isDisarmed == true then
		if UnitExists(Unit) and UnitGUID(Unit)~=DisarmedTarget then
			DisarmedTarget = UnitGUID(Unit)
			return false
		else
			isDisarmed = false
			return true
		end
	end
	if not isInCombat("player") or UnitExists(Unit) then
		if not isInCombat("player") or UnitGUID(Unit)~=DisarmedTarget then
			isDisarmed = false
			return true
		end
	end
end





-- canInterrupt("target",20)
function canInterrupt(unit,percentint)
    local unit = unit or "target"
    local castDuration = 0
    local castTimeRemain = 0
    local castPercent = 0 -- Possible to set hard coded value
    local channelDelay = 0.4 -- Delay to mimick human reaction time for channeled spells
    local interruptable = false
    local castType = "spellcast" -- Handle difference in logic if the spell is cast or being channeles
    if UnitExists(unit)
        and UnitCanAttack("player",unit)
        and not UnitIsDeadOrGhost(unit)
    then
        if select(6,UnitCastingInfo(unit)) and not select(9,UnitCastingInfo(unit)) then --Get spell cast time
            castStartTime = select(5,UnitCastingInfo(unit))
            castEndTime = select(6,UnitCastingInfo(unit))
            interruptable = true
            castType = "spellcast"
        elseif select(6,UnitChannelInfo(unit)) and select(8,UnitChannelInfo(unit)) then -- Get spell channel time
            castStartTime = select(5,UnitChannelInfo(unit))
            castEndTime = select(6,UnitChannelInfo(unit))
            interruptable = true
            castType = "spellchannel"
        else
            castStartTime = 0
            castEndTime = 0
            interruptable = false
        end
        if castEndTime > 0 and castStartTime > 0 then
            castDuration = (castEndTime - castStartTime)/1000
            castTimeRemain = ((castEndTime/1000) - GetTime())
            if percentint == nil and castPercent == 0 then
                castPercent = math.random(75,95) --  I am not sure that this is working,we are doing this check every pulse so its different randoms each time
            elseif percentint == 0 and castPercent == 0 then
                castPercent = math.random(75,95)
            elseif percentint > 0 then
                castPercent = percentint
            end
        else
            castDuration = 0
            castTimeRemain = 0
            castPercent = 0
        end
        if castType == "spellcast" then
        	if math.ceil((castTimeRemain/castDuration)*100) <= castPercent and interruptable == true then
            	return true
        	end
        end
        if castType == "spellchannel" then
        	if (GetTime() - castStartTime/1000) > channelDelay and interruptable == true then
        		return true
        	end
        end
        return false
    end
end

-- if canPrepare() then
function canPrepare()
	if UnitBuffID("player",104934) -- Eating (Feast)
	  or UnitBuffID("player",80169) -- Eating
	  or UnitBuffID("player",87959) -- Drinking
	  or UnitBuffID("player",11392) -- 18 sec Invis Pot
	  or UnitBuffID("player",3680) -- 15 sec Invis pot
	  or UnitBuffID("player",5384) -- Feign Death
	  or IsMounted() then
	  	return false
	else
	  	return true
	end
end

-- if canRun() then
function canRun()
	if getOptionCheck("Pause") ~= 1 then
		if getOptionCheck("Start/Stop BadRobot") and isAlive("player") then
			if SpellIsTargeting()
			  or UnitHasVehicleUI("player")
			  or (IsMounted() and getUnitID("target") ~= 56877 and not UnitBuffID("player",164222) and not UnitBuffID("player",165803))
			  or UnitBuffID("player",11392) ~= nil
			  or UnitBuffID("player",80169) ~= nil
			  or UnitBuffID("player",87959) ~= nil
			  or UnitBuffID("player",104934) ~= nil
			  or UnitBuffID("player",9265) ~= nil then -- Deep Sleep(SM)
				return nil
			else
				return true
			end
		end
	else
		ChatOverlay("|cffFF0000-BadRobot Paused-")
		return false
	end
end

-- if canUse(1710) then
function canUse(itemID)
    if hasHealthPot() then Pot = healPot; else Pot = 0 end
    local goOn = true
    local DPSPotionsSet = {
        [1] = {Buff = 105702, Item = 76093}, -- Int
        [2] = {Buff = 156423, Item = 109217}, -- Agi - Draenor
        [3] = {Buff = 105706, Item = 76095}, -- Str
        [4] = {Buff = nil,    Item = 5512}, --Healthstone
        [5] = {Buff = nil,    Item = Pot}, --Healing Pot
    }
    for i = 1, #DPSPotionsSet do
        if DPSPotionsSet[i].Item == itemID then
            if potionUsed then
                if potionUsed <= GetTime() - 60000 then
                    goOn = false
                else
                    if potionUsed > GetTime() - 60000 and potionReuse == true then
                        goOn = true
                    end
                    if potionReuse == false then
                        goOn = false
                    end
                end
            end
        end
    end
    if goOn == true and GetItemCount(itemID,false,false) > 0 then
        if select(2,GetItemCooldown(itemID))==0 then
            return true
        else
            return false
        end
    else
        return false
    end
end

-- if canTrinket(13) then
function canTrinket(trinketSlot)
	if trinketSlot == 13 or trinketSlot == 14 then
		if trinketSlot == 13 and GetInventoryItemCooldown("player",13)==0 then
			return true
		end
		if trinketSlot == 14 and GetInventoryItemCooldown("player",14)==0 then
			return true
		end
	else
		return false
	end
end


--[[castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip)
Parameter 	Value
First 	 	UnitID 			Enter valid UnitID
Second 		SpellID 		Enter ID of spell to use
Third 		Facing 			True to allow 360 degrees,false to use facing check
Fourth 		MovementCheck	True to make sure player is standing to cast,false to allow cast while moving
Fifth 		SpamAllowed 	True to skip that check,false to prevent spells that we dont want to spam from beign recast for 1 second
Sixth 		KnownSkip 		True to skip isKnown check for some spells that are not managed correctly in wow's spell book.
]]

-- getLatency()
function getLatency()
	local lag = ((select(3,GetNetStats()) + select(4,GetNetStats())) / 1000)
	if lag < .05 then
		lag = .05
	elseif lag > .4 then
		lag = .4
	end
	return lag
end






--[[           ]]   --[[           ]]    --[[           ]]
--[[           ]]   --[[           ]]    --[[           ]]
--[[]]              --[[]]        		       --[[ ]]
--[[]]   --[[  ]]	--[[           ]]          --[[ ]]
--[[]]     --[[]]	--[[]]        		       --[[ ]]
--[[           ]]   --[[           ]]          --[[ ]]
--[[           ]]   --[[           ]]          --[[ ]]

--Calculate Agility
function getAgility()
    local AgiBase,AgiStat,AgiPos,AgiNeg = UnitStat("player",2)
    local Agi = AgiBase + AgiPos + AgiNeg
    return Agi
end





function getChi(Unit)
	return UnitPower(Unit,12)
end

function getChiMax(Unit)
	return UnitPowerMax(Unit,12)
end

-- if getCombatTime() <= 5 then
function getCombatTime()
	local combatStarted = BadRobot_data["Combat Started"]
	local combatTime = BadRobot_data["Combat Time"]
	if combatStarted == nil then
		return 0
	end
	if combatTime == nil then
		combatTime = 0
	end
	if UnitAffectingCombat("player") == true then
		combatTime = (GetTime() - combatStarted)
	else
		combatTime = 0
	end
	BadRobot_data["Combat Time"] = combatTime
	return (math.floor(combatTime*1000)/1000)
end

-- if getCreatureType(Unit) == true then
function getCreatureType(Unit)
	local CreatureTypeList = {"Critter","Totem","Non-combat Pet","Wild Pet"}
	for i=1,#CreatureTypeList do
		if UnitCreatureType(Unit) == CreatureTypeList[i] then
			return false
		end
	end
	if not UnitIsBattlePet(Unit) and not UnitIsWildBattlePet(Unit) then
		return true
	else
		return false
	end
end

-- if getCombo() >= 1 then
function getCombo()
	return GetComboPoints("player")
end



-- findTarget(10,true,1)   will find closest target in 10 yard front that have more or equal to 1%hp
function findTarget(range,facingCheck,minimumHealth)
	if enemiesTable ~= nil then
		for i = 1,#enemiesTable do
			if enemiesTable[i].distance <= range then
				if FacingCheck == false or getFacing("player",enemiesTable[i].unit) == true then
					if not minimumHealth or minimumHealth and minimumHealth >= enemiesTable[i].hp then
						TargetUnit(enemiesTable[i].unit)
					end
				end
			else
				break
			end
		end
	end
end

--if getFallTime() > 2 then
function getFallTime()
	if fallStarted==nil then fallStarted = 0 end
	if fallTime==nil then fallTime = 0 end
	if IsFalling() then
		if fallStarted == 0 then
			fallStarted = GetTime()
		end
		if fallStarted ~= 0 then
			fallTime = (math.floor((GetTime() - fallStarted)*1000)/1000)
		end
	end
	if not IsFalling() then
		fallStarted = 0
		fallTime = 0
	end
	return fallTime
end



function getGUID(unit)
	local nShortHand = ""
	if UnitExists(unit) then
		if UnitIsPlayer(unit) then
			targetGUID = UnitGUID(unit)
			nShortHand = string.sub(UnitGUID(unit),-5)
  		else
		    targetGUID = string.match(UnitGUID(unit),"-(%d+)-%x+$")
  	        nShortHand = string.sub(UnitGUID(unit),-5)
		end
	end
	return targetGUID,nShortHand
end

-- if getHP("player") then
function getHP(Unit)
    if GetObjectExists(Unit) then
    	if not UnitIsDeadOrGhost(Unit) and UnitIsVisible(Unit) then
        	for i = 1,#nNova do
        		if nNova[i].guidsh == string.sub(UnitGUID(Unit),-5) then
        			return nNova[i].hp
        		end
        	end
        	if getOptionCheck("No Incoming Heals") ~= true and UnitGetIncomingHeals(Unit,"player") ~= nil then
        		return 100*(UnitHealth(Unit)+UnitGetIncomingHeals(Unit,"player"))/UnitHealthMax(Unit)
        	else
        		return 100*UnitHealth(Unit)/UnitHealthMax(Unit)
        	end
        end
    end
    return 0
end



-- if getMana("target") <= 15 then
function getMana(Unit)
	return 100 * UnitPower(Unit,0) / UnitPowerMax(Unit,0)
end

-- if getPower("target") <= 15 then
function getPower(Unit)
    local value = value
    if select(3,UnitClass("player")) == 11 or select(3,UnitClass("player")) == 4 then
        if UnitBuffID("player",135700) then
            value = 999
        elseif UnitBuffID("player",106951) then
            value = UnitPower(Unit)*2
        else
            value = UnitPower(Unit)
        end
    else
        value = 100 * UnitPower(Unit) / UnitPowerMax(Unit)
    end
    return value
end


--/dump TraceLine()
-- /dump getTotemDistance("target")
function getTotemDistance(Unit1)
	if Unit1 == nil then
		Unit1 = "player"
	end
	if activeTotem ~= nil and UnitIsVisible(Unit1) then
		for i = 1,ObjectCount() do
            --print(UnitGUID(ObjectWithIndex(i)))
            if activeTotem == UnitGUID(ObjectWithIndex(i)) then
                X2,Y2,Z2 = GetObjectPosition(ObjectWithIndex(i))
            end
		end
		local X1,Y1,Z1 = GetObjectPosition(Unit1)

		TotemDistance = math.sqrt(((X2-X1)^2)+((Y2-Y1)^2)+((Z2-Z1)^2))

		--print(TotemDistance)
		return TotemDistance
	else
		return 1000
	end
end

-- if getBossID("boss1") == 71734 then
function getBossID(BossUnitID)
	return getUnitID(BossUnitID)
end

function getUnitID(Unit)
    if GetObjectExists(Unit) and UnitIsVisible(Unit) then
        local id = select(6,strsplit("-", UnitGUID(Unit) or ""))
        return tonumber(id)
    end
    return 0
end

-- if getNumEnemies("target",10) >= 3 then
function getNumEnemies(Unit,Radius)
 	return #getEnemies(Unit,Radius)
end


-- if getTalent(8) == true then
function getTalent(Row,Column)
	return select(4,GetTalentInfo(Row,Column,GetActiveSpecGroup())) or false
end

-- if getTimeToDie("target") >= 6 then
function getTimeToDie(unit)
	unit = unit or "target"
	if thpcurr == nil then
		thpcurr = 0
	end
	if thpstart == nil then
		thpstart = 0
	end
	if timestart == nil then
		timestart = 0
	end
	if GetObjectExists(unit) and UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
		if currtar ~= UnitGUID(unit) then
			priortar = currtar
			currtar = UnitGUID(unit)
		end
		if thpstart == 0 and timestart == 0 then
			thpstart = UnitHealth(unit)
			timestart = GetTime()
		else
			thpcurr = UnitHealth(unit)
			timecurr = GetTime()
			if thpcurr >= thpstart then
				thpstart = thpcurr
				timeToDie = 999
			else
				if ((timecurr - timestart)==0) or ((thpstart - thpcurr)==0) then
					timeToDie = 999
				else
					timeToDie = round2(thpcurr/((thpstart - thpcurr) / (timecurr - timestart)),2)
				end
			end
		end
	elseif not GetObjectExists(Unit) or not UnitIsVisible(unit) or currtar ~= UnitGUID(unit) then
		currtar = 0
		priortar = 0
		thpstart = 0
		timestart = 0
		timeToDie = 0
	end
	if timeToDie==nil then
		return 999
	else
		return timeToDie
	end
end

-- if getTimeTo("target",20) < 10 then
function getTimeTo(unit,percent)
  unit = unit or "target"
  perchp = (UnitHealthMax(unit) / 100 * percent)
  if ttpthpcurr == nil then
    ttpthpcurr = 0
  end
  if ttpthpstart == nil then
    ttpthpstart = 0
  end
  if ttptimestart == nil then
    ttptimestart = 0
  end
  if GetObjectExists(unit) and UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
    if ttpcurrtar ~= UnitGUID(unit) then
      ttppriortar = currtar
      ttpcurrtar = UnitGUID(unit)
    end
    if ttpthpstart == 0 and ttptimestart == 0 then
      ttpthpstart = UnitHealth(unit)
      ttptimestart = GetTime()
    else
      ttpthpcurr = UnitHealth(unit)
      ttptimecurr = GetTime()
      if ttpthpcurr >= ttpthpstart then
        ttpthpstart = ttpthpcurr
        timeToPercent = 999
      else
        if ((timecurr - timestart)==0) or ((thpstart - thpcurr)==0) then
          timeToPercent = 999
        elseif ttpthpcurr < perchp then
          timeToPercent = 0
        else
          timeToPercent = round2((ttpthpcurr - perchp)/((ttpthpstart - ttpthpcurr) / (ttptimecurr - ttptimestart)),2)
        end
      end
    end
  elseif not GetObjectExists(Unit) or not UnitIsVisible(unit) or ttpcurrtar ~= UnitGUID(unit) then
    ttpcurrtar = 0
    ttppriortar = 0
    ttpthpstart = 0
    ttptimestart = 0
    ttptimeToPercent = 0
  end
  if timeToPercent==nil then
    return 999
  else
    return timeToPercent
  end
end

-- if getTimeToMax("player") < 3 then
function getTimeToMax(Unit)
  	local max = UnitPowerMax(Unit)
  	local curr = UnitPower(Unit)
  	local regen = select(2,GetPowerRegen(Unit))
  	if select(3,UnitClass("player")) == 11 and GetSpecialization() == 2 and isKnown(114107) then
   		curr2 = curr + 4*getCombo()
  	else
   		curr2 = curr
  	end
  	return (max - curr2) * (1.0 / regen)
end

-- if getRegen("player") > 15 then
function getRegen(Unit)
	local regen = select(2,GetPowerRegen(Unit))
	return 1.0 / regen
end

-- if getVengeance() >= 50000 then
function getVengeance()
	local VengeanceID = 0
	if select(3,UnitClass("player")) == 1 then VengeanceID = 93098 -- Warrior
	elseif select(3,UnitClass("player")) == 2 then VengeanceID = 84839 -- Paladin
	elseif select(3,UnitClass("player")) == 6 then VengeanceID = 93099 -- DK
	elseif select(3,UnitClass("player")) == 10 then VengeanceID = 120267 -- Monk
	elseif select(3,UnitClass("player")) == 11 then VengeanceID = 84840 -- Druid
	end
	if UnitBuff("player",VengeanceID) then
		return select(15,UnitAura("player",GetSpellInfo(VengeanceID)))
	end
	return 0
end

--[[]]	   --[[]]		  --[[]]		--[[           ]]
--[[]]	   --[[]]		 --[[  ]]		--[[           ]]
--[[           ]]	    --[[    ]]		--[[ ]]
--[[           ]]	   --[[      ]] 	--[[           ]]
--[[           ]]	  --[[        ]]			  --[[ ]]
--[[]]	   --[[]]	 --[[]]    --[[]]	--[[           ]]
--[[]]	   --[[]]	--[[]]      --[[]]	--[[           ]]




-- if hasGlyph(1234) == true then
function hasGlyph(glyphid)
 	for i=1,6 do
  		if select(4,GetGlyphSocketInfo(i)) == glyphid or select(6,GetGlyphSocketInfo(i)) == glyphid then
  			return true
  		end
 	end
 	return false
end

-- if hasNoControl(12345) == true then
function hasNoControl(spellID)
	local eventIndex = C_LossOfControl.GetNumEvents()
	while (eventIndex > 0) do
		local _,_,text = C_LossOfControl.GetEventInfo(eventIndex)
	-- Warrior
		if select(3,UnitClass("player")) == 1 then

		end
	-- Paladin
		if select(3,UnitClass("player")) == 2 then

		end
	-- Hunter
		if select(3,UnitClass("player")) == 3 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
	-- Rogue
		if select(3,UnitClass("player")) == 4 then

		end
	-- Priest
		if select(3,UnitClass("player")) == 5 then

		end
	-- Death Knight
		if select(3,UnitClass("player")) == 6 then
            if spellID == 49039 --Lichborne
                and (text == LOSS_OF_CONTROL_DISPLAY_CHARM
                    or text == LOSS_OF_CONTROL_DISPLAY_FEAR
                    or text == LOSS_OF_CONTROL_DISPLAY_SLEEP)
            then
                return true
            end
            if spellID == 108201 --Desecrated Ground
                and (text == LOSS_OF_CONTROL_DISPLAY_ROOT
                    or text == LOSS_OF_CONTROL_DISPLAY_SNARE)
            then
                return true
            end
		end
	-- Shaman
		if select(3,UnitClass("player")) == 7 then
			if spellID == 8143 --Tremor Totem
				and	(text == LOSS_OF_CONTROL_DISPLAY_STUN
					or text == LOSS_OF_CONTROL_DISPLAY_FEAR
					or text == LOSS_OF_CONTROL_DISPLAY_SLEEP)
			then
				return true
			end
			if spellID == 108273 --Windwalk Totem
				and (text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE)
			then
				return true
			end
		end
	-- Mage
		if select(3,UnitClass("player")) == 8 then

		end
	-- Warlock
		if select(3,UnitClass("player")) == 9 then

		end
	-- Monk
		if select(3,UnitClass("player")) == 10 then
			if text == LOSS_OF_CONTROL_DISPLAY_STUN or text == LOSS_OF_CONTROL_DISPLAY_FEAR or text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_HORROR then
				return true
			end
		end
	-- Druid
		if select(3,UnitClass("player")) == 11 then
			if text == LOSS_OF_CONTROL_DISPLAY_ROOT or text == LOSS_OF_CONTROL_DISPLAY_SNARE then
				return true
			end
		end
		eventIndex = eventIndex - 1
	end
	return false
end

--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]
	 --[[ ]]		--[[ ]]
	 --[[ ]]		--[[           ]]
	 --[[ ]]				  --[[ ]]
--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]

-- if isAlive([Unit]) == true then
function isAlive(Unit)
	local Unit = Unit or "player"
	if UnitIsDeadOrGhost(Unit) == false then
		return true
	end
end

-- isBoss()
function isBoss()
	------Boss Check------
	for x=1,5 do
	    if UnitExists("boss1") then
	        boss1 = tonumber(string.match(UnitGUID("boss1"),"-(%d+)-%x+$"))
	    else
	        boss1 = 0
	    end
	    if UnitExists("boss2") then
	        boss2 = tonumber(string.match(UnitGUID("boss2"),"-(%d+)-%x+$"))
	    else
	        boss2 = 0
	    end
	    if UnitExists("boss3") then
	        boss3 = tonumber(string.match(UnitGUID("boss3"),"-(%d+)-%x+$"))
	    else
	        boss3 = 0
	    end
	    if UnitExists("boss4") then
	        boss4 = tonumber(string.match(UnitGUID("boss4"),"-(%d+)-%x+$"))
	    else
	        boss4 = 0
	    end
	    if UnitExists("boss5") then
	        boss5 = tonumber(string.match(UnitGUID("boss5"),"-(%d+)-%x+$"))
	    else
	        boss5 = 0
	    end
	end
	BossUnits = {
	    -- Cataclysm Dungeons --
	    -- Abyssal Maw: Throne of the Tides
	    40586,-- Lady Naz'jar
	    40765,-- Commander Ulthok
	    40825,-- Erunak Stonespeaker
	    40788,-- Mindbender Ghur'sha
	    42172,-- Ozumat
	    -- Blackrock Caverns
	    39665,-- Rom'ogg Bonecrusher
	    39679,-- Corla,Herald of Twilight
	    39698,-- Karsh Steelbender
	    39700,-- Beauty
	    39705,-- Ascendant Lord Obsidius
	    -- The Stonecore
	    43438,-- Corborus
	    43214,-- Slabhide
	    42188,-- Ozruk
	    42333,-- High Priestess Azil
	    -- The Vortex Pinnacle
	    43878,-- Grand Vizier Ertan
	    43873,-- Altairus
	    43875,-- Asaad
	    -- Grim Batol
	    39625,-- General Umbriss
	    40177,-- Forgemaster Throngus
	    40319,-- Drahga Shadowburner
	    40484,-- Erudax
	    -- Halls of Origination
	    39425,-- Temple Guardian Anhuur
	    39428,-- Earthrager Ptah
	    39788,-- Anraphet
	    39587,-- Isiset
	    39731,-- Ammunae
	    39732,-- Setesh
	    39378,-- Rajh
	    -- Lost City of the Tol'vir
	    44577,-- General Husam
	    43612,-- High Prophet Barim
	    43614,-- Lockmaw
	    49045,-- Augh
	    44819,-- Siamat
	    -- Zul'Aman
	    23574,-- Akil'zon
	    23576,-- Nalorakk
	    23578,-- Jan'alai
	    23577,-- Halazzi
	    24239,-- Hex Lord Malacrass
	    23863,-- Daakara
	    -- Zul'Gurub
	    52155,-- High Priest Venoxis
	    52151,-- Bloodlord Mandokir
	    52271,-- Edge of Madness
	    52059,-- High Priestess Kilnara
	    52053,-- Zanzil
	    52148,-- Jin'do the Godbreaker
	    -- End Time
	    54431,-- Echo of Baine
	    54445,-- Echo of Jaina
	    54123,-- Echo of Sylvanas
	    54544,-- Echo of Tyrande
	    54432,-- Murozond
	    -- Hour of Twilight
	    54590,-- Arcurion
	    54968,-- Asira Dawnslayer
	    54938,-- Archbishop Benedictus
	    -- Well of Eternity
	    55085,-- Peroth'arn
	    54853,-- Queen Azshara
	    54969,-- Mannoroth
	    55419,-- Captain Varo'then

	    -- Mists of Pandaria Dungeons --
	    -- Scarlet Halls
	    59303,-- Houndmaster Braun
	    58632,-- Armsmaster Harlan
	    59150,-- Flameweaver Koegler
	    -- Scarlet Monastery
	    59789,-- Thalnos the Soulrender
	    59223,-- Brother Korloff
	    3977,-- High Inquisitor Whitemane
	    60040,-- Commander Durand
	    -- Scholomance
	    58633,-- Instructor Chillheart
	    59184,-- Jandice Barov
	    59153,-- Rattlegore
	    58722,-- Lilian Voss
	    58791,-- Lilian's Soul
	    59080,-- Darkmaster Gandling
	    -- Stormstout Brewery
	    56637,-- Ook-Ook
	    56717,-- Hoptallus
	    59479,-- Yan-Zhu the Uncasked
	    -- Tempe of the Jade Serpent
	    56448,-- Wise Mari
	    56843,-- Lorewalker Stonestep
	    59051,-- Strife
	    59726,-- Peril
	    58826,-- Zao Sunseeker
	    56732,-- Liu Flameheart
	    56762,-- Yu'lon
	    56439,-- Sha of Doubt
	    -- Mogu'shan Palace
	    61444,-- Ming the Cunning
	    61442,-- Kuai the Brute
	    61445,-- Haiyan the Unstoppable
	    61243,-- Gekkan
	    61398,-- Xin the Weaponmaster
	    -- Shado-Pan Monastery
	    56747,-- Gu Cloudstrike
	    56541,-- Master Snowdrift
	    56719,-- Sha of Violence
	    56884,-- Taran Zhu
	    -- Gate of the Setting Sun
	    56906,-- Saboteur Kip'tilak
	    56589,-- Striker Ga'dok
	    56636,-- Commander Ri'mok
	    56877,-- Raigonn
	    -- Siege of Niuzao Temple
	    61567,-- Vizier Jin'bak
	    61634,-- Commander Vo'jak
	    61485,-- General Pa'valak
	    62205,-- Wing Leader Ner'onok

	    -- Training Dummies --
	    46647,-- Level 85 Training Dummy
	    67127,-- Level 90 Training Dummy

	    -- Instance Bosses --
	    boss1,--Boss 1
	    boss2,--Boss 2
	    boss3,--Boss 3
	    boss4,--Boss 4
	    boss5,--Boss 5
	}
    local BossUnits = BossUnits

    if UnitExists("target") then
        local npcID = tonumber(string.match(UnitGUID("target"),"-(%d+)-%x+$"))--tonumber(UnitGUID("target"):sub(6,10),16)

        if (UnitClassification("target") == "rare" or UnitClassification("target") == "rareelite" or UnitClassification("target") == "worldboss" or (UnitClassification("target") == "elite" and UnitLevel("target") >= UnitLevel("player")+3) or UnitLevel("target") < 0)
            --and select(2,IsInInstance())=="none"
            and not UnitIsTrivial("target")
        then
            return true
        else
            for i=1,#BossUnits do
                if BossUnits[i] == npcID then
                    return true
                end
            end
            return false
        end
    else
        return false
    end
end



function isCastingTime(lagTolerance)
	local lagTolerance = 0
	if UnitCastingInfo("player") ~= nil then
		if select(6,UnitCastingInfo("player")) - GetTime() <= lagTolerance then
			return true
		end
	elseif UnitChannelInfo("player") ~= nil then
		if select(6,UnitChannelInfo("player")) - GetTime() <= lagTolerance then
			return true
		end
	elseif (GetSpellCooldown(GetSpellInfo(61304)) ~= nil and GetSpellCooldown(GetSpellInfo(61304)) <= lagTolerance) then
	  	return true
	else
		return false
	end
end

function getCastTimeRemain(unit)
    if UnitCastingInfo(unit) ~= nil then
        return select(6,UnitCastingInfo(unit)) - GetTime()
    elseif UnitChannelInfo(unit) ~= nil then
        return select(6,UnitChannelInfo(unit)) - GetTime()
    else
        return 0
    end
end

-- if isCasting() == true then
function castingUnit(Unit)
	if Unit == nil then Unit = "player" end
	if UnitCastingInfo(Unit) ~= nil
	  or UnitChannelInfo(Unit) ~= nil
	  or (GetSpellCooldown(61304) ~= nil and GetSpellCooldown(61304) > 0.001) then
	  	return true
    else
        return false
	end
end

-- if isCastingSpell(12345) == true then
function isCastingSpell(spellID,unit)
    if unit == nil then unit = "player" end
	local spellName = GetSpellInfo(spellID)
	local spellCasting = UnitCastingInfo(unit)

	if spellCasting == nil then
		spellCasting = UnitChannelInfo(unit)
	end
	if spellCasting == spellName then
		return true
	else
		return false
	end
end



-- UnitGUID("target"):sub(-15,-10)
-- Dummy Check
function isDummy(Unit)
	if Unit == nil then
		Unit = "target"
	end
    if UnitExists(Unit) and UnitGUID(Unit) then
	    local dummies = {
	        [87329] = "Raider's Training Dummy", -- Lvl ?? (Stormshield - Tank)
	        [88837] = "Raider's Training Dummy", -- Lvl ?? (Warspear - Tank)
	        [87320] = "Raider's Training Dummy", -- Lvl ?? (Stormshield - Damage)
			[87762] = "Raider's Training Dummy", -- Lvl ?? (Warspear - Damage)
	        [31146] = "Raider's Training Dummy", -- Lvl ?? (Ogrimmar,Stormwind,Darnassus,...)
	        [70245] = "Training Dummy", -- Lvl ?? (Throne of Thunder)
	        [88314] = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall - Tank)
	        [88288] = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall - Tank)
	        [88836] = "Dungeoneer's Training Dummy", -- Lvl 102 (Warspear - Tank)
	        [87322] = "Dungeoneer's Training Dummy ", -- Lvl 102 (Stormshield,Warspear - Tank)
	    	[87317] = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall - Damage)
	    	[87318] = "Dungeoneer's Training Dummy", -- Lvl 102 (Lunarfall - Damage)
	    	[87761] = "Dungeoneer's Training Dummy", -- Lvl 102 (Frostwall - Damage)
	    	[88906] = "Combat Dummy", -- Lvl 100 (Nagrand)
	    	[89078] = "Training Dummy", -- Lvl 100 (Lunarfall,Frostwall)
	    	[87321] = "Training Dummy", -- Lvl 100 (Stormshield,Warspear - Healing)
	    	[88835] = "Training Dummy", -- Lvl 100 (Warspear - Healing)
	    	[88967] = "Training Dummy", -- Lvl 100 (Lunarfall,Frostwall)
	    	[88316] = "Training Dummy", -- Lvl 100 (Lunarfall - Healing)
	    	[88289] = "Training Dummy", -- Lvl 100 (Frostwall - Healing)
	    	[79414] = "Training Dummy", -- Lvl 95 (Talador)
	        [67127] = "Training Dummy", -- Lvl 90 (Vale of Eternal Blossoms)
	        [46647] = "Training Dummy", -- Lvl 85 (Orgrimmar,Stormwind)
	        [32546] = "Ebon Knight's Training Dummy", -- Lvl 80 (Eastern Plaguelands)
	        [31144] = "Training Dummy", -- Lvl 80 (Orgrimmar,Darnassus,Ruins of Gileas,...)
	        [32543] = "Veteran's Training Dummy", -- Lvl 75 (Eastern Plaguelands)
	        [32667] = "Training Dummy", -- Lvl 70 (Darnassus,Silvermoon,Orgrimar,...)
	        [32542] = "Disciple's Training Dummy", -- Lvl 65 (Eastern Plaguelands)
	        [32666] = "Training Dummy", -- Lvl 60 (Orgrimmar,Ironforge,Darnassus,...)
	        [32541] = "Initiate's Training Dummy", -- Lvl 55 (Scarlet Enclave)
	        [32545] = "Initiate's Training Dummy", -- Lvl 55 (Eastern Plaguelands)
	        [60197] = "Scarlet Monastery Dummy",
	        [64446] = "Scarlet Monastery Dummy",
	    }
        if dummies[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] ~= nil then
            return true
        end
	end
end

-- if isEnnemy([Unit])
function isEnnemy(Unit)
	local Unit = Unit or "target"
	if UnitCanAttack(Unit,"player") then
		return true
	else
		return false
	end
end

--if isGarrMCd() then
function isGarrMCd(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if UnitExists(Unit)
	  and (UnitDebuffID(Unit,145832)
      or UnitDebuffID(Unit,145171)
      or UnitDebuffID(Unit,145065)
      or UnitDebuffID(Unit,145071)) then
		return true
	else
		return false
	end
end

-- if isInCombat("target") then
function isInCombat(Unit)
	if UnitAffectingCombat(Unit) then
		return true
	else
		return false
	end
end

-- if isInDraenor() then
function isInDraenor()
	local tContains = tContains
	local currentMapID = GetCurrentMapAreaID()
	local draenorMapIDs =
	{
	    962,-- Draenor
	    978,-- Ashran
	    941,-- Frostfire Ridge
	    976,-- Frostwall
	    949,-- Gorgrond
	    971,-- Lunarfall
	    950,-- Nagrand
	    947,-- Shadowmoon Valley
	    948,-- Spires of Arak
	    1009,-- Stormshield
	    946,-- Talador
	    945,-- Tanaan Jungle
	    970,-- Tanaan Jungle - Assault on the Dark Portal
	    1011,-- Warspear
	}
	if (tContains(draenorMapIDs,currentMapID)) then
		return true
	else
		return false
	end
end

-- if isInMelee() then
function isInMelee(Unit)
	if Unit == nil then
		Unit = "target"
	end
	if getDistance(Unit) < 4 then
		return true
	else
		return false
	end
end

-- if IsInPvP() then
function isInPvP()
	local inpvp = GetPVPTimer()
	if inpvp ~= 301000 and inpvp ~= -1 then
		return true
	else
		return false
	end
end



-- if isLooting() then
function isLooting()
	if GetNumLootItems() > 0 then
		return true
	else
		return false
	end
end

function getLoot2()
    if looted == nil then looted = 0 end
    if lM:emptySlots() then
        for i=1,ObjectCount() do
            if bit.band(GetObjectType(ObjectWithIndex(i)), ObjectTypes.Unit) == 8 then
                local thisUnit = ObjectWithIndex(i)
                local hasLoot,canLoot = CanLootUnit(UnitGUID(thisUnit))
                local inRange = getRealDistance("player",thisUnit) < 2
                if UnitIsDeadOrGhost(thisUnit) then
                    if hasLoot and canLoot and inRange and (canLootTimer == nil or canLootTimer <= GetTime()-0.5)--[[getOptionValue("Auto Loot"))]] then
                        if GetCVar("autoLootDefault") == "0" then
                            SetCVar("autoLootDefault", "1")
                            InteractUnit(thisUnit)
                            if isLooting() then
                                return true
                            end
                            canLootTimer = GetTime()
                            SetCVar("autoLootDefault", "0")
                            looted = 1
                            return
                        else
                            InteractUnit(thisUnit)
                            if isLooting() then
                                return true
                            end
                            canLootTimer = GetTime()
                            looted = 1
                        end
                    end
                end
            end
        end
        if UnitExists("target") and UnitIsDeadOrGhost("target") and looted==1 and not isLooting() then
            ClearTarget()
            looted=0
        end
    else
        ChatOverlay("Bags are full, nothing will be looted!")
    end
end

-- if not isMoving("target") then
function isMoving(Unit)
	if GetUnitSpeed(Unit) > 0 then
		return true
	else
		return false
	end
end

-- if IsMovingTime(5) then
function IsMovingTime(time)
	if time == nil then time = 1 end
	if GetUnitSpeed("player") > 0 then
		if IsRunning == nil then
			IsRunning = GetTime()
			IsStanding = nil
		end
		if GetTime() - IsRunning > time then
			return true
		end
	else
		if IsStanding == nil then
			IsStanding = GetTime()
			IsRunning = nil
		end
		if GetTime() - IsStanding > time then
			return false
		end
	end
end

function isPlayer(Unit)
	if UnitExists(Unit) ~= true then
		return false
	end
	if UnitIsPlayer(Unit) == true then
		return true
	elseif UnitIsPlayer(Unit) ~= true then
		local playerNPC = {
			[72218] = "Oto the Protector",
			[72219] = "Ki the Asssassin",
			[72220] = "Sooli the Survivalist",
			[72221] = "Kavan the Arcanist"
		}
		if playerNPC[tonumber(string.match(UnitGUID(Unit),"-(%d+)-%x+$"))] ~= nil then
			return true
		end
	else
		return false
	end
end

function getStandingTime()
	return DontMoveStartTime and GetTime() - DontMoveStartTime or nil
end

--
function isStanding(Seconds)
	return IsFalling() == false and DontMoveStartTime and getStandingTime() >= Seconds or false
end

-- if IsStandingTime(5) then
function IsStandingTime(time)
	if time == nil then time = 1 end
	if not IsFalling() and GetUnitSpeed("player") == 0 then
		if IsStanding == nil then
			IsStanding = GetTime()
			IsRunning = nil
		end
		if GetTime() - IsStanding > time then
			return true
		end
	else
		if IsRunning == nil then
			IsRunning = GetTime()
			IsStanding = nil
		end
		if GetTime() - IsRunning > time then
			return false
		end
	end
end



-- if isValidTarget("target") then
function isValidTarget(Unit)
	if UnitIsEnemy("player",Unit) then
		if UnitExists(Unit) and not UnitIsDeadOrGhost(Unit) then
			return true
		else
			return false
		end
	else
		if UnitExists(Unit) then
			return true
		else
			return false
		end
	end
end


-- Dem Bleeds
-- In a run once environment we shall create the Tooltip that we will be reading
-- all of the spell details from
nGTT = CreateFrame( "GameTooltip","MyScanningTooltip",nil,"GameTooltipTemplate" )
nGTT:SetOwner( WorldFrame,"ANCHOR_NONE" )
nGTT:AddFontStrings(nGTT:CreateFontString( "$parentTextLeft1",nil,"GameTooltipText" ),nGTT:CreateFontString( "$parentTextRight1",nil,"GameTooltipText" ) )
function nDbDmg(tar,spellID,player)
   	if GetCVar("DotDamage") == nil then
      	RegisterCVar("DotDamage",0)
   	end
   	nGTT:ClearLines()
   	for i=1,40 do
      	if UnitDebuff(tar,i,player) == GetSpellInfo(spellID) then
         	nGTT:SetUnitDebuff(tar,i,player)
         	scanText=_G["MyScanningTooltipTextLeft2"]:GetText()
         	local DoTDamage = scanText:match("([0-9]+%.?[0-9]*)")
   			--if not issecure() then print(issecure()) end -- function is called inside the profile
         	SetCVar("DotDamage",tonumber(DoTDamage))
         	return tonumber(GetCVar("DotDamage"))
      	end
   	end
end

-- if pause() then
function pause()
    if SpecificToggle("Pause Mode") == nil or getValue("Pause Mode") == 6 then
        pausekey = IsLeftAltKeyDown()
    else
        pausekey = SpecificToggle("Pause Mode")
    end
    if isChecked("DPS Testing")~=nil then
        if GetObjectExists("target") and isInCombat("player") then
            if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                profileStop = true
            else
                profileStop = false
            end
        elseif not isInCombat("player") and profileStop==true then
            if GetObjectExists("target") then
                StopAttack()
                ClearTarget()
                profileStop=false
            end
        end
    end
    if (pausekey and GetCurrentKeyBoardFocus() == nil)
      or profileStop
      or (IsMounted() and getUnitID("target") ~= 56877 and not UnitBuffID("player",164222) and not UnitBuffID("player",165803))
      or SpellIsTargeting()
      or (not UnitCanAttack("player","target") and not UnitIsPlayer("target") and UnitExists("target"))
      or UnitCastingInfo("player")
      or UnitChannelInfo("player")
      or UnitIsDeadOrGhost("player")
      or (UnitIsDeadOrGhost("target") and not UnitIsPlayer("target"))
      or UnitBuffID("player",80169) -- Eating
      or UnitBuffID("player",87959) -- Drinking
      or UnitBuffID("target",117961) --Impervious Shield - Qiang the Merciless
      or UnitDebuffID("player",135147) --Dead Zone - Iron Qon: Dam'ren
      or (((UnitHealth("target")/UnitHealthMax("target"))*100) > 10 and UnitBuffID("target",143593)) --Defensive Stance - General Nagrazim
      or UnitBuffID("target",140296) --Conductive Shield - Thunder Lord / Lightning Guardian
    then
        ChatOverlay("Profile Paused")
        return true
    end
end

-- feed a var
function toggleTrueNil(var)
	if _G[var] ~= true then
		_G[var] = true
	else
		_G[var] = nil
	end
end

-- useItem(12345)
function useItem(itemID)
	if GetItemCount(itemID) > 0 then
		if select(2,GetItemCooldown(itemID))==0 then
			local itemName = GetItemInfo(itemID)
			RunMacroText("/use "..itemName)
			return true
		end
	end
	return false
end



function spellDebug(Message)
	if imDebugging == true and getOptionCheck("Debugging Mode") then
		ChatOverlay(Message)
	end
end

--[[           ]]	--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]]
--[[]]				--[[]]				--[[]]
--[[]]				--[[           ]] 	--[[]]	 --[[  ]]
--[[]]				--[[		   ]]	--[[]]     --[[]]
--[[           ]]	--[[]]				--[[           ]]
--[[           ]]	--[[]]      		--[[           ]]



--[[Health Potion Table]]
function hasHealthPot()
    healthPot = { }
    for i = 1, 4 do
        for x = 1, GetContainerNumSlots(i) do
            local itemID = GetContainerItemID(i,x)
            if itemID~=nil then
                local ItemName = select(1,GetItemInfo(itemID))
                local MinLevel = select(5,GetItemInfo(itemID))
                local ItemType = select(7,GetItemInfo(itemID))
                local ItemEffect = select(1,GetItemSpell(itemID))
                if ItemType == select(7,GetItemInfo(2459)) then
                    if strmatch(ItemEffect,strmatch(tostring(select(1,GetItemSpell(76097))),"%a+")) then
                        local ItemCount = GetItemCount(itemID)
                        local ItemCooldown = GetItemCooldown(itemID)
                        if MinLevel<=UnitLevel("player") and ItemCooldown == 0 then
                            tinsert(healthPot,
                                {
                                    item = itemID,
                                    itemName = ItemName,
                                    minLevel = MinLevel,
                                    itemType = ItemType,
                                    itemEffect = ItemEffect,
                                    itemCount = ItemCount
                                }
                            )
                        end
                    end
                end
            end
            table.sort(healthPot, function(x,y)
                return x.minLevel and y.minLevel and x.minLevel > y.minLevel or false
            end)
        end
    end
    if healthPot[1]==nil then
        healPot=0
        return false
    else
        healPot=healthPot[1].item
        return true
    end
end


--[[Taunts Table!! load once]]
tauntsTable = {
	{ spell = 143436,stacks = 1 },--Immerseus/71543               143436 - Corrosive Blast                             == 1x
	{ spell = 146124,stacks = 3 },--Norushen/72276                146124 - Self Doubt                                  >= 3x
	{ spell = 144358,stacks = 1 },--Sha of Pride/71734            144358 - Wounded Pride                               == 1x
	{ spell = 147029,stacks = 3 },--Galakras/72249                147029 - Flames of Galakrond                         == 3x
	{ spell = 144467,stacks = 2 },--Iron Juggernaut/71466         144467 - Ignite Armor                                >= 2x
	{ spell = 144215,stacks = 6 },--Kor'Kron Dark Shaman/71859    144215 - Froststorm Strike (Earthbreaker Haromm)     >= 6x
	{ spell = 143494,stacks = 3 },--General Nazgrim/71515         143494 - Sundering Blow                              >= 3x
	{ spell = 142990,stacks = 12 },--Malkorok/71454                142990 - Fatal Strike                                == 12x
	{ spell = 143426,stacks = 2 },--Thok the Bloodthirsty/71529   143426 - Fearsome Roar                               == 2x
	{ spell = 143780,stacks = 2 },--Thok (Saurok eaten)           143780 - Acid Breath                                 == 2x
	{ spell = 143773,stacks = 3 },--Thok (Jinyu eaten)            143773 - Freezing Breath                             == 3x
	{ spell = 143767,stacks = 2 },--Thok (Yaungol eaten)          143767 - Scorching Breath                            == 2x
	{ spell = 145183,stacks = 3 } --Garrosh/71865                 145183 - Gripping Despair                            >= 3x
}

--[[Taunt function!! load once]]
function ShouldTaunt()

	--[[Normal boss1 taunt method]]
	if not UnitIsUnit("player","boss1target") then
	  	for i = 1,#tauntsTable do
	  		if not UnitDebuffID("player",tauntsTable[i].spell) and UnitDebuffID("boss1target",tauntsTable[i].spell) and getDebuffStacks("boss1target",tauntsTable[i].spell) >= tauntsTable[i].stacks then
	  			TargetUnit("boss1")
	  			return true
	  		end
	  	end
	end

  	--[[Swap back to Wavebinder Kardris]]
  	if getBossID("target") ~= 71858 then
  		if UnitDebuffID("player",144215) and getDebuffStacks("player",144215) >= 6 then
  			if getBossID("boss1") == 71858 then
  				TargetUnit("boss1")
  				return true
  			else
  				TargetUnit("boss2")
  				return true
  			end
  		end
  	end
end
