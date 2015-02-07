-- Todo : Fix the spellname in UNIT_SPELL_SENT
-- Todo : Handle Mana Burst toggle

if select(3, UnitClass("player")) == 8 then

	function Mage() 	-- Todo : we Should create one Class Main file for all speccs. The flow is the same more or less and its better to create small changes per module then seperate modules
							-- For example the options and toggles files. They are the same but small changes, toggles should be exactly the same with rare difference.

		if currentConfig ~= "Mage Gabbz" then
			MageConfig()  	-- Class Specefic Options for now
			Toggles()		-- Toggles should be same on BadRobotlevel. We will use mages toggles as baseline and when we are done we move it to class generic
			currentConfig = "Mage Gabbz"
		end

		if not MageInit then
			spellbook:init()
			player:init()
			MageInit = true
		end

		------------------------------
		-- Manual Command: We prioritise the users input, we should use modifiers to pause the bot or somehow change the rotation, we should add / slash commands such as badrobot castspell [spellid]
		------------------------------
		if IsLeftShiftKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
			return true
		end

		-------------------------------
		-- Manuel Pause
		-------------------------------
		if IsLeftAltKeyDown() then
			return true
		end
		
		------------
		-- Checks --
		------------

		if canRun() ~= true then
			return false
		end

		------------
		-- OUT OF COMBAT, note that this should be internal functionality only or handled by a manual keypress such as leftctrl. Otherwise it is easy to get spotted as bott.
		------------
		if not UnitAffectingCombat("player") and IsLeftControlKeyDown() then
			-------------------
			-- Pre Pull Logic
			-------------------
			-- Todo : We need to create logic that we can force using manual input
			--	Prepot, Cast Arcane Blast, Arcane Orb
		end

		------------
		-- COMBAT -- , Affected by combat or manual override, cant be the same key as overriding out of combat. Manual overide for pulling, hotting etc before combat.
		------------
		if UnitAffectingCombat("player") or not UnitAffectingCombat("player") and IsLeftControlKeyDown() then

			------------
			-- Stats -- , first we get all the necessary parameters we will be using in the rotation. make sure that the naming convention follows.
			------------

				------------
				-- Player 
				------------
				-- Todo : We should create a seperate Unit Class which we then call with parameters such as "player", "target", "focus" so we get objects here that we can localise
				-- Todo : See prot pala as an example altough its not correctly designed.
				-- 			core:update() should be player:update(), so functions should be player:init() which sets up the tables and parameters, and player:update() is updating values etc where it is needed
				--			This is then not all these valeues here but rather player:update() will populate this values for use. So we can then use player.Haste, player.Buff.ArcanePower, player.Buff.ArcanePowerTimeLeft, etc
				
				player:update()
				targets:update()
				

				
				
				--Buffs
				playerBuffArcanePower			= UnitBuffID("player",ArcanePower) 
				playerBuffArcanePowerTimeLeft	= getBuffRemain("player",ArcanePower)
				playerBuffArcaneMissile			= UnitBuffID("player",ArcaneMissilesP)
				stacksArcaneMisslesP			= getBuffStacks("player",ArcaneMissilesP)
				arcaneCharge 					= Charge()

				playerBuffPyroBlast				= UnitBuffID("player",PyroblastBuff)
				playerBuffPyroBlastTimeLeft		= getBuffRemain("player",Pyroblast)

		      	playerBuffIncantersFlowDirection	= getIncantersFlowsDirection()
      			playerBuffIncantersFlowStacks		= getBuffStacks("player", IncantersFlow)


				playerBuffHeatingUp				= UnitBuffID("player",HeatingUp)
		
				--player Spells
				playerSpellPrismaticCrystalIsKnown	= isKnown(PrismaticCrystal) 
				playerSpellPrismaticCrystalCD 		= getSpellCD(PrismaticCrystal)	--Todo : Replace with this
				

				playerSpellEvocationCD				= getSpellCD(Evocation)

				isKnownOverPowered					= isKnown(Overpowered)
				isKnownArcaneOrb					= isKnown(ArcaneOrb)
				isKnownSupernova					= getTalent(5,3) --isKnown(Supernova)
				spellIncantersFlowIsKnown			= isKnown(IncantersFlow)
				
				cdArcanePower						= getSpellCD(ArcanePower)
				
				------------------
				-- Target
				------------------
				targetDebuffNetherTempest 			= UnitDebuffID("target",NetherTempest, "player")	
				targetDebuffNetherTempestTimeLeft	= getDebuffRemain("target",NetherTempest, "player")
				targetDebuffLivingBombRemain		= getDebuffRemain("target",LivingBomb, "player") or 0
      			targetNumberOfEnemiesinLBRange		= getNumberOfTargetsWithOutLivingBomb(getEnemies(target,10)) -- Variable name not correct, its viable units in range for spread

      			targetDebuffCombustionRemain		= getDebuffRemain("target",Combustion, "player") or 0
      			targetNumberOfEnemiesinCombustionRange = getNumberOfTargetsWithOutCombustion(getEnemies(target,10))
      			targetDebuffIgnite					= UnitDebuffID("target", Ignite , "player")	

				
				chargesSuperNova					= GetSpellCharges(Supernova) or 0
				reChargeSuperNova					= getRecharge(Supernova) or 0
			
      			

	
				--------------------
				-- Spellbook		-- handles the players Spells, such as CD, casttime, etc
				--------------------	
				castTimeArcaneBlast					 = select(4,GetSpellInfo(ArcaneBlast))/1000

			if cancelEvocation() then
				RunMacroText("/stopcasting")
			end
			
			if not isItOkToClipp() then
				return true
			end

			-----------------------------
			-- Rotation Here
			--	Should include : 	Defensive() 		-- Used for checking if we need to use defensive abilities on ourself or allies
			--						TargetHandling()	-- Used to get the best target(s) to attack
			--						Interrupt()			-- Used to determine if we need to interrupt something
			--						Dispell()			-- Used to determine and act if we need to dispell offensive or defensive de-buffs
			--						Rotation Selection	-- Determine what is the best rotation at the moment, AoE or singel ? Or should we just use one?
			--						Burst()				-- Determine if we should use DPS CDs
			--						Standard			-- Use standard filler rotation
			--						Opener()			-- Used before pull
			-----------------------------

			if player.isMoving  and not UnitBuffID("player", IceFloes) then
				castIceFloes()
			end	

			if BadRobot_data['Defensive'] == 2 then
				Defensive()
			end

			if BadRobot_data['Interrupt'] == 2 then
				Interrupt()
			end

			 if player.specc == 1 then -- Arcane ?
			 	if isChecked("Burn Phase") then
					if playerSpellEvocationCD < 20 then
						if ArcaneMageSingleTargetSimcraftBurn() then
							return true
						end
					end
				end
				if ArcaneMageSingleTargetSimcraftConserve() then
					return true
				end
			 
			 elseif player.specc  == 2 then -- Fire
			 	return FireSingleTarget()
			 else
			 	print("3")
			 end


			-------------------------------------
			-- Rotation Selector,	should be configurable in gui
			-------------------------------------
			-- Modes
            --self.mode.aoe = BadBoy_data["AoE"]
            --self.mode.cooldowns = BadBoy_data["Cooldowns"]
            --self.mode.defensive = BadBoy_data["Defensive"]
            --self.mode.healing = BadBoy_data["Healing"]
            --self.mode.rotation = BadBoy_data["Rota"]
			--if mode.rotation == 4 then
			--	if core.health > getValue("Max DPS HP") then
			--		rotationMode = 2
			--	elseif core.health < getValue("Max Survival HP") then
			--		rotationMode = 3
			--	else
			--		rotationMode = 1
			--	end
			--else
			--	rotationMode = mode.rotation
			--end
			
               
			-- AoE Handler, single, AoE or auto
			
			
		end
	end
end