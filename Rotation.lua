---------------------
-- Main handler of the bot
--		This handler will be the Rotation handler and the main function for each pulse of the bot.
--		It is called by the core:BadRobotUpdate(self) every 10 ms
--		This is for all purpose the bot hearth where we define what we do each time it ticks
--------------------
rotation = {}
print("Rotation Handler Loaded")

function rotation:init()
	
end	
-------------------------
-- Rotation Update is called every time Bad Robot "ticks" and handles the rotation aspect of the bot
------------------------- 
function rotation:update()
	--[[Class/Spec Selector]]
    local playerClass = select(3,UnitClass("player"))
    local playerSpec = GetSpecialization()
    if playerClass == 1 then -- Warrior
        if playerSpec == 2 then
            FuryWarrior()
        elseif playerSpec == 3 then
            ProtectionWarrior()
        else
            ArmsWarrior()
        end
    elseif playerClass == 2 then -- Paladin
        if playerSpec == 1 then
            PaladinHoly()
        elseif playerSpec == 2 then
            PaladinProtection()
        elseif playerSpec == 3 then
            PaladinRetribution()
        end
    elseif playerClass == 3 then -- Hunter
        if playerSpec == 1 then
            BeastHunter()
        elseif playerSpec == 2 then
            MarkHunter()
        else
            SurvHunter()
        end
    elseif playerClass == 4 then -- Rogue
        if playerSpec == nil then
            NewRogue()
        end
        if playerSpec == 1 then
            AssassinationRogue()
        elseif playerSpec == 2 then
            CombatRogue()
        elseif playerSpec == 3 then
            SubRogue()            
        end
    elseif playerClass == 5 then -- Priest
        if playerSpec == 3 then
            PriestShadow()
        end
        if playerSpec == 1 then
            PriestDiscipline()
        end
    elseif playerClass == 6 then -- Deathknight
        if playerSpec == 1 then
            Blood()
        end
        if playerSpec == 2 then
            FrostDK()
        end
        if playerSpec == 3 then
            UnholyDK()
        end
    elseif playerClass == 7 then -- Shaman
        if playerSpec == 1 then
            ShamanElemental()
        end
        if playerSpec == 2 then
            ShamanEnhancement()
        end
        if playerSpec == 3 then
            ShamanRestoration()
        end
    elseif playerClass == 8 then -- Mage
        Mage()
    elseif playerClass == 9 then -- Warlock
        if playerSpec == 2 then
            WarlockDemonology()
        elseif playerSpec == 3 then
            WarlockDestruction()
        end
    elseif playerClass == 10 then -- Monk
        if playerSpec == nil then
            NewMonk()
        end 
    if playerSpec == 1 then
        BrewmasterMonk()
    elseif playerSpec == 2 then
        MistweaverMonk();
    elseif playerSpec == 3 then
        WindwalkerMonk()
        end
    elseif playerClass == 11 then -- Druid
        if playerSpec == 1 then
            DruidMoonkin()
        end
        if playerSpec == 2 then
            DruidFeral()
        end
        if playerSpec == 3 then
            DruidGuardian()
        end
        if playerSpec == 4 then
            DruidRestoration()
        end
    end
end	
	

function rotation:close()
	--should release all objects created by the main handler
	--player.close()
	--targets.close()
	
end	