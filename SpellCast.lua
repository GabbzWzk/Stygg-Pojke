print("SpellCast loaded")
spellcast = {}

-- Todo : Order is Sent, start,with 50 ms difference, interrupt and stop is the same time, then 3 interrupts later after 5 ms

------------------
-- Cast Sent, is always when we cast or channel a spell, its when we send the request to the server. When casting a non instant spell Cast Start occures 40 ms after
							-- We should investigate what the diff is due on
------------------

-- castSpell("target",12345,true)
--                ( 1  ,    2  ,     3     ,     4       ,      5    ,   6     ,   7     ,    8       ,   9    )
function castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip,DeadCheck,DistanceSkip,usableSkip)
	if GetObjectExists(Unit) and betterStopCasting(SpellID) ~= true
      and (not UnitIsDeadOrGhost(Unit) or DeadCheck) then
		-- we create an usableSkip for some specific spells like hammer of wrath aoe mode
        if usableSkip == nil then
            usableSkip = false
        end
        -- stop if not enough power for that spell
		if usableSkip ~= true and IsUsableSpell(SpellID) ~= true then
			return false
		end
		-- Table used to prevent refiring too quick
	    if timersTable == nil then
	    	timersTable = {}
	    end
		-- make sure it is a known spell
		if not (KnownSkip == true or isKnown(SpellID)) then return false end
		-- gather our spell range information
		local spellRange = select(6,GetSpellInfo(SpellID))
		if DistanceSkip == nil then DistanceSkip = false end
	  	if spellRange == nil or (spellRange < 4 and DistanceSkip==false) then spellRange = 4 end
	  	if DistanceSkip == true then spellRange = 40 end
		-- Check unit,if it's player then we can skip facing
		if (Unit == nil or UnitIsUnit("player",Unit)) or -- Player
			(Unit ~= nil and UnitIsFriend("player",Unit)) then  -- Ally
            FacingCheck = true
        elseif isSafeToAttack(Unit) ~= true then -- enemy
            return false
        end
		-- if MovementCheck is nil or false then we dont check it
		if MovementCheck == false or isMoving("player") ~= true
          -- skip movement check during spiritwalkers grace and aspect of the fox
          or UnitBuffID("player",79206) ~= nil or UnitBuffID("player",172106) ~= nil or UnitBuffID("player",108839) ~= nil then
			-- if ability is ready and in range
			if getSpellCD(SpellID) == 0 and (getOptionCheck("Skip Distance Check") or getDistance("player",Unit) <= spellRange or DistanceSkip == true) then
                -- if spam is not allowed
	    		if SpamAllowed == false then
	    			-- get our last/current cast
	      			if timersTable == nil or (timersTable ~= nil and (timersTable[SpellID] == nil or timersTable[SpellID] <= GetTime() -0.6)) then
	       				if (FacingCheck == true or getFacing("player",Unit) == true) and (UnitIsUnit("player",Unit) or getLineOfSight("player",Unit) == true) then
	        				timersTable[SpellID] = GetTime()
	        				currentTarget = UnitGUID(Unit)
	        				CastSpellByName(GetSpellInfo(SpellID),Unit)
                            lastSpellCast = SpellID
                            -- change main button icon
							if getOptionCheck("Start/Stop BadRobot") then
                                mainButton:SetNormalTexture(select(3,GetSpellInfo(SpellID)))
                            end
	        				return true
	        			end
					end
				elseif (FacingCheck == true or getFacing("player",Unit) == true) and (UnitIsUnit("player",Unit) or getLineOfSight("player",Unit) == true) then
	  		   		currentTarget = UnitGUID(Unit)
					CastSpellByName(GetSpellInfo(SpellID),Unit)
					if getOptionCheck("Start/Stop BadRobot") then
						mainButton:SetNormalTexture(select(3,GetSpellInfo(SpellID)))
					end
					return true
				end
	    	end
	  	end
	end
  	return false
end

