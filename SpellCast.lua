print("SpellCast loaded")
spellcast = {}

-- Todo : Order is Sent, start,with 50 ms difference, interrupt and stop is the same time, then 3 interrupts later after 5 ms

------------------
-- Cast Sent, is always when we cast or channel a spell, its when we send the request to the server. When casting a non instant spell Cast Start occures 40 ms after
							-- We should investigate what the diff is due on
------------------
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
