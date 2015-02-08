-------------------
-- Arcane Mage
------------------
print("Mage Rotations")

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
end

--# Executed every time the actor is available.

--actions=counterspell,if=target.debuff.casting.react
--actions+=/blink,if=movement.distance>10
--actions+=/blazing_speed,if=movement.remains>0
--actions+=/cold_snap,if=health.pct<30
--actions+=/time_warp,if=target.health.pct<25|time>5
--actions+=/ice_floes,if=buff.ice_floes.down&(raid_event.movement.distance>0|raid_event.movement.in<action.arcane_missiles.cast_time)
--actions+=/rune_of_power,if=buff.rune_of_power.remains<cast_time
--actions+=/mirror_image
--actions+=/cold_snap,if=buff.presence_of_mind.down&cooldown.presence_of_mind.remains>75
--actions+=/call_action_list,name=init_crystal,if=talent.prismatic_crystal.enabled&cooldown.prismatic_crystal.up
--actions+=/call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&pet.prismatic_crystal.active
--actions+=/call_action_list,name=aoe,if=active_enemies>=4
--actions+=/call_action_list,name=burn,if=time_to_die<mana.pct*0.35*spell_haste|cooldown.evocation.remains<=(mana.pct-30)*0.3*spell_haste|(buff.arcane_power.up&cooldown.evocation.remains<=(mana.pct-30)*0.4*spell_haste)
--actions+=/call_action_list,name=conserve

------------------------------
-- Arcane Mage Prismatic Crystal Set Up
----------------------------
function ArcaneMageInitPrismaticCrystal()
--# Conditions for initiating Prismatic Crystal
--actions.init_crystal=call_action_list,name=conserve,if=buff.arcane_charge.stack<4
--actions.init_crystal+=/prismatic_crystal,if=buff.arcane_charge.stack=4&cooldown.arcane_power.remains<0.5
--actions.init_crystal+=/prismatic_crystal,if=glyph.arcane_power.enabled&buff.arcane_charge.stack=4&cooldown.arcane_power.remains>75
end

------------------------------
-- Arcane Mage Prismatic Crystal Sequence
----------------------------
function ArcaneMageExecutePrismaticCrystalRotation()
--# Actions while Prismatic Crystal is active
--actions.crystal_sequence=call_action_list,name=cooldowns
--actions.crystal_sequence+=/nether_tempest,if=buff.arcane_charge.stack=4&!ticking&pet.prismatic_crystal.remains>8
--actions.crystal_sequence+=/supernova,if=mana.pct<96
--actions.crystal_sequence+=/presence_of_mind,if=cooldown.cold_snap.up|pet.prismatic_crystal.remains<action.arcane_blast.cast_time
--actions.crystal_sequence+=/arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93&pet.prismatic_crystal.remains>cast_time+buff.arcane_missiles.stack*2*spell_haste+action.arcane_missiles.travel_time
--actions.crystal_sequence+=/arcane_missiles,if=pet.prismatic_crystal.remains>2*spell_haste+travel_time
--actions.crystal_sequence+=/supernova,if=pet.prismatic_crystal.remains<action.arcane_blast.cast_time
--actions.crystal_sequence+=/choose_target,if=pet.prismatic_crystal.remains<action.arcane_blast.cast_time&buff.presence_of_mind.down
--actions.crystal_sequence+=/arcane_blast
end

-- Cooldowns
function ArcaneMageCooldowns()
	--# Consolidated damage cooldown abilities
	--actions.cooldowns=arcane_power
	--actions.cooldowns+=/blood_fury
	--actions.cooldowns+=/berserking
	--actions.cooldowns+=/arcane_torrent
	--actions.cooldowns+=/potion,name=draenic_intellect,if=buff.arcane_power.up&(!talent.prismatic_crystal.enabled|pet.prismatic_crystal.active)
	--actions.cooldowns+=/use_item,slot=trinket1
	
	-- Berserk
	if isChecked("Racial") then
		if isKnown(Berserkering) then
			if castSpell("player",Berserkering,true,true) then
			--	return true
			end
		end
	end
	-- Arcane Power
	if isChecked("Arcane Power") then
		if castSpell("player",ArcanePower,true,true) then
			-- return true
		end
	end

	-- Potion
	if isChecked("Potions") then
		print("Missing Potions Logic")
	end

	if isChecked("Trinket 1") then
		print("Missing Trinket Logic")
	end

