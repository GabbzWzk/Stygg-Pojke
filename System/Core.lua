function bb:Engine()
    -- Hidden Frame
    if Pulse_Engine == nil then
        Pulse_Engine = CreateFrame("Frame", nil, UIParent)
        Pulse_Engine:SetScript("OnUpdate", BadRobotUpdate)
        Pulse_Engine:Show()
    end
end

-- Chat Overlay: Originally written by Sheuron.
local function onUpdate(self,elapsed)
    if self.time < GetTime() - 2.0 then if self:GetAlpha() == 0 then self:Hide(); else self:SetAlpha(self:GetAlpha() - 0.02); end end
end
chatOverlay = CreateFrame("Frame",nil,ChatFrame1)
chatOverlay:SetSize(ChatFrame1:GetWidth(),50)
chatOverlay:Hide()
chatOverlay:SetScript("OnUpdate",onUpdate)
chatOverlay:SetPoint("TOP",0,0)
chatOverlay.text = chatOverlay:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
chatOverlay.text:SetAllPoints()
chatOverlay.texture = chatOverlay:CreateTexture()
chatOverlay.texture:SetAllPoints()
chatOverlay.texture:SetTexture(0,0,0,.50)
chatOverlay.time = 0
function ChatOverlay(Message, FadingTime)
    if getOptionCheck("Overlay Messages") then
        chatOverlay:SetSize(ChatFrame1:GetWidth(),50)
        chatOverlay.text:SetText(Message)
        chatOverlay:SetAlpha(1)
        if FadingTime == nil then
            chatOverlay.time = GetTime()
        else
            chatOverlay.time = GetTime() - 2 + FadingTime
        end
        chatOverlay:Show()
    end
end