-- if canCast(12345,true)
function canCast(SpellID,KnownSkip,MovementCheck)
	local myCooldown = getSpellCD(SpellID) or 0
	local lagTolerance = getValue("Lag Tolerance") or 0
  	if (KnownSkip == true or isKnown(SpellID)) and IsUsableSpell(SpellID) and myCooldown < 0.1
   	  and (MovementCheck == false or myCooldown == 0 or isMoving("player") ~= true or UnitBuffID("player",79206) ~= nil) then
      	return true
    end
end

-- castGround("target",12345,40)
function castGround(Unit,SpellID,maxDistance)
	if UnitExists(Unit) and getSpellCD(SpellID) == 0 and getLineOfSight("player",Unit)
	  and getDistance("player",Unit) <= maxDistance then
 		CastSpellByName(GetSpellInfo(SpellID),"player")
		if IsAoEPending() then
		--local distanceToGround = getGroundDistance(Unit) or 0
		local X,Y,Z = GetObjectPosition(Unit)
			CastAtPosition(X,Y,Z) --distanceToGround
			return true
		end
 	end
 	return false
end

-- castGroundBetween("target",12345,40)
function castGroundBetween(Unit,SpellID,maxDistance)
	if UnitExists(Unit) and getSpellCD(SpellID) <= 0.4 and getLineOfSight("player",Unit) and getDistance("player",Unit) <= maxDistance then
 		CastSpellByName(GetSpellInfo(SpellID),"player")
		if IsAoEPending() then
		local X,Y,Z = GetObjectPosition(Unit)
			CastAtPosition(X,Y,Z)
			return true
		end
 	end
 	return false
end

-- if isCasting(12345,"target") then
function isCasting(SpellID,Unit)
	if GetObjectExists(Unit) and UnitIsVisible(Unit) then
		if isCasting(tostring(GetSpellInfo(SpellID)),Unit) == 1 then
			return true
		end
	else
		return false
	end
end

function spellcast:insertSpellCastSent(spellID, time, target)
	--print("Event Cast Sent : "..GetTime() .." On Target : "  ..target)
	player.currentCast = spellID
	spellbook.update(spellID, "SpellCastSent")
	--spellcast.queue[spellID].LastSent = time
end

function spellcast:insertSpellCastStart(spellID, time)
	--print("Event Cast Start : " ..GetTime())
	player.isCasting = spellID
	--queue[spellID].LastStart = time
end

function spellcast:insertSpellCastSucceeded(spellID, time)
	--print("Event Cast Success : " ..GetTime())
	player.lastCast = spellID
	spellbook.update(spellID, "SpellCastSucceeded")
	if spellID == Fireball then
		playerspellFireballInFlight = true
	end
	--spellcast.queue[spellID].lastSucceeded = time
end
function spellcast:insertSpellCastStop(spellID, time)
	--print("Event Cast Stop : " ..GetTime())
	player.isCasting = 0
	spellbook.update(spellID, "SpellCastStop")
	--spellcast.queue[spellID].LastStop = time
end
function spellcast:insertSpellCastInterrupted(spellID, time)
	--print("Event Cast Interrupt : " ..GetTime())
	player.currentCast = 0
	spellbook.update(spellID, "SpellCastInterrupted")
	--spellcast.queue[spellID].Interrupted = time
end
function spellcast:insertSpellCastFailed(spellID, time)
	--print("Event Cast Failed: " ..GetTime())
	player.currentCast = 0
	spellbook.update(spellID, "SpellCastFailed")
	--spellcast.queue[spellID].LastFailed = time
end

function spellcast:insertSpellChannelStart(spellID, time)
	--print("Event Channel Start : " ..GetTime())
	player.isCasting = spellID
	spellbook.update(spellID, "SpellChannelStart")
	--spellcast.queue[spellID].LastFailed = time
end

function spellcast:insertSpellChannelStopp(spellID, time)
	--print("Event Channel Stopp : " ..GetTime())
	player.isCasting = 0
	spellbook.update(spellID, "SpellChannelStop")
	--spellcast.queue[spellID].LastFailed = time
end

function spellcast:insertSpellChannelUpdate(spellID, time)
	--print("Event Channel Update : " ..GetTime())
	--player.currentCast = 0
	--spellcast.queue[spellID].LastFailed = time
end
