function playerinit() -- Init Player Object

	local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
    --local UnitBuffID,isInMelee,getSpellCD,getEnemies = UnitBuffID,isInMelee,getSpellCD,getEnemies
    --local player,BadBoy_data,GetShapeshiftForm,dynamicTarget = "player",BadBoy_data,GetShapeshiftForm,dynamicTarget
    --local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
    --local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
    --local getGround,canCast,isKnown,enemiesTable,sp = getGround,canCast,isKnown,enemiesTable,core.spells
    --local UnitHealth,previousJudgmentTarget,print,UnitHealthMax = UnitHealth,previousJudgmentTarget,print,UnitHealthMax
    --local getDistance,getDebuffRemain,GetTime,getFacing = getDistance,getDebuffRemain,GetTime,getFacing
    --local spellCastersTable,enhancedLayOnHands,getOptionCheck = bb.im.casters,enhancedLayOnHands,getOptionCheck
    --local useItem,shouldCleanseDebuff,castBlessing = useItem,shouldCleanseDebuff,castBlessing


	if player then
		print("Already Created Player Once")
		return false
	end
	
	local playerinit = {
	    health 			= getHealth("player"),
	    hp 				= getHP("player"),
	    mana  			= getMana("player")
	    inCombat = false,
	    combatStarted = 0,
	    globalCooldown = 0,
	    buff = { },
	    spell = { },
	    glyph = { },
	    talent = { },
	    }
	    -- Set it to global variable
        player = playerinit
        -- localise commonly used functions
       

        -- no external access after here
        setfenv(1, player)

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
        -----------------------------------
    	-- Player Update : Should only be done from time to time, alot of the information should be updated by events, not scanning all of the variables. Some Information is not perhaps easy to get tough.
    	-----------------------------------
    	function player:update()
			-- player stats
			--self.health = getHP(player)
			        
			-- Buffs
			--self.buff.ardentDefender = getBuffRemain(player,self.spell.ardentDefender)
			    
			-- Cooldowns
			--self.cd.avengingWrath = getSpellCD(self.spell.avengingWrath)

			--self.globalCooldown = getSpellCD(61304)
			    
			--self.inCombat = true
	    end
	    
	    --function player:...
	    --end
    end
end