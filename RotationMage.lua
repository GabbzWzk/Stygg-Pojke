-------------------
-- Arcane Mage
------------------
print("Mage Rotations")
-- Cooldowns
-- Defensives
function Defensive()

	---------------
	-- Healthstone
	---------------
	if isChecked("Healthstone") == true then
		if getHP("player") <= getValue("Healthstone") then
			if canUse(5512) then
				UseItemByName(tostring(select(1,GetItemInfo(5512))))
			end
		end
	end

	if isChecked("Def Potions") == true then
		if getHP("player") <= getValue("Def Potions") then
			if canUse(109223) then
				UseItemByName(tostring(select(1,GetItemInfo(109223))))
			end
		end
	end

	---------------
	-- Pots
	---------------

	---------------
	-- Defensive Trinkets
	---------------

	---------------
	-- Racials?
	---------------

	---------------
	-- Class 
	---------------

	---------------
	-- Mages
	---------------
	if select(3, UnitClass("player")) == 8 then
		-- Evanesce
		if isKnown(Evanesce) then
			if isChecked("Evanesce") then
				if getHP("player") < getValue("Evanesce") then
					if castSpell("player",Evanesce,true,false) then
						return true
					end
				end
			end
		end

		if isKnown(IceBlock) then
			if isChecked("IceBlock") then
				if getHP("player") < getValue("IceBlock") then
					if castSpell("player",IceBlock,true,false) then
						return true
					end
				end
			end
		end

		if isKnown(IceBarrier) then
			if isChecked("IceBlock") then
				if getHP("player") < getValue("IceBlock") then
					if castSpell("player",IceBarrier,true,false) then
						return true
					end
				end
			end
		end
	end
end	

function OffensiveCooldowns()
	-- Berserk
	if isChecked("Racial") then
		if isKnown(Berserkering) then
			if castSpell("player",Berserkering,true,true) then
			--	return true
			end
		end
	end

	-- Potions	TODO : Make this class/specc agnostic, should be based on 
	if isChecked("DPS Potions") then
		if canUse(109218) then -- WoD Potion Int
        	UseItemByName(tostring(select(1,GetItemInfo(109218))))
        end
	end

	if isChecked("Trinkets") then
		print("Missing Trinket Logic")
	end
end


------------------------------
-- Arcane Mage 
----------------------------
	-- Arcane Mage Specific Rotations. Focused on Burst and Single target usage. Fire will be used for AoE.
	-- Talents that will be focused is, 
		-- SuperNova and Nether Tempest, Tempest for lasting cleave and SuperNova for Single target and spawning adds
		-- Incanters Flow, Rune of Power Handled manually
		-- Prismatic Crystal and Arcane Orb
	-- Arcane is divided into the following sub rotations
		-- Init Prismatic Crystal
		-- Prismatic Crystal Rotation
		-- Arcane Cooldowns
		-- AoE
		-- Burn Rotation
		-- Conserve Rotation
		-- There is a function check that cancels the Evocation, but we only check if we are over 93%
function ArcaneMageRotation()
	
	--Is there AoE 
	if ArcaneMageAoESimcraft() then
		return true
	end
	-- Burst is toggle, if not we only do conserve as Arcane Mage
	if BadRobot_data['Cooldowns'] == 2 then 
		if ArcaneMageSingleTargetSimcraftBurn() then
			return true
		end
	end
	
	if ArcaneMageSingleTargetSimcraftConserve() then
		return true
	end
end

function ArcaneMageCooldowns()
	-- Todo : we need to make sure to synch and what not here
	-- We dont want to use pots unless we have Arcane Power
	OffensiveCooldowns()

	if player.specc == 1 then
		-- Arcane Power
		if isChecked("Arcane Power") then
			if castSpell("player",ArcanePower,true,true) then
				return true
			end
		end
	end
end

------------------------------
-- Arcane Mage Pre Pull Sequence
----------------------------
function ArcaneMagePrepull()
--# Executed before combat begins. Accepts non-harmful actions only.
--actions.precombat=flask,type=greater_draenic_intellect_flask
--actions.precombat+=/food,type=sleeper_surprise
--actions.precombat+=/arcane_brilliance
--actions.precombat+=/snapshot_stats
--actions.precombat+=/rune_of_power
--actions.precombat+=/mirror_image
--actions.precombat+=/potion,name=draenic_intellect
--actions.precombat+=/arcane_blast
	return false