end


------------------------------
-- Arcane Mage AoE Rotation ToDo
----------------------------
--Once you reach five or more targets that are stacked, you will break away from your usual rotation and follow this priority:
	--Supernova or Nether Tempest
	--Arcane Barrage once you reach 4 stacks
	--Arcane Orb if you talented it and you are not at 4 stacks
	--Cone of Cold if you have it glyphed
--# AoE sequence
--actions.aoe=call_action_list,name=cooldowns
--actions.aoe+=/nether_tempest,cycle_targets=1,if=buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
--actions.aoe+=/supernova
--actions.aoe+=/arcane_barrage,if=buff.arcane_charge.stack=4
--actions.aoe+=/arcane_orb,if=buff.arcane_charge.stack<4
--actions.aoe+=/cone_of_cold,if=glyph.cone_of_cold.enabled
--actions.aoe+=/arcane_explosion
-- AoE
function ArcaneMageAoESimcraft()
	
	if targets.nrTargetAroundTarget > 4 then	--Todo : We should for each of this have a seperate number, for example, Super nova is non facing while a
		-- actions.aoe+=/nether_tempest,cycle_targets=1,if=buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
		if Charge()==4 and (not UnitDebuffID("target",NetherTempest, "player") or (UnitDebuffID("target",NetherTempest, "player") and getDebuffRemain("target",NetherTempest, "player")<3.6)) then
			return true
		end
		-- actions.aoe+=/supernova
		if chargesSuperNova > 0 then
			if castSpell("target",Supernova,false,false) then
				return true
			end
		end
		-- actions.aoe+=/arcane_barrage,if=buff.arcane_charge.stack=4
		if castArcaneBarrage("target", 4) then	--Todo : For example, Arcane Barrage only hit 4 target so why do we check for 5
			return true 
		end
		-- actions.aoe+=/arcane_orb,if=buff.arcane_charge.stack<4
		if castArcaneOrb("target", 3) then
			return true
		end
	end	
	
	-- actions.aoe+=/cone_of_cold,if=glyph.cone_of_cold.enabled
	if hasGlyph(323) then
		if castSpell("target",ConeOfCold,false,true) then
			return true
		end
	end
		-- actions.aoe+=/arcane_explosion
	if targets.nrTargetsArcaneExplosion then								-- Todo : the range for Arcane Explosion is default 10 but can be glyphed to 15, need to be coded.
		if castSpell("target",ArcaneExplosion,true,false) then
			return true
		end
	end
end


------------------------------
-- Arcane Mage Burn Phase Rotation
----------------------------
function ArcaneMageSingleTargetSimcraftBurn()
	
	--# High mana usage, "Burn" sequence
	-- actions.burn=call_action_list,name=cooldowns
	if BadRobot_data['Cooldowns'] == 2 and arcaneCharge > 3 then
		ArcaneMageCooldowns()
	end
	
	--actions.burn+=/arcane_missiles,if=buff.arcane_missiles.react=3
	if stacksArcaneMisslesP == 3 then
		if castSpell("target",ArcaneMissiles,false,true) then
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
			if castSpell("target",Supernova,false,false) then
				return true
			end
		end
	end	
	
	--actions.burn+=/nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
	if UnitName("target") == "Prismatic Crystal" and arcaneCharge > 3 and (not UnitDebuffID("target",NetherTempest) or ((UnitDebuffID("target",NetherTempest) and getDebuffRemain("target",NetherTempest)<3.6))) then
		if castSpell("target",NetherTempest,true,false) then
			return true
		end
	end
	
	--actions.burn+=/arcane_orb,if=buff.arcane_charge.stack<4
	if castArcaneOrb("target", 3) then
		return true
	end

	-- Todo : Still valid? Should not be here in burn if PRismatic Crystal is up
	if isKnownSupernova and chargesSuperNova > 0 then
		if UnitName("target") == "Prismatic Crystal" then
			if castSpell("target",Supernova,false,false) then
				return true
			end
		end
	end

	--actions.burn+=/presence_of_mind,if=mana.pct>96&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up)
	if player.mana > 96 and (not playerSpellPrismaticCrystalIsKnown or playerSpellPrismaticCrystalCD > 0)  then
		if castSpell("player",PresenceOfMind,true,false) then
			return true
		end
	end
	
	--actions.burn+=/arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93
	if arcaneCharge > 3 and player.mana > getValue("ArcaneBlast (x4)") then
		if castSpell("target",ArcaneBlast,false,true) then
			return true
		end
	end	

	--Todod : actions.burn+=/arcane_missiles,if=buff.arcane_charge.stack=4&(mana.pct>70|!cooldown.evocation.up)
	
	--actions.burn+=/supernova,if=mana.pct>70&mana.pct<96
	if isKnownSupernova and chargesSuperNova > 0 then
		if (player.mana < 96) and (player.mana > 70) then
			if castSpell("target",Supernova,false,false) then
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
--			Strategy to ....
--------------------------
function FireMageRotation()

	-- Is there AoE peeps araound
	--FireAoEMage
	-- Shall i combust?
	if isChecked("Burn Phase") then
		--FireMageCombustionRotation()
	end
	-- Last do single filler with spread
	return FireSingleTarget()
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

