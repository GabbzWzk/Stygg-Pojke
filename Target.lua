-----------------------------------
-- target Class : 
-----------------------------------
print("Target")
targets = {}


-----------------------------------
-- target Imit : 
-----------------------------------
function targets:init() -- Init Target Object
	--local getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks = getHP,hasGlyph,UnitPower,getBuffRemain,getBuffStacks
    --local UnitBuffID,isInMelee,getSpellCD,getEnemies = UnitBuffID,isInMelee,getSpellCD,getEnemies
    --local target,BadBoy_data,GetShapeshiftForm,dynamicTarget = "target",BadBoy_data,GetShapeshiftForm,dynamicTarget
    --local GetSpellCooldown,select,getValue,isChecked,castInterrupt = GetSpellCooldown,select,getValue,isChecked,castInterrupt
    --local isSelected,UnitExists,isDummy,isMoving,castSpell,castGround = isSelected,UnitExists,isDummy,isMoving,castSpell,castGround
    --local getGround,canCast,isKnown,enemiesTable,sp = getGround,canCast,isKnown,enemiesTable,core.spells
    --local UnitHealth,previousJudgmentTarget,print,UnitHealthMax = UnitHealth,previousJudgmentTarget,print,UnitHealthMax
    --local getDistance,getDebuffRemain,GetTime,getFacing = getDistance,getDebuffRemain,GetTime,getFacing
    --local spellCastersTable,enhancedLayOnHands,getOptionCheck = bb.im.casters,enhancedLayOnHands,getOptionCheck
    --local useItem,shouldCleanseDebuff,castBlessing = useItem,shouldCleanseDebuff,castBlessing
	
	targets.healthMax        = UnitMaxHealth("target")
    targets.health 			= UnitHealth("target")
	targets.hp 				= getHP("target")
    targets.mana             = getMana("target")             -- Power can be used for boss abilites
    targets.haste            = GetHaste()
    targets.inCombat         = false
    targets.combatStarted    = 0
    targets.globalCooldown   = 0
    targets.isMoving         = isMoving("target")
	targets.buff             = { }
	--target.spell.xx            =                            -- Should list abilites for units, ie boss abilities and we could use that as part of the rotation
	targets.isCasting        = 0
    targets.currentCast      = 0
    targets.lastCast         = 0
    targets.ttd              = 0
        
end
-----------------------------------
-- target Update : Should only be done from time to time, alot of the information should be updated by events, not scanning all of the variables. Some Information is not perhaps easy to get tough.
-----------------------------------
function targets:update()
    target.isMoving         = isMoving("target")
    target.health           = UnitHealth("target")
    target.hp               = getHP("target")
    target.mana             = getMana("target")
    target.haste            = GetHaste()  
    target.ttd              =
end