function bb:MinimapButton()
    local dragMode = nil --"free", nil
    local function moveButton(self)
        local centerX, centerY = Minimap:GetCenter()
        local x, y = GetCursorPosition()
        x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
        centerX, centerY = math.abs(x), math.abs(y)
        centerX, centerY = (centerX / math.sqrt(centerX^2 + centerY^2)) * 76, (centerY / sqrt(centerX^2 + centerY^2)) * 76
        centerX = x < 0 and -centerX or centerX
        centerY = y < 0 and -centerY or centerY
        self:ClearAllPoints()
        self:SetPoint("CENTER", centerX, centerY)
    end

    local button = CreateFrame("Button", "BadRobotButton", Minimap)
    button:SetHeight(25)
    button:SetWidth(25)
    button:SetFrameStrata("MEDIUM")
    button:SetPoint("CENTER", 75.70,-6.63)
    button:SetMovable(true)
    button:SetUserPlaced(true)
    button:SetNormalTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
    button:SetPushedTexture("Interface\\HelpFrame\\HotIssueIcon.blp")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-Background.blp")

    button:SetScript("OnMouseDown",function(self, button)
        if button == "RightButton" then
            if BadRobot_data.options[GetSpecialization()] then
                if currentProfileName == nil then
                    if FireHack == true then
                        print("|cffFF1100BadRobot |cffFFFFFFStart/Stop is |cffFF1100Stopped |cffFFFFFFin General Options. Use left click to see the Options panel.")
                    else
                        print("|cffFF1100BadRobot |cffFFFFFFCannot Start... |cffFF1100Firehack |cffFFFFFFis not loaded. Please attach Firehack.")
                    end
                else
                    if BadRobot_data.options[GetSpecialization()][currentProfileName.."Frame"] ~= true then
                        _G[currentProfileName.."Frame"]:Show()
                        BadRobot_data.options[GetSpecialization()][currentProfileName.."Frame"] = true
                    else
                        _G[currentProfileName.."Frame"]:Hide()
                        BadRobot_data.options[GetSpecialization()][currentProfileName.."Frame"] = false
                    end
                end
            end
        end
        if IsShiftKeyDown() and IsAltKeyDown() then
            self:SetScript("OnUpdate",moveButton)
        end
    end)
    button:SetScript("OnMouseUp",function(self)
        self:SetScript("OnUpdate",nil)
    end)
    button:SetScript("OnClick",function(self, button)
        if button == "LeftButton" then
            if IsShiftKeyDown() and not IsAltKeyDown() then
                if BadRobot_data["Main"] == 1 then
                    BadRobot_data["Main"] = 0
                    mainButton:Hide()
                else
                    BadRobot_data["Main"] = 1
                    mainButton:Show()
                end
            elseif not IsShiftKeyDown() and not IsAltKeyDown() then
                if BadRobot_data.options[GetSpecialization()] then
                    if BadRobot_data.options[GetSpecialization()]["optionsFrame"] ~= true then
                        optionsFrame:Show()
                        BadRobot_data.options[GetSpecialization()]["optionsFrame"] = true
                    else
                        optionsFrame:Hide()
                        BadRobot_data.options[GetSpecialization()]["optionsFrame"] = false
                    end
                end
            end
        end
    end)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
        GameTooltip:SetText("BadRobot The Ultimate Raider", 214/255, 25/255, 25/255)
        GameTooltip:AddLine("CodeMyLife - CuteOne - Masoud")
        GameTooltip:AddLine("Gabbz - Chumii - AveryKey")
        GameTooltip:AddLine("Ragnar - Cpoworks - Tocsin")
        GameTooltip:AddLine("Mavmins - CukieMunster - Magnu")
        GameTooltip:AddLine("Left Click to toggle config frame.", 1, 1, 1, 1)
        GameTooltip:AddLine("Shift+Left Click to toggle toggles frame.", 1, 1, 1, 1)
        GameTooltip:AddLine("Alt+Shift+LeftButton to drag.", 1, 1, 1, 1)
        GameTooltip:AddLine("Right Click to open profile options.", 1, 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

end

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[---------          ---           --------       -------           --------------------------------------------------------------------------------------------------------------------]]
--[[---------  -----  ----   ---------------  ----  -------  --------  ---------------------------------------------------------------------------------------------------]]
--[[---------  ----  -----           ------  ------  ------  ---------  ----------------------------------------------------------------------------------------------------------]]
--[[---------       ------  --------------             ----  ---------  -------------------------------------------------------------------------------------------------------------]]
--[[---------  ----  -----  -------------  ----------  ----  --------  -------------------------------------------------------------------------------------------------]]
--[[---------  -----  ----           ---  ------------  ---            -------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]



local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

function frame:OnEvent(event, arg1)
 	if event == "ADDON_LOADED" and arg1 == "BadRobot" then
 		bb:Run()
	end
end
frame:SetScript("OnEvent", frame.OnEvent)



--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]

--[[This function is refired everytime wow ticks. This frame is located in Core.lua]]
-----------------------------------
-- Bad Robot Update :  This function is the "pulsing" of Bad Robot. Every time wow updates, every 10ms, we are running the bot
-----------------------------------
function BadRobotUpdate(self)
    -- prevent ticking when firechack isnt loaded
    -- if user click power button, stop everything from pulsing.
    if not getOptionCheck("Start/Stop BadRobot") or BadRobot_data["Power"] ~= 1 then
        optionsFrame:Hide()
        _G["debugFrame"]:Hide()
        return false
    end

    if FireHack == nil then
        optionsFrame:Hide()
        _G["debugFrame"]:Hide()
        if getOptionCheck("Start/Stop BadRobot") then
            ChatOverlay("FireHack not Loaded.")
        end
        return
    end

    -- accept dungeon queues
    bb:AcceptQueues()
    -- pulse enemiesEngine
    bb:PulseUI()
    -- Check the 
    bb:MainHandler()
end

--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
--[[-------------------------------------------------------------------------------------------------------------------------------------------------------]]