end


------------------------------
-- Arcane Mage Prismatic Crystal Set Up
----------------------------
function ArcaneMageInitPrismaticCrystal()
	--# Conditions for initiating Prismatic Crystal
	--actions.init_crystal=call_action_list,name=conserve,if=buff.arcane_charge.stack<4
	if Charge() < 4 then
		return false
	end
	--actions.init_crystal+=/prismatic_crystal,if=buff.arcane_charge.stack=4&cooldown.arcane_power.remains<0.5
	if Charge() == 4 and cdArcanePower < 1 then
		if castPrismaticCrystal() then
			return true
		end
	end

	--actions.init_crystal+=/prismatic_crystal,if=glyph.arcane_power.enabled&buff.arcane_charge.stack=4&cooldown.arcane_power.remains>75
	if Charge() == 4 and cdArcanePower > 75 then
		if castPrismaticCrystal() then
			return true
		end
	end
	return false
end

------------------------------
-- Arcane Mage Prismatic Crystal Sequence
----------------------------
function ArcaneMageExecutePrismaticCrystalRotation()
	--# Actions while Prismatic Crystal is active
	--actions.crystal_sequence=call_action_list,name=cooldowns --Todo : This is already done before since our CD is longer then 12 seconds
	local crystalremains = UnitMana("target")/8.34 -- Power is 100 and time is 12 so we need to calculate
	
	--actions.crystal_sequence+=/nether_tempest,if=buff.arcane_charge.stack=4&!ticking&pet.prismatic_crystal.remains>8
	-- Todo:  we need to get the timer for Prismatic Crystal
	if Charge() == 4 and not UnitDebuffID("target",NetherTempest, "player") and crystalremains > 8 then
		if castSpell("target",NetherTempest,false,false) then
			return true
		end
	end
	--actions.crystal_sequence+=/supernova,if=mana.pct<96
	if chargesSuperNova > 0 and player.mana < 96 then
		if castSpell("target",Supernova,false,false) then
			return true
		end
	end

	--actions.crystal_sequence+=/presence_of_mind,if=cooldown.cold_snap.up|pet.prismatic_crystal.remains<action.arcane_blast.cast_time
	if crystalremains < castTimeArcaneBlast then
		if cdPresenceOfMind == 0 then
			if castSpell("player", PresenceOfMind, false, false) then
				if castSpell("target",ArcaneBlast,false,true) then
					return true
				end
			end
		end
	end

	--actions.crystal_sequence+=/arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93&pet.prismatic_crystal.remains>cast_time+buff.arcane_missiles.stack*2*spell_haste+action.arcane_missiles.travel_time
	if Charge() == 4 and player.mana > 93 and crystalremains > castTimeArcaneBlast + 3.4 then -- Todo : What does this mean? Cast Arcane Blast if time remains on crystal is less then cast time Arcane Blast plus 2 stacks of missiles? ie 2 cast of MM? No it should be multippled per AM Stack
		if castSpell("target",ArcaneBlast,false,true) then
			return true
		end
	end
	--actions.crystal_sequence+=/arcane_missiles,if=pet.prismatic_crystal.remains>2*spell_haste+travel_time
	if stacksArcaneMisslesP > 0 and crystalremains > 1.7 then  --Todo, removed hard coded AM times
		if castSpell("target",ArcaneMissiles,false,true) then
			return true
		end
	end

	--actions.crystal_sequence+=/supernova,if=pet.prismatic_crystal.remains<action.arcane_blast.cast_time
	if crystalremains < castTimeArcaneBlast and chargesSuperNova > 0 then
		if castSpell("target",Supernova,false,false) then
			return true
		end
	end

	--actions.crystal_sequence+=/choose_target,if=pet.prismatic_crystal.remains<action.arcane_blast.cast_time&buff.presence_of_mind.down
	-- Todo Switch Target here

	--actions.crystal_sequence+=/arcane_blast
	if castSpell("target",ArcaneBlast,false,true) then
		return true
	end
	return false
