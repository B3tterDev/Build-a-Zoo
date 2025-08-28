local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Build a Zoo",
    SubTitle = "by B3tterDev",
    TabWidth = 100,
    Size = UDim2.fromOffset(500, 300),
    Resize = true,
    MinSize = Vector2.new(470, 300),
    Acrylic = false, 
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "หลัก", Icon = "" }),
} 

local HttpService = game:GetService("HttpService")
local Options = Fluent.Options

function SaveConfig(config)
    writefile("B3tterDev.json", HttpService:JSONEncode(config))
end

function LoadConfig()
    if isfile("B3tterDev.json") then
        local data = readfile("B3tterDev.json")
        return HttpService:JSONDecode(data)
    end
    return {}
end

local eggs = {}
local cfg = LoadConfig()

local Money = Tabs.Main:AddToggle("Money", { Title = "เก็บเงินอัตโนมัติ", Default = cfg.money or false })
local type = Tabs.Main:AddDropdown("type", {
    Title = "ประเภทไข่",
    Values = {
        "BasicEgg", 
        "RareEgg", 
        "SuperRareEgg", 
        "EpicEgg", 
        "LegendEgg",
        "PrismaticEgg",
        "HyperEgg",
        "VoidEgg",
        "BowserEgg",
        "DemonEgg",
        "CornEgg",
        "BoneDragonEgg",
        "UltraEgg",
        "DinoEgg",
        "FlyEgg",
        "UnicornEgg",
        "AncientEgg"
    },
    Multi = true,
    Default = cfg.type or {},
})

local mutations = Tabs.Main:AddDropdown("mutations", {
    Title = "ประเภทการกลายพันธุ์",
    Values = {
        "Golden", 
        "Diamond", 
        "Electric", 
        "Fire", 
        "Jurassic",
    },
    Multi = true,
    Default = cfg.mutations or {},
})

local limit = Tabs.Main:AddInput("Input", {
    Title = "เงินต้องเยอะกว่าเท่าไหร่ถึงจะซื้อไข่",
    Default = cfg.limit or 100000,
    Placeholder = "Placeholder",
    Numeric = true, -- Only allows numbers
    Finished = false, -- Only calls callback when you press enter
})

local Eggs = Tabs.Main:AddToggle("Eggs", { Title = "เก็บไข่อัตโนมัติ", Default = cfg.eggs or false })

Money:OnChanged(function()
    cfg.money = Options.Money.Value
    SaveConfig(cfg)
    if not Options.Money.Value then return end
    task.spawn(function()
        while Options.Money.Value do
            local pets = game:GetService("Players").LocalPlayer.PlayerGui.Data.Pets:GetChildren()
            for _, v in pairs(pets) do
                game:GetService("Workspace"):WaitForChild("Pets"):WaitForChild(v.Name):WaitForChild("RootPart"):WaitForChild("RE"):FireServer(unpack({[1] = "Claim"}))
            end
            task.wait(5)
        end
    end)
end)

type:OnChanged(function(Value)
    local Values = {}
    for Value, State in next, Value do
        table.insert(Values, Value)
    end

    eggs.type = {}
    for k, v in pairs(Values) do
        eggs.type[v] = true
    end

    cfg.type = Values
    SaveConfig(cfg)
end)

mutations:OnChanged(function(Value)
    local Values = {}
    for Value, State in next, Value do
        table.insert(Values, Value)
    end

    eggs.mutations = {}
    for k, v in pairs(Values) do
        eggs.mutations[v] = true
    end

    cfg.mutations = Values
    SaveConfig(cfg)
end)

limit:OnChanged(function()
    cfg.limit = tonumber(limit.Value)
    SaveConfig(cfg)
end)

Eggs:OnChanged(function()
    cfg.eggs = Options.Eggs.Value
    SaveConfig(cfg)
    if not Options.Eggs.Value then return end

    task.spawn(function()
        while Options.Eggs.Value do

            local accounts = game:GetService("Players").LocalPlayer.leaderstats["Money $"]
            local Limit = tonumber(limit.Value)
            if Limit <= accounts.Value then
                local AssignedIslandName = game:GetService("Players").LocalPlayer:GetAttribute("AssignedIslandName")
                local Conveyor = game:GetService("ReplicatedStorage").Eggs:WaitForChild(AssignedIslandName):GetChildren()

                for _, Egg in pairs(Conveyor) do
                    local T = Egg:GetAttribute('T')
                    local M = Egg:GetAttribute('M')

                    if next(eggs.type) and (T and eggs.type[T]) then
                        if next(eggs.mutations) and (M and eggs.mutations[M]) then
                            local args = { [1] = "BuyEgg", [2] = Egg.Name }
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
                        else
                            local args = { [1] = "BuyEgg", [2] = Egg.Name }
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
                        end
                    else
                        if next(eggs.mutations) and (M and eggs.mutations[M]) then
                            local args = { [1] = "BuyEgg", [2] = Egg.Name }
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
                        end
                    end
                end
            end

            task.wait(10)
        end
    end)
end)

Window:SelectTab(1)
