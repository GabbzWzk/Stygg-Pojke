if select(3,UnitClass("player")) == 6 then
    function KeyToggles()
        if GetSpecialization() == 2 then
         -- AoE Button
            if AoEModesLoaded ~= "Cute AoE Modes" then
                CustomAoEModes = {
                    [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = _HowlingBlast },
                    [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = _HowlingBlast },
                    [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = _IcyTouch }
                };
               AoEModes = CustomAoEModes
               CreateButton("AoE",1,0)
               AoEModesLoaded = "Cute AoE Modes";
            end

         -- Cooldowns Button
            if CooldownsModesLoaded ~= "Cute Cooldowns Modes" then
                CustomCooldownsModes = {
                    [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = _EmpowerRuneWeapon },
                    [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = _EmpowerRuneWeapon },
                    [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = _EmpowerRuneWeapon }
                };
               CooldownsModes = CustomCooldownsModes
               CreateButton("Cooldowns",2,0)
               CooldownsModesLoaded = "Cute Cooldowns Modes";
            end

         -- Defensive Button
            if DefensiveModesLoaded ~= "Cute Defensive Modes" then
                CustomDefensiveModes = {
                    [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = _IceboundFortitude },
                    [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = _IceboundFortitude }
                };
                DefensiveModes = CustomDefensiveModes
                CreateButton("Defensive",3,0)
                DefensiveModesLoaded = "Cute Defensive Modes";
            end

         -- Interrupts Button
            if InterruptsModesLoaded ~= "Cute Interrupt Modes" then
                CustomInterruptsModes = {
                    [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = _MindFreeze },
                    [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = _MindFreeze }
                };
                InterruptsModes = CustomInterruptsModes
                CreateButton("Interrupts",4,0)
                InterruptsModesLoaded = "Cute Interrupt Modes";
            end
         -- Cleave Button
            if CleaveModesLoaded ~= "Cute Cleave Modes" then
                CustomCleaveModes = {
                    [1] = { mode = "On", value = 1 , overlay = "Cleaving Enabled", tip = "Rotation will cleave targets.", highlight = 1, icon = _HowlingBlast },
                    [2] = { mode = "Off", value = 2 , overlay = "Cleaving Disabled", tip = "Rotation will not cleave targets", highlight = 0, icon = _IcyTouch }
                };
                CleaveModes = CustomCleaveModes
                CreateButton("Cleave",5,0)
                CleaveModesLoaded = "Cute Cleave Modes";
            end

            function SpecificToggle(toggle)
                if getOptionValue(toggle) == 1 then
                    return IsLeftControlKeyDown();
                elseif getOptionValue(toggle) == 2 then
                    return IsLeftShiftKeyDown();
                elseif getOptionValue(toggle) == 3 then
                    return IsRightControlKeyDown();
                elseif getOptionValue(toggle) == 4 then
                    return IsRightShiftKeyDown();
                elseif getOptionValue(toggle) == 5 then
                    return IsRightAltKeyDown();
                elseif getOptionValue(toggle) == 6 then
                    return false
                end
            end

            --AoE Key Toggle
            if AOETimer == nil then AOETimer = 0; end
            if SpecificToggle("Rotation") and not GetCurrentKeyBoardFocus() and GetTime() - AOETimer > 0.25 then
                AOETimer = GetTime()
                UpdateButton("AoE")
            end

            --Cooldown Key Toggle
            if CDTimer == nil then CDTimer = 0; end
            if SpecificToggle("Cooldowns") and not GetCurrentKeyBoardFocus() and GetTime() - CDTimer > 0.25 then
                CDTimer = GetTime()
                UpdateButton("Cooldowns")
            end

            --Defensive Key Toggle
            if DefTimer == nil then DefTimer = 0; end
            if SpecificToggle("Defensive") and not GetCurrentKeyBoardFocus() and GetTime() - DefTimer > 0.25 then
                DefTimer = GetTime()
                UpdateButton("Defensive")
            end

            --Interrupt Key Toggle
            if IntTimer == nil then IntTimer = 0; end
            if SpecificToggle("Interrupts") and not GetCurrentKeyBoardFocus() and GetTime() - IntTimer > 0.25 then
                IntTimer = GetTime()
                UpdateButton("Interrupts")
            end

            --Cleave Key Toggle
            if CleaveTimer == nil then CleaveTimer = 0; end
            if SpecificToggle("Cleave Mode") and not GetCurrentKeyBoardFocus() and GetTime() - CleaveTimer > 0.25 then
                CleaveTimer = GetTime()
                UpdateButton("Cleave")
            end
        end
    end
end