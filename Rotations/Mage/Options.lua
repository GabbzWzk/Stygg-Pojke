if select(3, UnitClass("player")) == 8 then

	 
	 function titleOp(string)
        return CreateNewTitle(thisConfig,string)
    end
    function checkOp(string,tip)
        if tip == nil then
            return CreateNewCheck(thisConfig,string)
        else
            return CreateNewCheck(thisConfig,string,tip)
        end
    end
    function textOp(string)
        return CreateNewText(thisConfig,string)
    end
    function wrapOp(string)
        return CreateNewWrap(thisConfig,string)
    end
    function boxOp(string, minnum, maxnum, stepnum, defaultnum, tip)
        if tip == nil then
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum)
        else
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum, tip)
        end
    end
    function dropOp(string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
        return CreateNewDrop(thisConfig, string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
    end

    function MageConfig()
		if currentConfig ~= "Mage Gabbz" then
			ClearConfig()
			thisConfig = 0
			--[[Title]]
			titleOp("Mage Gabbz")

			-- Wrapper -----------------------------------------
			wrapOp("--- Buffs ---")
				checkOp("Arcane Brilliance")  -- Set the config under each wrap intendent so its clear what the options it is
				textOp("Arcane Brilliance")

			-- Wrapper -----------------------------------------
			textOp(" ") -- To get some space in config
			wrapOp("--- DPS Cooldowns ---")

				-- Todo : Under what options could we code in offensive CDs? On CD, Start and BL, Smart
				dropOp("DPS Option", 1, "Specify when to use DPS CDs.", "|cffFFBB00on CD", "|cff0077FFOpener/Bloodlust")
				textOp("DPS Option")
				
				-- Start with generic ones that all should use, like racials, pots, trinkets
				checkOp("Racial")
				textOp("Racial")

				checkOp("Trinkets")  -- We forces the user to have on use trinkets on the first slot
				textOp("Trinkets")

				checkOp("DPS Potions")
				textOp("DPS Potions")

				if isKnown(MirrorImage) then
					checkOp("Mirror Image")
					textOp("Mirror Image")
				end

				if isKnown(PrismaticCrystal) then
					checkOp("Prismatic Crystal")
					dropOp("Prismatic Crystal Option", 1, "Specify where to place", "|cffFFBB00Target", "|cff0077FFMouseover")
					textOp("Prismatic Crystal")
				end

				if isKnown(ColdSnap) then
					checkOp("Cold Snap")
					textOp("Cold Snap")
				end
				if player.specc == 1 then 				-- Arcane 
				 	if isKnown(ArcanePower) then	
						checkOp("Arcane Power")
						textOp("Arcane Power")
					end
			 	elseif player.specc  == 2 then 			-- Fire
			 		
			 	else                                 	-- Frost
			 		if isKnown(IcyVeins) then
						checkOp("Icy Veins")
						textOp("Icy Veins")
					end
			 	end	

			-- Wrapper -----------------------------------------
			wrapOp("--- Defensives ---")

				-- Healthstone
				checkOp("Healthstone")
				boxOp("Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone")
				textOp("Healthstone")

				checkOp("Def Potions")
				boxOp("Def Potions", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFPotion")
				textOp("Def Potions")
				-- Todo : more generic defensives?

				if isKnown(Evanesce) then
					checkOp("Evanesce")
					boxOp("Evanesce", 0, 100  , 5, 30, "|cffFFBB00Under what |cff69ccf0%HP|cffFFBB00 cast |cff69ccf0Evanesce.")
					textOp("Evanesce")
				else
					checkOp("Ice Block")
					boxOp("Ice Block", 0, 100  , 5, 30, "|cffFFBB00Under what |cff69ccf0%HP|cffFFBB00 cast |cff69ccf0Ice Block.")
					textOp("Ice Block")
				end

				--Todo : Greater Invisibility

			-- Wrapper -----------------------------------------
			wrapOp("--- Rotation ---")
				-- Manual rotation selection, possible to select different rotations on the fly			
				dropOp("RotationSelect", 1, "Choose Rotation to use.", "|cffFFBB00Standard", "|cff0077FFNot Implemented")
				textOp("Rotation Priority")

				if player.specc == 1 then 				-- Arcane 
					checkOp("Arcane Blast")
					boxOp("ArcaneBlast (x4)", 80, 100  , 1, 93, "|cffFFBB00Under what |cff69ccf0%Mana|cffFFBB00 dont cast |cff69ccf0Arcane Blast at 4 stacks.")
					textOp("ArcaneBlast (x4)")
				end
					checkOp("Burn Phase", ", Used for offensive CDs such as combustion, icy viens, Arcane Power")
					textOp("Burn Phase")

			--[[General Configs]]
			CreateGeneralsConfig()
			WrapsManager()
		end
	end
end