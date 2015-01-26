if select(3, UnitClass("player")) == 11 then
    function RestorationConfig()
        if currentConfig ~= "Restoration Masou" then
            ClearConfig()
            thisConfig = 0
            imDebugging = false
            -- Title
            CreateNewTitle(thisConfig,"Restoration |cffFF0000Masoud")

            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"---------- Buffs ---------")

            -- Mark Of The Wild
            CreateNewCheck(thisConfig,"Mark Of The Wild")
            CreateNewText(thisConfig,"Mark Of The Wild")

            -- Nature's Cure
            CreateNewCheck(thisConfig,"Nature's Cure")
            CreateNewDrop(thisConfig,"Nature's Cure", 1, "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.",
                "|cffFFDD11MMouse",
                "|cffFFDD11MRaid",
                "|cff00FF00AMouse",
                "|cff00FF00ARaid")
            CreateNewText(thisConfig,"Nature's Cure")

            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"------ Resurrection ------")

    		 	CreateNewCheck(thisConfig,"MouseOver Rebirth")
                CreateNewText(thisConfig,"MouseOver Rebirth")

    		    CreateNewCheck(thisConfig,"Revive")
                CreateNewText(thisConfig,"Revive")
    		-- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"---- Level 60 Talent ---")

            if isKnown(114107) then
                -- Harmoney SotF
                CreateNewCheck(thisConfig,"Harmoney SotF")
                CreateNewBox(thisConfig, "Harmoney SotF",0,100,5,40,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 to refresh Harmoney during |cffFFFFFFSotF.")
                CreateNewText(thisConfig,"Harmoney SotF")

                -- WildGrowth SotF
                CreateNewCheck(thisConfig,"WildGrowth SotF")
                CreateNewBox(thisConfig, "WildGrowth SotF",0,100,5,45,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWild Growth with SotF.")
                CreateNewText(thisConfig,"WildGrowth SotF")

                -- WildGrowth SotF Count
                CreateNewCheck(thisConfig,"WildGrowth SotF Count")
                CreateNewBox(thisConfig, "WildGrowth SotF Count",1,25,1,3,"|cffFFBB00Number of members under Wildgrowth SotF treshold to use |cffFFFFFFWild Growth with SotF.")
                CreateNewText(thisConfig,"WildGrowth SotF Count")
            elseif isKnown(102693) then
                -- Force of Nature
                CreateNewCheck(thisConfig,"Force of Nature")
                CreateNewBox(thisConfig, "Force of Nature",0,100,5,45,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFForce of Nature.")
                CreateNewText(thisConfig,"Force of Nature")

                -- Force of Nature Count
                CreateNewCheck(thisConfig,"Force of Nature Count")
                CreateNewBox(thisConfig, "Force of Nature Count",1,25,1,3,"|cffFFBB00Number of members under Force of Nature threshold needed to use |cffFFFFFFForce of Nature.")
                CreateNewText(thisConfig,"Force of Nature Count")
            elseif isKnown(33891) then
               -- Germination Tol
                CreateNewCheck(thisConfig,"Germination Tol")
                CreateNewBox(thisConfig, "Germination Tol",0,100,5,90,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 while in Tree of Life. \n|cffFFDD11Used after Rejuvenation if Rejuvenation All Tol is not selected.")
                CreateNewText(thisConfig,"Germination Tol")
    		   -- Germination All Tol
    		   CreateNewCheck(thisConfig,"Germination All Tol")
                CreateNewText(thisConfig,"Germination All Tol")
    		   -- Rejuvenation Tol
                CreateNewCheck(thisConfig,"Rejuvenation Tol")
                CreateNewBox(thisConfig, "Rejuvenation Tol",0,100,5,90,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation|cffFFBB00 while in Tree of Life. \n|cffFFDD11Used after Rejuvenation if Rejuvenation All Tol is not selected.")
                CreateNewText(thisConfig,"Rejuvenation Tol")

                -- Rejuvenation All Tol
                CreateNewCheck(thisConfig,"Rejuvenation All Tol")
                CreateNewText(thisConfig,"Rejuvenation All Tol")

                -- Regrowth Tol
                CreateNewCheck(thisConfig,"Regrowth Tol")
                CreateNewBox(thisConfig, "Regrowth Tol",0,100,5,40,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life.")
                CreateNewText(thisConfig,"Regrowth Tol")

                -- Regrowth Tank Tol
                CreateNewCheck(thisConfig,"Regrowth Tank Tol")
                CreateNewBox(thisConfig, "Regrowth Tank Tol",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 on tanks while in Tree of Life .")
                CreateNewText(thisConfig,"Regrowth Tank Tol")

                -- Regrowth Omen Tol
                CreateNewCheck(thisConfig,"Regrowth Omen Tol")
                CreateNewBox(thisConfig, "Regrowth Omen Tol",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 while in Tree of Life and Omen proc.")
                CreateNewText(thisConfig,"Regrowth Omen Tol")

                -- WildGrowth Tol
                CreateNewCheck(thisConfig,"WildGrowth Tol")
                CreateNewBox(thisConfig, "WildGrowth Tol",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.")
                CreateNewText(thisConfig,"WildGrowth Tol")

                -- Mushrooms Bloom Count
                CreateNewBox(thisConfig, "WildGrowth Tol Count",1,25,1,5,"|cffFFBB00Number of members under WildGrowth Tol threshold needed to use |cffFFFFFFWildGrowth|cffFFBB00 while in Tree of Life.")
                CreateNewText(thisConfig,"WildGrowth Tol Count")
            end


            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"--------- Healing -------")

            -- Genesis Tank
            CreateNewCheck(thisConfig,"Genesis Tank")
            CreateNewBox(thisConfig,"Genesis Tank",0,100,5,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis on a low health tank.")
            CreateNewText(thisConfig,"Genesis Tank")
            -- Germination
            CreateNewCheck(thisConfig,"Germination")
            CreateNewBox(thisConfig, "Germination",0,100,5,80,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation.")
            CreateNewText(thisConfig,"Germination")
    		-- Germination Tank
    		CreateNewCheck(thisConfig,"Germination Tank")
            CreateNewBox(thisConfig, "Germination Tank",0,100,5,65,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Tanks.")
            CreateNewText(thisConfig,"Germination Tank")
    		-- Germination All
    		CreateNewCheck(thisConfig,"Germination All","Check to force rejuv |cffFFBB00on all targets(low prio).")
            CreateNewText(thisConfig,"Germination All")
            -- Healing Touch Harmoney
            CreateNewCheck(thisConfig,"HT Harmoney")
            CreateNewText(thisConfig,"HT Harmoney")
            -- Healing Touch
            CreateNewCheck(thisConfig,"Healing Touch")
            CreateNewBox(thisConfig, "Healing Touch",0,100,5,65,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch.")
            CreateNewText(thisConfig,"Healing Touch")
            -- Healing Touch Tank
            CreateNewCheck(thisConfig,"Healing Touch Tank")
            CreateNewBox(thisConfig, "Healing Touch Tank",0,100,5,55,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 on Tanks.")
            CreateNewText(thisConfig,"Healing Touch Tank")

            -- Healing Touch Ns
            CreateNewCheck(thisConfig,"Healing Touch Ns")
            CreateNewBox(thisConfig, "Healing Touch Ns",0,100,5,25,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 with |cffFFFFFFNature Swiftness.")
            CreateNewText(thisConfig,"Healing Touch Ns")

            -- Healing Touch Sm
            CreateNewCheck(thisConfig,"Healing Touch Sm")
            CreateNewBox(thisConfig, "Healing Touch Sm", 0,100,5,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch|cffFFBB00 for |cffFFFFFF Sage Mender.")
            CreateNewText(thisConfig,"Healing Touch Sm")
            -- Lifebloom
            CreateNewCheck(thisConfig,"Lifebloom")
            CreateNewBox(thisConfig, "Lifebloom",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to |cffFFFFFFlet Lifebloom Bloom |cffFFBB00on Focus.")
            CreateNewText(thisConfig,"Lifebloom")
            -- Regrowth
            CreateNewCheck(thisConfig,"Regrowth")
            CreateNewBox(thisConfig, "Regrowth",0,100,5,65,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth.")
            CreateNewText(thisConfig,"Regrowth")

            -- Regrowth Tank
            CreateNewCheck(thisConfig,"Regrowth Tank")
            CreateNewBox(thisConfig, "Regrowth Tank",0,100,5,55,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 on Tanks.")
            CreateNewText(thisConfig,"Regrowth Tank")

            -- Regrowth Omen
            CreateNewCheck(thisConfig,"Regrowth Omen")
            CreateNewBox(thisConfig, "Regrowth Omen",0,100,5,80,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 with Omen of Clarity.")
            CreateNewText(thisConfig,"Regrowth Omen")

            -- Rejuvenation
            CreateNewCheck(thisConfig,"Rejuvenation")
            CreateNewBox(thisConfig, "Rejuvenation", 0,100,5,80,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation.")
            CreateNewText(thisConfig,"Rejuvenation")

            -- Rejuvenation Tank
            CreateNewCheck(thisConfig,"Rejuvenation Tank")
            CreateNewBox(thisConfig, "Rejuvenation Tank",0,100,5,65,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Tanks.")
            CreateNewText(thisConfig,"Rejuvenation Tank")

            -- Rejuvenation Meta
            CreateNewCheck(thisConfig,"Rejuvenation Meta","Check to force rejuv |cffFFBB00on all targets(meta proc).")
            CreateNewText(thisConfig,"Rejuvenation Meta")

            -- Rejuvenation All
            CreateNewCheck(thisConfig,"Rejuvenation All","Check to force rejuv |cffFFBB00on all targets(low prio).")
            CreateNewText(thisConfig,"Rejuvenation All")

            -- Rejuvenation Filler
            CreateNewCheck(thisConfig,"Rejuv Filler Count")
            CreateNewBox(thisConfig, "Rejuv Filler Count",1,25,1,5,"|cffFFBB00Number of members to keep |cffFFFFFFRejuvenation |cffFFBB00as Filler.")
            CreateNewText(thisConfig,"Rejuv Filler Count")

            -- Rejuvenation Debuff
            CreateNewCheck(thisConfig,"Rejuvenation Debuff")
            CreateNewBox(thisConfig, "Rejuvenation Debuff",0,100,5,65,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation |cffFFBB00on Debuffed units.")
            CreateNewText(thisConfig,"Rejuvenation Debuff")

            -- if isKnown(114107) ~= true then
                -- Swiftmend
                CreateNewCheck(thisConfig,"Swiftmend")
                CreateNewBox(thisConfig, "Swiftmend",0,100,5,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend.")
                CreateNewText(thisConfig,"Swiftmend")

                -- Harmoney
                CreateNewCheck(thisConfig,"Swiftmend Harmoney")
                CreateNewBox(thisConfig, "Swiftmend Harmoney",0,100,5,40,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFSwiftmend|cffFFBB00 to refresh Harmoney.")
                CreateNewText(thisConfig,"Swiftmend Harmoney")
            -- end

    -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"----- AoE Healing -----")

            -- Genesis
            CreateNewCheck(thisConfig,"Genesis")
            CreateNewBox(thisConfig,"Genesis",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis.")
            CreateNewText(thisConfig,"Genesis")

            -- Genesis Count
            CreateNewBox(thisConfig, "Genesis Count",1,25,1,5,"|cffFFBB00Number of members under Genesis threshold needed to use |cffFFFFFFGenesis.")
            CreateNewText(thisConfig,"Genesis Count")

            -- Genesis Filler
            CreateNewCheck(thisConfig,"Genesis Filler")
            CreateNewBox(thisConfig, "Genesis Filler",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFGenesis |cffFFBB00as Filler(low prio).")
            CreateNewText(thisConfig,"Genesis Filler")

            -- Mushrooms
            CreateNewCheck(thisConfig,"Mushrooms")
            CreateNewBox(thisConfig,"Mushrooms",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWild Mushrooms.")
            CreateNewText(thisConfig,"Mushrooms")

            -- Mushrooms on Who
            CreateNewDrop(thisConfig,"Mushrooms Who",1,"|cffFFBB00Tank:|cffFFFFFFAlways on the tank. \n|cffFFBB003 Units:|cffFFFFFFWill always try to cast on 3 of lowest units.|cffFF1100Note: If Tank selected and no Focus defined, will use on 3 targets.",
                "|cffFFDD11Tank",
                "|cffFFDD113 Units")
            CreateNewText(thisConfig,"Mushrooms Who")

            -- WildGrowth
            CreateNewCheck(thisConfig,"WildGrowth")
            CreateNewBox(thisConfig, "WildGrowth",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth.")
            CreateNewText(thisConfig,"WildGrowth")

            -- WildGrowth Count
            CreateNewBox(thisConfig, "WildGrowth Count",1,25,1,5,"|cffFFBB00Number of members under WildGrowth threshold needed to use |cffFFFFFFWildGrowth.")
            CreateNewText(thisConfig,"WildGrowth Count")

            -- WildGrowth All
            CreateNewCheck(thisConfig,"WildGrowth All")
            CreateNewBox(thisConfig, "WildGrowth All",0,100,5,85,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWildGrowth.")
            CreateNewText(thisConfig,"WildGrowth All")

            -- WildGrowth All Count
            CreateNewBox(thisConfig, "WildGrowth All Count",1,25,1,5,"|cffFFBB00Number of members under WildGrowth threshold needed to use |cffFFFFFFWildGrowth.")
            CreateNewText(thisConfig,"WildGrowth All Count")

    -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"------- Defensive ------")

            -- Barkskin
            CreateNewCheck(thisConfig,"Barkskin")
            CreateNewBox(thisConfig, "Barkskin",0,100,5,40,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
            CreateNewText(thisConfig,"Barkskin")

            -- Healthstone
            CreateNewCheck(thisConfig,"Healthstone")
            CreateNewBox(thisConfig, "Healthstone",0,100,5,25,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
            CreateNewText(thisConfig,"Healthstone")


            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"-------- Toggles --------")
            -- DPS Toggle
            CreateNewCheck(thisConfig,"DPS Toggle")
            CreateNewDrop(thisConfig,"DPS Toggle",1,"Toggle2")
            CreateNewText(thisConfig,"DPS Toggle")
            -- Focus Toggle
            CreateNewCheck(thisConfig,"Focus Toggle")
            CreateNewDrop(thisConfig,"Focus Toggle",2,"Toggle2")
            CreateNewText(thisConfig,"Focus Toggle")
            -- Genesis Toggle
            CreateNewCheck(thisConfig,"Genesis Toggle")
            CreateNewDrop(thisConfig,"Genesis Toggle",4,"Toggle2")
            CreateNewText(thisConfig,"Genesis Toggle")
            -- Pause Toggle
            CreateNewCheck(thisConfig,"Pause Toggle")
            CreateNewDrop(thisConfig,"Pause Toggle",3,"Toggle2")
            CreateNewText(thisConfig,"Pause Toggle")
            -- Rebirth
            CreateNewCheck(thisConfig,"Rebirth Toggle")
            CreateNewDrop(thisConfig,"Rebirth Toggle",9,"Toggle2")
            CreateNewText(thisConfig,"Rebirth Toggle")
            -- Regrowth Toggle
            CreateNewCheck(thisConfig,"Regrowth Toggle")
            CreateNewDrop(thisConfig,"Regrowth Toggle",5,"Toggle2")
            CreateNewText(thisConfig,"Regrowth Toggle")
            -- Reju  Toggle
            CreateNewCheck(thisConfig,"Reju Toggle")
            CreateNewDrop(thisConfig,"Reju Toggle",7,"Toggle2")
            CreateNewText(thisConfig,"Reju Toggle")
            -- Reju  Toggle Mode
            CreateNewDrop(thisConfig,"Reju Toggle Mode",1,"|cffFFBB00Toggle: |cffFFFFFFTap button to toggle ON/OFF. \n|cffFF0000Hold: |cffFFFFFFHold button to stay ON.",
                "|cffFFBB00Toggle",
                "|cffFF0000Hold")
            CreateNewText(thisConfig,"Reju Toggle Mode")
            -- WildGroth Toggle
            CreateNewCheck(thisConfig,"WG Toggle")
            CreateNewDrop(thisConfig,"WG Toggle",6,"Toggle2")
            CreateNewText(thisConfig,"WG Toggle")
            -- Wild mushroom Toggle
    		CreateNewCheck(thisConfig,"WildMushroom")
            CreateNewDrop(thisConfig,"WildMushroom",8,"Toggle2")
            CreateNewText(thisConfig,"WildMushroom")




            -- Wrapper -----------------------------------------
            CreateNewWrap(thisConfig,"------ Utilities ------")

            -- No Kitty DPS
            CreateNewCheck(thisConfig,"No Kitty DPS","|cffFF0011Check |cffFFDD11this to prevent |cffFFFFFFKitty |cffFFDD11DPS",0)
            CreateNewText(thisConfig,"No Kitty DPS")

            -- Multidotting
            CreateNewCheck(thisConfig,"Multidotting","|cffFF0011Check |cffFFDD11this to allow |cffFFFFFFMoonfire |cffFFDD11Multidotting",0)
            CreateNewText(thisConfig,"Multidotting")

            -- Safe DPS Threshold
            CreateNewCheck(thisConfig,"Safe DPS Threshold","|cffFF0011Check |cffFFFFFF to force healing when units in your group fall under threshold.")
            CreateNewBox(thisConfig, "Safe DPS Threshold",1,100,5,45,"|cffFFBB00What threshold you want to force start healing allies while DPSing.")
            CreateNewText(thisConfig,"Safe DPS Threshold")

            --[[ Follow Tank
            CreateNewCheck(thisConfig,"Follow Tank")
            CreateNewBox(thisConfig, "Follow Tank",10,40,1,25,"|cffFFBB00Range from focus...")
            CreateNewText(thisConfig,"Follow Tank")]]

            if imDebugging == true then
                CreateNewCheck(thisConfig,"Debugging Mode")
                CreateNewText(thisConfig,"Debugging Mode")
            end



            -- General Configs
            CreateGeneralsConfig()


            WrapsManager()
        end
    end

end