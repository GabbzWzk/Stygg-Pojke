-----------------------------------
-- Player Class : Holds all information and functionality regarding the player.
--                  This is a beta or even alpha version and it should be designed and developed with the mindset that it will be used as foundation for future unit class
--                  The unit class is the common object between player, enemies and friends. Ie Player, Targets and Raiders.
--                  We will try to modular the attributes into classes of thier own if possible, ie player spells is its on object: player.spell = {} and player.buffs = {}
--                  This way spells {} and buffs{} can be assiciated with other objects such as targets and raiders.
--                  
--                  Fow now alot of this information is retrieved by calling the wow client APIs but we should change into event based updates.
--                  For example player.isCombat = UnitAffectingCombat("player") should use events such as regen disabled etc. For now this is ok from an performance perspective
--                  but if we move into units then it should be event based so we dont for each unit does this update every pulse. However each init need to do "proper" fetching since we could already bee in combat.
--
-----------------------------------
print("Player Module Loaded")
player = {}


-----------------------------------
-- Player Imit : 
-----------------------------------
function player:init() -- Init Player Object should be called once
    -- Health values
	player.healthmax        = UnitMaxHealth("player")
    player.health 			= UnitHealth("player")
    player.healthlast       = UnitHealth("player")                  -- Init the same as current health
	player.hp 				= getHP("player")
    player.ttd              = 0                                     -- Set to zero since we dont have a counter for it at init
    -- Power/Mana values
    player.mana             = getMana("player")                     -- Mana Percentage  
    player.manalast         = getMana("player")                     -- At init we set what we have
    player.manatoempty      = 0                                     -- Set to zero since we dont have a counter for it at init

    player.haste            = GetHaste()    
    
    player.inCombat         = UnitAffectingCombat("player")
    player.combatStarted    = 0
    player.globalCooldown   = select(2,getSpellCD(61304))           -- Does this work?
    player.isMoving         = isMoving("player")
	player.buff             = { }
	player.spell            = spellbook:getPlayerSpells()
	player.glyph            = { }
	player.talent           = { }
    player.isCasting        = 0
    player.currentCast      = 0
    player.lastCast         = 0
    player.specc            = GetSpecialization()
    player.class            = select(3,UnitClass("player"))


	 
        -----------------
        -- spell 			-- table of spells the player has, inserted using spellid and holds meta data around the spells such as cd, buff(defined so we know that when we cast we get a buff), debuff(similiar to buff), spammable, movable, facing, etc
       	-----------------			we should move alot of the parameters from castSpell to be added here so castSpell does the look up for checks and not in the rotation
        -- Todo : call spellBook and then list all per class/specc similiar to old spellList
        --	Design
        --	spell  = {
        --				[spellid] = cd, buff, debuff, isAllowedToBeSpammed, needFacing, isCasting, lastCast, lastSent, inFlight, castTime etc.
        --				[spellid] = cd ...
        -- Use
        --	if player.spell.ArcanePower then
		--		if player.spell.ArcanePower.cd == 0 then
		--			if not player.spell.ArcanePower.inFlight then
		--	it is possible to shorten the text by doing
		--		ArcanePowerCD = player.spell.ArcanePower.cd
        
		---------------------
        -- Talents
        ---------------------
        -- talent { NetherTempest }
       	-- player.talent.NetherTempest	= isKnown(152263)
		-- self.talent. 	= 
        
        ---------------------
        -- Glyph
        ---------------------
        -- glyph { 651 }
        --self.glyph.ArcanePower = hasGlyph(651)
     	
     	----------------------
     	-- Buffs
     	----------------------

     	-- buff {
     	--			[ArcanePower] = timeLeft, stacks, 
     	--}   
        --self.buff.ArcanePower = UnitBuffID(player,self.spell.righteousFury)

        ----------------------
        -- Player functions 	-- functions for the player class, player.calcualteHP(), player.hasBuff() etc
        ----------------------
        
    	
end
-----------------------------------
-- Player Update : Should only be done from time to time, alot of the information should be updated by events, not scanning all of the variables. Some Information is not perhaps easy to get tough.
-----------------------------------
function player:update()
    --Health
    player.ttd              = 0                                     -- Need to calculate this based in current health
    player.healthlast       = player.health                         
    player.health           = UnitHealth("player")
    player.hp               = getHP("player")

    
    --Mana
    player.manalast         = player.mana
    player.mana             = getMana("player")
    player.manatoempty      = 0                                     -- Need to calculate this
    
    player.isMoving         = isMoving("player")
    player.haste            = GetHaste()  
    player.inCombat         = UnitAffectingCombat("player")         -- Should be using events
    player.globalCooldown   = select(2,getSpellCD(61304))

    -- buffs                                                        -- Should be using events but for now use old school

    -- spells                                                       -- Should be using events but for now use old school
   
    -- Buffs ToDo :  we should move this into event trigger population.
    --player.buff.ardentDefender = getBuffRemain(player,self.spell.ardentDefender)
    --player.buff.righteousFury = UnitBuffID(player,self.spell.righteousFury)
   
    -- Spell Cooldowns
    --player.spell.arcanepower = getSpellCD(self.spell.avengingWrath)
    --player.spell.globalCooldown = getSpellCD(61304)
end

-----------------------------------
-- Player Close:  This function is when the player is leaving or need to be reset. Should set the player object to nil
-----------------------------------
function player:close()
    player.health           = nil
    player.hp               = nil
    player.mana             = nil
    player.haste            = nil
    player.inCombat         = nil
    player.combatStarted    = nil
    player.globalCooldown   = nil
    player.isMoving         = nil
    player.buff             = nil
    player.spell            = nil
    player.glyph            = nil
    player.talent           = nil
    player.isCasting        = nil
    player.currentCast      = nil
    player.lastCast         = nil
    player.specc            = nil
    player                  = nil -- or wipe?
end
