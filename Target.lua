-----------------------------------
-- target Class : 
-----------------------------------
print("Target")
targets = {}

-----------------------------------
-- target Init : 
-----------------------------------
function targets:init() -- Init Target Object
	
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
--    target.isMoving         = isMoving("target")
--    target.health           = UnitHealth("target")
--    target.hp               = getHP("target")
--    target.mana             = getMana("target")
--    target.ttd              = 0                     --Need to handle this but it need to be persistent on unit level

    -- For now we start with enemiesengine and see if it works, we should later remove the objectexisting population of the enemiestable and use event based population.
    --enemiesTable
    targets.unitsdyn30 = dynamicTarget(30,true) --CC and stun/interrupt. frostjaw and polymorph
    targets.unitsdyn40 = dynamicTarget(40,true)
    targets.unitsdyn30NotFacing = dynamicTarget(30,false) --CC and stun/interrupt. frostjaw and polymorph
    targets.unitsdyn40NotFacing = dynamicTarget(40,false)
    -- Range on Cone Of Cold, dragons breath
    -- FrostJaw, interrupt and stung 30 yards
    -- Polymorph, CC 30 yards

    -- PBAOE
    targets.nrTargetsMelee = #getEnemies("player",5) -- Used for checking if i need to blink or root people
    targets.nrTargetsArcaneExplosion = #getEnemies("player",15) -- Arcane Explosion, this is glyphed so we should check if we have the glyph or range from spellbook
    -- Frost Nova 12 yards

    
    ----------------------
    -- Conal Spells
    ----------------------
    -- Arcane Orb, very narrow cone, range 40 yards
    -- Cone of Cold
    -- Dragon Breath

    ---------------------------
    -- PBAOE Target on Enemies
    ----------------------------
    -- SuperNova 40 yard and 8 yards PBAOE
    -- Prismatic Crystal 40 yard and PBAOE 8 yards, no more damage based on nr its shared between them
    -- Nether Tempest, 40 yards dot and PBAOE 10 yards, only one dot can be active. Need to store on what target, then checking if that target is alone or not.
    -- Living Bomb, 40 yards and when expire aoe on 10 yards
    -- Blast Wave, 40 yards, on enemy or ally, 8 yards PBAOE
    -- Inferno Blast, 40 yard, spreads dots 10 yards.
    
    ----------------------------
    -- Ground Target AoE
    ----------------------------
    -- Meteor, 40 yards aoe 8 yards
    -- FlameStrike, 40 yards, yard?

    --targets.nrTargetsAroundTarget7Yards = #getEnemies(self.units.dyn5,7)

    if not UnitExists("target") or UnitIsDead("target") or UnitIsFriend("player","target") then
        TargetUnit(targets.unitsdyn40)
    end
    targetName = UnitName("target")
    targetTimeToDie = 40 --Todo need to make this correct
                
end
