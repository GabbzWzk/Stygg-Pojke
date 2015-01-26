-- Todo : Fix the spellname in UNIT_SPELL_SENT
-- Todo : Handle Mana Burst toggle

if select(3, UnitClass("player")) == 8 then

	function Mage() 	-- Todo : we Should create one Class Main file for all speccs. The flow is the same more or less and its better to create small changes per module then seperate modules
							-- For example the options and toggles files. They are the same but small changes, toggles should be exactly the same with rare difference.

		if currentConfig ~= "Mage Gabbz" then
			MageConfig()  	-- Class Specefic Options for now
			--Toggles()		-- Toggles should be same on BadRobotlevel. We will use mages toggles as baseline and when we are done we move it to class generic
			currentConfig = "Mage Gabbz"
		end

		-- Manual Input
		if IsLeftShiftKeyDown() or IsLeftAltKeyDown() then -- Pause the script, keybind in wow shift+1 etc for manual cast
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
				playerIsMoving 					= isMoving("player")
				playerMana						= getMana("player")
				playerHaste						= GetHaste()
				
				--Buffs
				playerBuffArcanePower			= UnitBuffID("player",ArcanePower) 
				playerBuffArcanePowerTimeLeft	= getBuffRemain("player",ArcanePower)
				playerBuffArcaneMissile			= UnitBuffID("player",ArcaneMissilesP)
				stacksArcaneMisslesP			= getBuffStacks("player",ArcaneMissilesP)
				arcaneCharge 					= Charge()
				

				--playerSpells
				playerSpellPrismaticCrystalIsKnown	= isKnown(PrismaticCrystal) 
				playerSpellPrismaticCrystalCD 		= getSpellCD(PrismaticCrystal)	--Todo : Replace with this

				isKnownOverPowered					= isKnown(Overpowered)
				isKnownArcaneOrb					= isKnown(ArcaneOrb)
				isKnownSupernova					= isKnown(Supernova)
				
				cdArcanePower						= getSpellCD(ArcanePower)
				cdEvocation							= getSpellCD(Evocation)
				
				
				------------------
				-- Target
				------------------
				targetDebuffNetherTempest 			= UnitDebuffID("target",NetherTempest, "player")	
				targetDebuffNetherTempestTimeLeft	= getDebuffRemain("target",NetherTempest, "player")

				


				
				chargesSuperNova					= GetSpellCharges(Supernova)
				reChargeSuperNova					= getRecharge(Supernova)

				castTimeArcaneBlast					 = select(4,GetSpellInfo(ArcaneBlast))/1000

			if cancelEvocation() then
				RunMacroText("/stopcasting")
			end
			
			if not isItOkToClipp() then
				return true
			end

			if isPlayerMoving and not UnitBuffID("player", IceFloes) then
				castIceFloes()
			end	


			
			if BadBoy_data['Defensive'] == 2 then
				ArcaneMageDefensives()
			end


			if BadBoy_data['Cooldowns'] == 2 then
				ArcaneMageCooldowns()
			end


			-- actions+=/call_action_list,name=aoe,if=active_enemies>=5
			-- AoE
	--		if BadBoy_data['AoE'] == 2 then
	--			ArcaneMageAoESimcraft()
	--		end
			-- AutoAoE
			

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

			--runeOfPower()

			if getNumEnemies("player",10) > 5 then -- This is only checking for melee
				if BadBoy_data['AoE'] == 2 or BadBoy_data['AoE'] == 3 then -- We need to sort out the auto aoe, ie == 3 
					ArcaneMageAoESimcraft()
				end
			end
			
			--actions+=/call_action_list,name=conserve
			--print("CD Evo "  ..cdEvocation)
			--print("First : " ..(playerMana-30)*0.3*(10/playerHaste))

			if isChecked("Burn Phase") then
				-- actions+=/call_action_list,name=burn,if=time_to_die<mana.pct*0.35*spell_haste|cooldown.evocation.remains<=(mana.pct-30)*0.3*spell_haste|(buff.arcane_power.up&cooldown.evocation.remains<=(mana.pct-30)*0.4*spell_haste)
				--if (getTimeToDie("target") < playerMana*0.35*(1/playerHaste)) or (cdEvocation <= (playerMana-30)*0.3*(1/playerHaste)) or (playerBuffArcanePower and cdEvocation <= (playerMana-30)*0.4*(1/playerHaste)) then -- 
				if cdEvocation < 20 then
					if ArcaneMageSingleTargetSimcraftBurn() then
			--		if GabbzBurn() then
						return true
					end
				end
			end
			if ArcaneMageSingleTargetSimcraftConserve() then
			--if GabbzConserve() then
				return true
			end
		end
	end
end