end

------------------------------
-- Arcane Mage AoE Rotation ToDo
----------------------------
function ArcaneMageAoESimcraft()
	
	-- actions.aoe+=/nether_tempest,cycle_targets=1,if=buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
	if Charge() == 4 and (not UnitDebuffID("target",NetherTempest, "player") or (UnitDebuffID("target",NetherTempest, "player") and getDebuffRemain("target",NetherTempest, "player")<3.6)) then
		if  targets.nrTargetAroundTarget > 4 then
			if castSpell("target",NetherTempest,false,false) then
				return true
			end
		end
	end
	
	-- actions.aoe+=/supernova
	if chargesSuperNova > 0 and targets.nrTargetAroundTarget > 4 then
		if castSpell("target",Supernova,false,false) then
			return true
		end
	end
	
	-- actions.aoe+=/arcane_barrage,if=buff.arcane_charge.stack=4
	if targets.nrTargetAroundTarget > 4 and Charge() == 4 then
		if castArcaneBarrage("target", 4) then
			return true 
		end
	end
	
	-- actions.aoe+=/arcane_orb,if=buff.arcane_charge.stack<4
	if targets.nrTargetAroundTarget > 3 then	
		if castArcaneOrb("target", 3) then
			return true
		end
	end
	
	-- actions.aoe+=/cone_of_cold,if=glyph.cone_of_cold.enabled
	if hasGlyph(323) and targets.nrTargetAroundTarget > 4 then
		if castSpell("target",ConeOfCold,false,true) then
			return true
		end
	end
		-- actions.aoe+=/arcane_explosion
	if targets.nrTargetsArcaneExplosion > 4 then								-- Todo : the range for Arcane Explosion is default 10 but can be glyphed to 15, need to be coded.
		if castSpell("target",ArcaneExplosion,true,false) then
			return true
		end
	end
	return false
end