function PyroChain()
--# Kindling or Level 90 Combustion
--actions.init_combust+=/start_pyro_chain,if=
--(cooldown.combustion.remains<gcd.max*4&buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight)|
--	(buff.pyromaniac.up&cooldown.combustion.remains<ceil(buff.pyromaniac.remains%gcd.max)*(gcd.max+talent.kindling.enabled)))
end

function CombustionSequence()
	--# Combustion Sequence
	--actions.combust_sequence=stop_pyro_chain,if=cooldown.combustion.duration-cooldown.combustion.remains<15
	--actions.combust_sequence+=/prismatic_crystal
	--actions.combust_sequence+=/blood_fury
	--actions.combust_sequence+=/berserking
	if castSpell("player",Berserkering,true,true) then
		return true
	end
end


function FireSingleTarget()


	--actions.combust_sequence+=/arcane_torrent
	--actions.combust_sequence+=/potion,name=draenic_intellect
	--actions.combust_sequence+=/fireball,if=!dot.ignite.ticking&!in_flight
	if not targetDebuffIgnite and not player.isCasting == Fireball then 
		if castFireball("target") then
			return true
		end
	end
	
	--actions.combust_sequence+=/pyroblast,if=buff.pyroblast.up
    if playerBuffPyroBlast then 
        CastSpellByName("Pyroblast", target)
        return true
    end
	--# Meteor Combustions can run out of Pyro procs before impact. Use IB to delay Combustion
	--actions.combust_sequence+=/inferno_blast,if=talent.meteor.enabled&cooldown.meteor.duration-cooldown.meteor.remains<gcd.max*3
	--actions.combust_sequence+=/combustion  Todo : What? This does not make sence, we are not looking at ignite damage and hte code is not same as simcraft
    if not playerBuffPyroBlast and  targetDebuffIgnite  then 
    	if castSpell("target", Combustion,false,false) then
        --CastSpellByName("Combustion", target)
        return true
    	end
    end	
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
	if playerBuffPyroBlast and playerBuffHeatingUp and player.isCasting == Fireball
		then  
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
    if playerBuffPyroBlast and not playerBuffHeatingUp and playerspellFireballInFlight then
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

--if targetDebuffLivingBombRemain > 0 and targetNumberOfEnemiesinLBRange > 0 then 
--			if castSpell(target, InfernoBlast, false, false) then
--				return true
--			end
--		end 

		-- actions.living_bomb+=/living_bomb,cycle_targets=1, if=target!=prismatic_crystal&(active_dot.living_bomb=0|(ticking&active_dot.living_bomb=1))&(((!talent.incanters_flow.enabled|incanters_flow_dir<0|buff.incanters_flow.stack=5)&remains<3.6)|((incanters_flow_dir>0|buff.incanters_flow.stack=1)&remains<gcd.max))&target.time_to_die>remains+12
--		
--	end