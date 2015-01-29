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

		-- Manual Input
		if IsLeftShiftKeyDown() or IsLeftAltKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
			if UnitGetIncomingHeals("player","player") ~= nil then
				print(" What is this ? " ..UnitGetIncomingHeals("player","player"))
			else
				print(" Its nil")
			end
			return true
		end

		------------
		-- Checks --
		------------

		-- Food/Invis Check
		if canRun() ~= true then
			return false
		end

		------------
		-- OUT OF COMBAT, note that this should be internal functionality only or handled by a manual keypress such as leftctrl. Otherwise it is easy to get spotted as bott.
		------------


		------------
		-- COMBAT -- , Affected by combat or manual override, cant be the same key as overriding out of combat. Manual overide for pulling, hotting etc before combat.
		------------
		if UnitAffectingCombat("player") or not UnitAffectingCombat("player") and IsLeftControlKeyDown() then

			------------
			-- Stats -- , first we get all the necessary parameters we will be using in the rotation. make sure that the naming convention follows.
			------------

			-- Todo : 	we could if need be set this timer based, ie every 0.5 seconds or something if we feel that FPS is dropping low.
			--			Best way would to use events to get as many parameters as possible but that is a major rework. For now we do it like this

				------------
				-- Player 
				------------
				-- Todo : We should create a seperate Unit Class which we then call with parameters such as "player", "target", "focus" so we get objects here that we can localise
				-- Todo : See prot pala as an example altough its not correctly designed.
				-- 			core:update() should be player:update(), so functions should be player:init() which sets up the tables and parameters, and player:update() is updating values etc where it is needed
				--			This is then not all these valeues here but rather player:update() will populate this values for use. So we can then use player.Haste, player.Buff.ArcanePower, player.Buff.ArcanePowerTimeLeft, etc
				playerIsMoving 					= isMoving("player")
				playerMana						= getMana("player")
				playerHaste						= GetHaste()
				
				--Buffs
				playerBuffArcanePower			= UnitBuffID("player",ArcanePower) 
				playerBuffArcanePowerTimeLeft	= getBuffRemain("player",ArcanePower)
				playerBuffArcaneMissile			= UnitBuffID("player",ArcaneMissilesP)
				stacksArcaneMisslesP			= getBuffStacks("player",ArcaneMissilesP)
				arcaneCharge 					= Charge()
				

				--player Spells
				playerSpellPrismaticCrystalIsKnown	= isKnown(PrismaticCrystal) 
				playerSpellPrismaticCrystalCD 		= getSpellCD(PrismaticCrystal)	--Todo : Replace with this
				playerSpellEvocationCD				= getSpellCD(Evocation)

				isKnownOverPowered					= isKnown(Overpowered)
				isKnownArcaneOrb					= isKnown(ArcaneOrb)
				isKnownSupernova					= isKnown(Supernova)
				
				cdArcanePower						= getSpellCD(ArcanePower)
				
				
				------------------
				-- Target
				------------------
				targetDebuffNetherTempest 			= UnitDebuffID("target",NetherTempest, "player")	
				targetDebuffNetherTempestTimeLeft	= getDebuffRemain("target",NetherTempest, "player")

				
				chargesSuperNova					= GetSpellCharges(Supernova)
				reChargeSuperNova					= getRecharge(Supernova)

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

			if isPlayerMoving and not UnitBuffID("player", IceFloes) then
				castIceFloes()
			end	

			if BadRobot_data['Defensive'] == 2 then
				Defensive()
			end

			--# Executed every time the actor is available.
			-- Todo : Add InterruptHandler actions=counterspell,if=target.debuff.casting.react, lockjaw as well
			-- Todo : Defensive CDs actions+=/cold_snap,if=health.pct<30
			-- Todo : Implement icefloes for movement actions+=/ice_floes,if=buff.ice_floes.down&(raid_event.movement.distance>0|raid_event.movement.in<action.arcane_missiles.cast_time)
			-- Todo : Rune of Power actions+=/rune_of_power,if=buff.rune_of_power.remains<cast_time
			-- Todo : actions+=/mirror_image
			-- Todo : actions+=/cold_snap,if=buff.presence_of_mind.down&cooldown.presence_of_mind.remains>75
			-- Todo : actions+=/call_action_list,name=init_crystal,if=talent.prismatic_crystal.enabled&cooldown.prismatic_crystal.up
			-- Todo : actions+=/call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&pet.prismatic_crystal.active
			--actions+=/call_action_list,name=aoe,if=active_enemies>=4

			-- Todod : fix this since its not really doing anything usefull. 
			--if getNumEnemies("player",10) > 5 then -- This is only checking for melee
			--	if BadRobot_data['AoE'] == 2 or BadRobot_data['AoE'] == 3 then -- We need to sort out the auto aoe, ie == 3 
			--		ArcaneMageAoESimcraft()
			--	end
			--end
			
			--actions+=/call_action_list,name=conserve
			if isChecked("Burn Phase") then
				-- Todo : Fix the Simcraft logic for when to start burn, atm it is hardcoded to 20 seconds before CD on Evo is up, 
										-- actions+=/call_action_list,name=burn,if=time_to_die<mana.pct*0.35*spell_haste|cooldown.evocation.remains<=(mana.pct-30)*0.3*spell_haste|(buff.arcane_power.up&cooldown.evocation.remains<=(mana.pct-30)*0.4*spell_haste)
										--if (getTimeToDie("target") < playerMana*0.35*(1/playerHaste)) or (cdEvocation <= (playerMana-30)*0.3*(1/playerHaste)) or (playerBuffArcanePower and cdEvocation <= (playerMana-30)*0.4*(1/playerHaste)) then -- 
				if playerSpellEvocationCD < 20 then
					if ArcaneMageSingleTargetSimcraftBurn() then
						return true
					end
				end
			end
			if ArcaneMageSingleTargetSimcraftConserve() then
				return true
			end
		end
	end
end