------------------------------------
-- Arcane Mage Burn Phase Rotation
--		Name a bit missleading, this is the burst section where Burn phase for Arcane is one of the actions to do in this phase
--		Major CDs are Arcane Power on 3 minute CD and is linked to also the usage of Racials, Trinkets, PC and Burn phase
--		The issue is that abilities will be desynched in the rotation, primarly Evocation and Burn phase with PC. The minor burst(PC and OR Burn phase) are hindering the synch
--			with AP. The solution is that the minor burst then PC and Burn will not happen at the same time.
--			So first Major will be AP, PC, Berserking, Trinket, Pot(Prepull) and Burn Phase.
--			The minor will use PC on CD if we dont prelong the AP to much waiting for Evocation.
--			The second major will be as soon as AP is Off CD.
------------------------------------
function ArcaneMageSingleTargetSimcraftBurn()
	
	-- actions.burn=call_action_list,name=cooldowns

	if arcaneCharge == 4 then 
		ArcaneMageCooldowns()
	end

	if isChecked("Prismatic Crystal") then
		if ArcaneMageInitPrismaticCrystal() then 
			return true
		end
	end

	if UnitName(target) == "Prismatic Crystal" then
		if ArcaneMageExecutePrismaticCrystalRotation() then
			return true
		end
	end

	if playerSpellEvocationCD > 15 then
		if ArcaneMageSingleTargetSimcraftConserve() then
			return true
		end
	end
	
	--actions.burn+=/arcane_missiles,if=buff.arcane_missiles.react=3
	if stacksArcaneMisslesP == 3 then
		if castSpell(target,ArcaneMissiles,false,true) then
			return true
		end
	end

	--actions.burn+=/arcane_missiles,if=set_bonus.tier17_4pc&buff.arcane_instability.react&buff.arcane_instability.remains<action.arcane_blast.execute_time
	--if UnitBuffID("player",T17_4P_Arcane) and getBuffRemain("player",T17_4P_Arcane) < castTimeArcaneBlast then
	--	if castSpell("target",ArcaneMissiles,false,false) then
	--		return true
	--	end
	--end
	
	-- actions.burn+=/supernova,if=time_to_die<8|charges=2
	if isKnownSupernova then 					
		if chargesSuperNova > 1 then
			if castSpell(target,Supernova,false,false) then
				return true
			end
		end
	end	
	
	--actions.burn+=/nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
	if arcaneCharge > 3 and (not UnitDebuffID("target",NetherTempest) or ((UnitDebuffID("target",NetherTempest) and getDebuffRemain("target",NetherTempest)<3.6))) then
		if castSpell(target,NetherTempest,true,false) then
			return true
		end
	end
	
	--actions.burn+=/arcane_orb,if=buff.arcane_charge.stack<4
	if castArcaneOrb(target, 3) then
		return true
	end
	
	--actions.burn+=/presence_of_mind,if=mana.pct>96&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up)
	if player.mana > 96 and (not playerSpellPrismaticCrystalIsKnown or playerSpellPrismaticCrystalCD > 0)  then
		if castSpell("player",PresenceOfMind,true,false) then
			return true
		end
	end
	
	--actions.burn+=/arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93
	if arcaneCharge > 3 and player.mana > getValue("ArcaneBlast (x4)") then
		if castSpell(target,ArcaneBlast,false,true) then
			return true
		end
	end	

	--Todod : actions.burn+=/arcane_missiles,if=buff.arcane_charge.stack=4&(mana.pct>70|!cooldown.evocation.up)
	
	--actions.burn+=/supernova,if=mana.pct>70&mana.pct<96
	if isKnownSupernova and chargesSuperNova > 0 then
		if (player.mana < 96) and (player.mana > 70) then
			if castSpell(target,Supernova,false,false) then
				return true
			end
		end
	end
	
	--# APL hack for evocation interrupt
	--actions.burn+=/call_action_list,name=conserve,if=cooldown.evocation.duration-cooldown.evocation.remains<5

	--actions.burn+=/evocation,interrupt_if=mana.pct>92,if=time_to_die>10&mana.pct<50
	if player.mana < 50 then
		if castSpell("player",Evocation,true,false) then
			return true
		end
	end
	
	--actions.burn+=/presence_of_mind,if=!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up
	if not playerSpellPrismaticCrystalIsKnown or playerSpellPrismaticCrystalCD > 0 then
		if castSpell("player",PresenceOfMind,true,false) then
			return true
		end
	end
	--actions.burn+=/arcane_blast
	if castArcaneBlast("target") then
		return true
	end
	return false
end

