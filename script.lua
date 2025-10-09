print('[B3tterDev] Initializing data ..')
repeat wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:GetAttribute("DinoEventOnlineTime") ~= nil
print("[B3tterDev] Verification successful, this resource is READY to use")

task.spawn(function()
    while true do
        local pets = game:GetService("Players").LocalPlayer.PlayerGui.Data.Pets:GetChildren()
        for _, v in pairs(pets) do
            local petModel = game:GetService("Workspace"):FindFirstChild("Pets"):FindFirstChild(v.Name)
            if petModel and petModel:FindFirstChild("RootPart") and petModel.RootPart:FindFirstChild("RE") then
                local args = { "Claim" }
                petModel.RootPart.RE:FireServer(unpack(args))
            end
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        local pets = game:GetService("Workspace"):WaitForChild("Pets")
        for _, v in pairs(pets:GetChildren()) do
            local petModel = pets:FindFirstChild(v.Name)
            if petModel then
                local animCtrl = petModel:FindFirstChild("AnimationController")
                if animCtrl then
                    animCtrl:Destroy()
                end

                local MutateFX = petModel:FindFirstChild("MutateFX_Inst")
                if MutateFX then
                    MutateFX:Destroy()
                end
            end
        end

        local PlayerBuiltBlocks = game:GetService("Workspace"):WaitForChild("PlayerBuiltBlocks")
        for _, v in pairs(PlayerBuiltBlocks:GetChildren()) do
            local builtModel = PlayerBuiltBlocks:FindFirstChild(v.Name)
            if builtModel then
                local animCtrl = builtModel:FindFirstChild("AnimationController")
                if animCtrl then
                    animCtrl:Destroy()
                end

                local MutateFX = builtModel:FindFirstChild("MutateFX_Inst")
                if MutateFX then
                    MutateFX:Destroy()
                end
            end
        end

        task.wait(30)
    end
end)

local popupDrop = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("PopupDrop")
if popupDrop then popupDrop:Destroy() end

local Shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"))
local Formatter = Shared("Format")
local moneyStat = game:GetService("Players").LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Money $")
moneyStat.Changed:Connect(function(newValue)
    local coinHud = game:GetService("Players").LocalPlayer.PlayerGui.OverlaySafe:WaitForChild("CoinHud")
    local textLabel = coinHud:WaitForChild("Value")

    textLabel.Text = Formatter:Number2String(newValue, "en")
end)
