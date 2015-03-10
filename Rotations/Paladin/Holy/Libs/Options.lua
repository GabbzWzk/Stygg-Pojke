if select(3,UnitClass("player")) == 2 then

  function PaladinHolyOptions()
    ClearConfig()
    local myColor = ""
    local redColor = ""
    local whiteColor = "|cffFFFFFF"
    local myClassColor = classColors[select(3,UnitClass("player"))].hex
    local function myWrapper(Value)
      CreateNewWrap(thisConfig,"--- "..Value.." ---")
    end
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,myClassColor.."Holy"..whiteColor.." Gabbz & CodeMyLife")

    -- Buffs
    myWrapper("Buffs")

    -- Blessing
    CreateNewCheck(thisConfig,"Blessing","Normal",1)
    CreateNewDrop(thisConfig,"Blessing",1,"Select which blessing you want to use.","|cff006AFFKings","|cffFFAE00Might")
    CreateNewText(thisConfig,myColor.."Blessing")

    -- Seal
    CreateNewCheck(thisConfig,"Seal Of Insight","Normal",1)
    CreateNewText(thisConfig,myColor.."Seal Of Insight")

    -- Cooldowns
    myWrapper("Cooldowns")

    -- Avenging Wrath
    --CreateNewCheck(thisConfig,"Avenging Wrath")
    --CreateNewDrop(thisConfig,"Avenging Wrath", 1,"CD")
    --CreateNewText(thisConfig,myColor.."Avenging Wrath")

    --if isKnown(_HolyAvenger) then
      -- Holy Avenger
     -- CreateNewCheck(thisConfig,"Holy Avenger")
     -- CreateNewDrop(thisConfig,"Holy Avenger",1,"CD")
     -- CreateNewText(thisConfig, myColor.."Holy Avenger")
    --elseif isKnown(_SanctifiedWrath) then
      -- Sanctified Wrath
     -- CreateNewCheck(thisConfig,"Sanctified Wrath")
     -- CreateNewDrop(thisConfig,"Sanctified Wrath",1,"CD")
     -- CreateNewText(thisConfig,myColor.."Sanctified Wrath")
    --end

    --if isKnown(_LightsHammer) then
      -- Light's Hammer
      --CreateNewCheck(thisConfig,"Light's Hammer")
      --CreateNewDrop(thisConfig,"Light's Hammer",1,"CD")
      --CreateNewText(thisConfig,myColor.."Light's Hammer")
    --end

    -- Defensive
    myWrapper("Defensive")

    -- Divine Protection
    --CreateNewCheck(thisConfig,"Divine Protection Holy","Normal",1)
    --CreateNewBox(thisConfig,"Divine Protection Holy",0,100,1,75,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
    --CreateNewText(thisConfig,myColor.."Divine Protection Holy")

    -- Healing
    myWrapper("Healing")

    CreateNewCheck(thisConfig,"Critical Health Level","Normal",1)
    CreateNewBox(thisConfig,"Critical Health Level",0,100,1,50,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFfast heals")
    CreateNewText(thisConfig,myColor.."Critical Health Level")

    -- Setting the mode, sustained, beacon intensive and burst
    CreateNewCheck(thisConfig,"Healing Mode","Normal",1)
    CreateNewDrop(thisConfig, "Healing Mode", 2, "Choose mode:\nNormal, sustained healing\nFoL/Radiance on Beacon Targets.\nBurst Healing", "Sustained","Beacon","Burst")
    CreateNewText(thisConfig,myColor.."Healing Mode")

    -- Config for setting using mana intensive heals on beacons
    --CreateNewCheck(thisConfig,"FoL/HR Beacons","Normal",1)
    --CreateNewBox(thisConfig,"FoL/HR Beacons",0,100,1,50,"|cffFFBB00Check if we should cast FoL and Holy Radiance on beacons, value set to how mana is minimum")
    --CreateNewText(thisConfig,myColor.."FoL/HR Beacons")

    CreateNewCheck(thisConfig, "Beacon Of Light","Normal",1)
    CreateNewDrop(thisConfig, "Beacon Of Light", 2, "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic", "TANK","FOCUS","WISE")
    CreateNewText(thisConfig, myColor.."Beacon Of Light")

    -- Beacon of Faith
    if isKnown(_BeaconOfFaith) then
      CreateNewCheck(thisConfig, "Beacon Of Faith","Normal",1)
      CreateNewDrop(thisConfig, "Beacon Of Faith", 2, "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic", "TANK","FOCUS","WISE")
      CreateNewText(thisConfig, myColor.."Beacon Of Faith")
    end

    -- Tier 6 talents
    if isKnown(_HolyPrism) then
      -- Mode, cast always as heal or always as damage or dynamic
      CreateNewCheck(thisConfig, "Holy Prism Mode","Normal",1)
      CreateNewDrop(thisConfig, "Holy Prism Mode", 2, "Choose mode:\nCast on Enemy to heal Friends\nCast on Friend \nWise - Cast on Friend if no AoE", "Enemy", "Friend","WISE")
      CreateNewText(thisConfig, myColor.."Holy Prism Mode")
    elseif isKnown(_LightsHammer) then
      CreateNewCheck(thisConfig, "Lights Hammer","Normal",1)
      CreateNewBox(thisConfig, "Lights Hammer", 0, 100  , 1, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLights Hammer")
      CreateNewText(thisConfig, myColor.."Lights Hammer")
    else
      CreateNewCheck(thisConfig, "Execution Sentence","Normal",1)
      CreateNewBox(thisConfig, "Execution Sentence", 0, 100  , 1, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFExecution Sentence")
      CreateNewText(thisConfig, myColor.."Execution Sentence")
    end

    -- Tier 6 talents
    if isKnown(_EternalFlame) then
      -- Mode, cast always as heal or always as damage or dynamic
      CreateNewCheck(thisConfig, "Eternal Flame","Normal",1)
      CreateNewBox(thisConfig, "Eternal Flame", 0, 90  , 1, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame")
      CreateNewText(thisConfig, myColor.."Eternal Flame")
    elseif isKnown(_SacredShield) then
      CreateNewCheck(thisConfig, "Sacred Shield","Normal",1)
      CreateNewDrop(thisConfig, "Sacred Shield", 2, "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic", "TANK","FOCUS","WISE")
      CreateNewText(thisConfig, myColor.."Sacred Shield")
    end

    CreateNewCheck(thisConfig,"Flash Of Light","Normal",1)
    CreateNewBox(thisConfig,"Flash Of Light",0,100,1,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFFlash Of Light")
    CreateNewText(thisConfig,myColor.."Flash Of Light")

    CreateNewCheck(thisConfig,"Lay On Hands","Normal",1)
    CreateNewBox(thisConfig,"Lay On Hands",0,100,1,12,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands")
    CreateNewText(thisConfig,myColor.."Lay On Hands")

    CreateNewCheck(thisConfig,"LoH Targets","Normal",1)
    CreateNewDrop(thisConfig,"LoH Targets",1,"|cffFF0000Which Targets\n|cffFFBB00We want to use \n|cffFFFFFFLay On Hands", "|cffFF0000Me.Only", "|cffFFDD11Me.Prio", "|cff00FBEETank/Heal","|cff00FF00All")
    CreateNewText(thisConfig,myColor.."LoH Targets")

    
    -- AoE Healing
    myWrapper("AoE Healing")

    CreateNewCheck(thisConfig,"HR Missing Health","Normal",1)
    CreateNewText(thisConfig,myColor.."HR Missing Health")

    CreateNewBox(thisConfig,"HR Units",0,25,1,3,"|cffFFBB00Minimum number of |cffFF0000%Units|cffFFBB00 to use \n|cffFFFFFFHoly Radiance")
    CreateNewText(thisConfig,myColor.."HR Units")

    -- Utilities
    myWrapper("Utilities")

    -- Rebuke
    CreateNewCheck(thisConfig,"Rebuke")
    CreateNewBox(thisConfig,"Rebuke",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")
    CreateNewText(thisConfig,myColor.."Rebuke")

    -- Nature's Cure
    CreateNewCheck(thisConfig,"Dispell")
    CreateNewDrop(thisConfig,"Dispell", 1, "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.",
      "|cffFFDD11MMouse",
      "|cffFFDD11MRaid",
      "|cff00FF00AMouse",
      "|cff00FF00ARaid")
    CreateNewText(thisConfig,"Dispell")

    -- General Configs
    CreateGeneralsConfig()

    WrapsManager()
  end
end