--------------------------
-- ArcaneMageSingleTargetSimcraftConserve() 
--------------------------
function ArcaneMageSingleTargetSimcraftConserve()
	--actions.conserve=call_action_list,name=cooldowns,if=time_to_die<30|(buff.arcane_charge.stack=4&(!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>15))
	-- Todo: we should here use CDs if target is about to die

	--actions.conserve+=/arcane_missiles,if=buff.arcane_missiles.react=3|(talent.overpowered.enabled&buff.arcane_power.up&buff.arcane_power.remains<action.arcane_blast.execute_time)
	if stacksArcaneMisslesP == 3 or (isKnownOverPowered and (playerBuffArcanePower and playerBuffArcanePowerTimeLeft < (select(4,GetSpellInfo(ArcaneBlast))/1000))) then
		if castSpell("target",ArcaneMissiles,false,true) then
			return true
		end
	end
	--actions.conserve+=/arcane_missiles,if=set_bonus.tier17_4pc&buff.arcane_instability.react&buff.arcane_instability.remains<action.arcane_blast.execute_time
	if UnitBuffID("player",T17_4P_Arcane) and getBuffRemain("player",T17_4P_Arcane) < (select(4,GetSpellInfo(ArcaneBlast)/1000)) then
		if castSpell("target",ArcaneMissiles,false,true) then
			return true
		end
	end

	--actions.conserve+=/nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
	if UnitName("target") ~= "Prismatic Crystal" and arcaneCharge > 3 and (not targetDebuffNetherTempest or ((targetDebuffNetherTempest and targetDebuffNetherTempestTimeLeft < 3.6))) then
		if castSpell("target",NetherTempest,true,false) then
			return true
		end
	end
	
	--actions.conserve+=/supernova,if=time_to_die<8|(charges=2&(buff.arcane_power.up|!cooldown.arcane_power.up)&(!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>8))
	if chargesSuperNova == 2 and ((playerBuffArcanePower or cdArcanePower > 0) or not isChecked("Burn Phase"))then 
		if castSpell("target",Supernova,false,false) then
			return true
		end
	end	

	--actions.conserve+=/arcane_orb,if=buff.arcane_charge.stack<2
	if castArcaneOrb("target", 2) then
		return true
	end
	

	--actions.conserve+=/presence_of_mind,if=mana.pct>96&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up)
	if player.mana > 96 and (not playerSpellPrismaticCrystalIsKnown or playerSpellPrismaticCrystalCD > 0) then
		if castSpell("player",PresenceOfMind,true,false) then
			return true
		end
	end
	
	--actions.conserve+=/arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93
	if arcaneCharge > 3 and player.mana > getValue("ArcaneBlast (x4)") then
		if castArcaneBlast("target") then
			return true
		end
	end
	
	--actions.conserve+=/arcane_missiles,if=buff.arcane_charge.stack=4&(!talent.overpowered.enabled|cooldown.arcane_power.remains>10*spell_haste)
	if arcaneCharge > 3 and (not isKnownOverPowered or (cdArcanePower > 10 * player.haste)) then
		if castSpell("target",ArcaneMissiles,false,true) then
			return true
		end
	end
	
	--actions.conserve+=/supernova,if=mana.pct<96&(buff.arcane_missiles.stack<2|buff.arcane_charge.stack=4)
	if player.mana < 96 and (stacksArcaneMisslesP < 2 or arcaneCharge > 3) then 
		-- &(buff.arcane_power.up|(charges=1&cooldown.arcane_power.remains>recharge_time))
		if (playerBuffArcanePower or (chargesSuperNova == 1 and cdArcanePower > reChargeSuperNova)) then
			--&(!talent.prismatic_crystal.enabled|current_target=prismatic_crystal|(charges=1&cooldown.prismatic_crystal.remains>recharge_time+8))
			if (playerSpellPrismaticCrystalIsKnown or UnitName("target") == "Prismatic Crystal" or (chargesSuperNova == 1 and playerSpellPrismaticCrystalCD > (reChargeSuperNova+8))) then
				if castSpell("target",Supernova,false,false) then
					return true
				end
			end
		end
	end
	
	--actions.conserve+=/nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<(10-3*talent.arcane_orb.enabled)*spell_haste))
	-- Todo : Here we need to check if TTD on target is more then 10 seconds, we should also compare the current Nether Tempest target and see if
	-- 			there is a better target in 40 yards that have a more enemies around him.
	if arcaneCharge > 3 then -- Only cast NT if we have 4 stacks
		if (not targetDebuffNetherTempest or ((targetDebuffNetherTempest and targetDebuffNetherTempestTimeLeft < 3.6))) then -- If there is no NT dot on target, need to check any target here(only oine active is allowed)
			if castSpell("target",NetherTempest,true,false) then
				return true
			end
		end
	end

	--actions.conserve+=/arcane_barrage,if=buff.arcane_charge.stack=4
	if castArcaneBarrage("target", 4) then
		return true
	end

	--actions.conserve+=/presence_of_mind,if=buff.arcane_charge.stack<2&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up)
	if arcaneCharge < 2 and (not playerSpellPrismaticCrystalIsKnown or playerSpellPrismaticCrystalCD > 0) then
		if castSpell("player",PresenceOfMind,true,false) then
			return true
		end
	end
	--actions.conserve+=/arcane_blast
	if castArcaneBlast("target") then
		return true
	end
	
	--actions.conserve+=/arcane_barrage,moving=1
	if player.isMoving  then
		if castArcaneBarrage("target", 0) then
			return true
		end
	end
end

--------------------------
-- Fire Mage Rotation
--			Focusing on AoE damage using talents x, y
--			Strategy to 
--			Todo :Combustion and Pyro Chain i am not sure what this means but we cant wait for a perfect ignite. Fire is cleave and AoE so we need to think when and perhaps not always how much.
--					However a very good ignite value should be there in case we are hitting 5K ignites
--			Todo : We are spreading Living Bomb from target when we have LB ticking on adds that have not exploded, we cant not cast Fireblast unless we are spreading.
--------------------------
function FireMageRotation()

	-- Is there AoE peeps araound
	--	if FireAoEMage() then
	--		return true
	--	end
	
	-- Handle the burst and CDs : Its evolving around Combustion, so initiate PyroChain etc
	if BadRobot_data['Cooldowns'] == 2 then 
		if FireBurstRotation() then
			return true
		end
	end
	-- Last do single filler with spread
	return FireSingleTarget()
