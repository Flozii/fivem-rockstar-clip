local menuopen = false
local mainm = RageUI.CreateMenu("Rockstar Editor", "Save clip with this menu")
local mainm2 = RageUI.CreateSubMenu(mainm, "Rockstar Editor", "Are you sure ?")
local closemenu = "NO"

mainm.Closed = function()
    menuopen = false
end

local function ShowLoadingPrompt(msg, type)
	BeginTextCommandBusyspinnerOn("STRING")
	AddTextComponentSubstringPlayerName(msg)
    EndTextCommandBusyspinnerOn(type)
end

local function ShowNotification(msg)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(true, true)
end

local function OpenClipMenu()
    menuopen = not menuopen -- opti
    RageUI.Visible(mainm, not RageUI.Visible(mainm))
    while menuopen do
        Wait(1)

        RageUI.IsVisible(mainm, function()
            RageUI.Separator("Optional")
            RageUI.Button("Close Menu", "Close the menu when you start recording", { RightLabel = closemenu }, true, {
                onSelected = function()
                    if string.upper(closemenu) == "NO" then
                        closemenu = "YES"
                    else
                        closemenu = "NO"
                    end
                end
            })
            RageUI.Separator("Recording")
            RageUI.Button("Start Recording", "Start recording.", {}, true, {
                onSelected = function()
                    if not IsRecording() then
                        if closemenu == "YES" then
                            RageUI:CloseAll()
                            menuopen = false
                        end
                        StartRecording(1)
                    else
                        ShowNotification("∑ You are already recording")
                    end
                end
            })

            RageUI.Button("Stop Recording and Save", "Stop recording and save the clip", {}, true, {
                onSelected = function()
                    if IsRecording() then
                        StopRecordingAndSaveClip()
                    else
                        ShowNotification("∑ You are not recording")
                    end
                end
            })

            RageUI.Button("Stop Recording and Discard", "Stop recording and discard the clip", {}, true, {
                onSelected = function()
                    if IsRecording() then
                        StopRecordingAndDiscardClip()
                    else
                        ShowNotification("∑ You are not recording")
                    end
                end
            })

            RageUI.Separator("Rockstar Editor")

            RageUI.Button("Open Rockstar Editor", "Leave the server and open rockstar editor", {}, true, {}, mainm2)            

        end)

        RageUI.IsVisible(mainm2, function()
            RageUI.Button("Yes", "I want to leave the server and open rockstar editor", {}, true, {
                onSelected = function()
                    if not IsRecording() then
                        RageUI:CloseAll()
                        menuopen = false
                        DoScreenFadeOut(1500)
                        ShowLoadingPrompt("Opening rockstar editor", 5)
                        Wait(2000)
                        ActivateRockstarEditor()
                        Wait(1000)
                        DoScreenFadeIn(1500)
                    else
                        ShowNotification("∑ You are recording, stop your recording first")
                    end
                end
            })
            RageUI.Button("No", "I don't want to leave the server and open rockstar editor", {}, true, {
                onSelected = function()
                    RageUI.GoBack()
                end
            })
        end)

    end
end


RegisterKeyMapping("+openclipsaver", "Menu rockstar editor", 'keyboard', 'F10')

RegisterCommand("+openclipsaver", function()
    OpenClipMenu()
end, false) -- not restricted