end

function FireMageCooldowns()
	-- Todo : we need to make sure to synch and what not here
	-- We dont want to use pots unless we have Arcane Power
	OffensiveCooldowns()

	if player.specc == 2 then
		-- What is Fire specc CD? Only Combustion?
		--if isChecked("Arcane Power") then
		--	if castSpell("player",ArcanePower,true,true) then
		--		return true
		--	end
		--end
	end
end


function FireAoETarget()

	
	--Fire's cleave is pretty simple, you want to cast Inferno Blast to spread your DoTs to other nearby targets, make sure that you always spread Combustion instantly after using it.
	--Also make sure to spread Living Bomb before it expires, since the detonation is a large source of damage.
	--When there are five or more targets, you should use Dragon's Breath on cooldown (if glyphed) and keep up the debuff that Flamestrike applies.
end

function FireCleaveTarget()
-- When we have pyroblast buff up and we not using Combustion or Combustion is on CD  
--we should check targets that dont have the Pyroblast DoT on them and cast pyro on that target. This si only true when mobs are tanked or stationary away frome achother
	
	--Fire's cleave is pretty simple, you want to cast Inferno Blast to spread your DoTs to other nearby targets, make sure that you always spread Combustion instantly after using it.
	--Also make sure to spread Living Bomb before it expires, since the detonation is a large source of damage.
	--When there are five or more targets, you should use Dragon's Breath on cooldown (if glyphed) and keep up the debuff that Flamestrike applies.
end

function CombustionSequence()
	if not CombustionReady then 
		CombustionReady = false 
	end
	if not CombustionPyroChain then 
		CombustionPyroChain = false or 0 --??
	end

	--actions.init_combust+=/start_pyro_chain,if=(cooldown.combustion.remains<gcd.max*4&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|(buff.pyromaniac.up&cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*(gcd.max+talent.kindling.enabled)))
	if (cdCombustion < 3 and playerBuffPyroBlast and playerBuffHeatingUp and player.isCasting == Fireball) or CombustionReady == true then -- Todo The last or stuff
		if not CombustionReady == true then 
			CombustionPyroChain = GetTime()
			CombustionReady = true
			print("Starting now ") 
		end

		--actions.combust_sequence+=/combustion  Todo : What? This does not make sence, we are not looking at ignite damage and hte code is not same as simcraft
	    if (not playerBuffPyroBlast and CombustionReady == true and (GetTime() - CombustionPyroChain >= 4.9)) or playerspellignitelasttick > 4000 then --and targetDebuffIgnite  
	    	RunMacroText("/stopcasting")
	    	if castSpell("target", Combustion,false,false) then
				print("Combustion0")
	    		CombustionReady = false
	    		--CastSpellByName("Combustion", target)
	        	return true
	    	end
	    end

		-- Use all CDs that are checked
		FireMageCooldowns()
		
		if playerBuffPyroBlast then 
        	if CastSpellByName("Pyroblast", "target") then 
	       		return true
	       	end
		end
	
	    if playerBuffHeatingUp then 
    		if castInfernoBlast("target") then 
    			print("Casting IB")
        		return true
      		end
    	end

    	if GetTime() - CombustionPyroChain + castTimeFireball >= 4 then
    		if castFireball("target") then
    			print("Casting Fireball")
				return true
			end
		end
		
		if castInfernoBlast("target") then 
			print("Last cast IB")
        	return true
      	end
    	
	end
end

function FireBurstRotation()
	
	-- Check if we should start pyro chain to get a combustion
	--if "cd on combustion is over or soonish"  then
	--	if CombustionSequence() then
	--		return true
	--	end
	--end
	if cdCombustion < 3 then
		if CombustionSequence() then
			return true
		end
	end
	
	-- Rest of the Burst stuff, such as?
end


function FireSingleTarget()
	--actions.combust_sequence+=/arcane_torrent
	--actions.combust_sequence+=/potion,name=draenic_intellect
	--actions.combust_sequence+=/fireball,if=!dot.ignite.ticking&!in_flight
	--if not targetDebuffIgnite and not player.isCasting == Fireball then 
	--	if castFireball("target") then
	--		return true
	--	end
	--end
	

	
	--# Meteor Combustions can run out of Pyro procs before impact. Use IB to delay Combustion
	--actions.combust_sequence+=/inferno_blast,if=talent.meteor.enabled&cooldown.meteor.duration-cooldown.meteor.remains<gcd.max*3
	
		
	--inferno_blast,if=(dot.combustion.ticking&active_dot.combustion<active_enemies)|(dot.living_bomb.ticking&active_dot.living_bomb<active_enemies)
	--if (targetDebuffIgniteffcombustion and targetsinrangeforcombustioncleave > 0) or (targetdebufflivingbomb and targetsinrangeforlivingbombcleave > 0) then -- Need to track combustion dots on enemy, so for each enemy in range and we do not have a combustion dot on him we should spread.
   --     if castInfernoBlast(target) then
   --     	return true
    --  	end
   -- end

	--pyroblast,if=buff.pyroblast.up&buff.pyroblast.remains<action.fireball.execute_time
	if playerBuffPyroBlast and playerBuffPyroBlastTimeLeft < 2  then 
        if CastSpellByName("Pyroblast", target) then 
        	return true
        end
   end
	
	--pyroblast,if=set_bonus.tier16_2pc_caster&buff.pyroblast.up&buff.potent_flames.up&buff.potent_flames.remains<gcd.max
	--pyroblast,if=set_bonus.tier17_4pc&buff.pyromaniac.react
	

	--pyroblast,if=buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight
	if playerBuffPyroBlast and playerBuffHeatingUp and player.isCasting == Fireball then  
        CastSpellByName("Pyroblast", target)
        return true
    end
	
	--actions.single_target+=/inferno_blast,if=buff.pyroblast.down&buff.heating_up.up
	if not playerBuffPyroBlast and playerBuffHeatingUp then 
    	if castInfernoBlast(target) then 
        	return true
      	end
    end
		
	--Todo:meteor,if=active_enemies>=5|(glyph.combustion.enabled&(!talent.incanters_flow.enabled|buff.incanters_flow.stack+incanters_flow_dir>=4)&cooldown.meteor.duration-cooldown.combustion.remains<10)
	
	--call_action_list,name=living_bomb,if=talent.living_bomb.enabled
	if targetName ~= "Prismatic Crystal" and targetTimeToDie > (12 + targetDebuffLivingBombRemain) and targetDebuffLivingBombRemain < 3.6 then
		if (not spellIncantersFlowIsKnown) or (playerBuffIncantersFlowDirection == "Down") or (playerBuffIncantersFlowStacks == 5)  then
			if castLivingBomb(target) then
       			return true
    		end
		end

		if playerBuffIncantersFlowDirection == "Up" or playerBuffIncantersFlowStacks == 1 and targetDebuffLivingBombRemain < 1 then
			if castLivingBomb(target) then
       			return true
    		end
		end
	end

    --Todo:blast_wave,if=(!talent.incanters_flow.enabled|buff.incanters_flow.stack>=4)&(time_to_die<10|!talent.prismatic_crystal.enabled|(charges=1&cooldown.prismatic_crystal.remains>recharge_time)|charges=2|current_target=prismatic_crystal)
    
	
	--actions.single_target+=/inferno_blast,if=buff.pyroblast.up&buff.heating_up.down&!action.fireball.in_flight
    if playerBuffPyroBlast and not playerBuffHeatingUp and playerspellFireballInFlight  then
        if castInfernoBlast(target) then
        	return true
      	end
    end
	
	--actions.single_target+=/fireball
	if not player.isMoving then
		if castFireball(target) then
			return true
		end
	end

	--actions.single_target+=/scorch,moving=1
	if player.isMoving  then
		if castScorch(target) then
			return true
		end
	end
end