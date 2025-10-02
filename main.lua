print('[B3tterDev] Initializing data ..')
repeat wait() until game:IsLoaded()
wait(15)
print("[B3tterDev] Verification successful, this resource is READY to use")
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

local Tabs = {}

Tabs.Main = Window:AddTab({ Title = "หลัก", Icon = "" })
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

local eggs = { type = {}, mutations = {} }
local cfg = LoadConfig()
local CONFIG = {}

CONFIG.EGG_TYPE = {
    "BasicEgg",
    "RareEgg", 
    "SuperRareEgg", 
    "EpicEgg", 
    "LegendEgg",
    "PrismaticEgg",
    "HyperEgg",
    "DarkGoatyEgg",
    "VoidEgg",
    "BowserEgg",
    "DemonEgg",
    "RhinoRockEgg",
    "CornEgg",
    "BoneDragonEgg",
    "UltraEgg",
    "DinoEgg",
    "FlyEgg",
    "SaberCubEgg",
    "UnicornEgg",
    "AncientEgg",
    "UnicornProEgg",
    "GeneralKongEgg",
    "PegasusEgg",
    "SnowbunnyEgg"
}

CONFIG.EGG_MUTATIONS = {
    "Golden", 
    "Diamond", 
    "Electric", 
    "Fire", 
    "Dino",
    "Snow"
}

CONFIG.STORE_LIST = {
    'Strawberry',
    'Blueberry',
    'Watermelon',
    'Apple',
    'Orange',
    'Corn',
    'Banana',
    'Grape',
    'Pear',
    'Pineapple',
    'DragonFruit',
    'GoldMango',
    'BloodstoneCycad',
    'ColossalPinecone',
    'VoltGinkgo',
    'DeepseaPearlFruit',
    'Durian',
}

local Money = Tabs.Main:AddToggle("Money", { Title = "เก็บเงินอัตโนมัติ", Default = cfg.money or false })
local egg_type = Tabs.Main:AddDropdown("egg_type", {
    Title = "ประเภทไข่",
    Values = CONFIG.EGG_TYPE,
    Multi = true,
    Default = cfg.type or {},
})

local mutations = Tabs.Main:AddDropdown("mutations", {
    Title = "ประเภทการกลายพันธุ์",
    Values = CONFIG.EGG_MUTATIONS,
    Multi = true,
    Default = cfg.mutations or {},
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
                local petModel = game:GetService("Workspace"):FindFirstChild("Pets"):FindFirstChild(v.Name)
                if petModel and petModel:FindFirstChild("RootPart") and petModel.RootPart:FindFirstChild("RE") then
                    local args = { "Claim" }
                    petModel.RootPart.RE:FireServer(unpack(args))
                end
            end
            task.wait(30)
        end
    end)
end)

egg_type:OnChanged(function(Value)
    local Values = {}
    for k, v in next, Value do
        if type(k) ~= "number" then table.insert(Values, k) end
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
    for k, v in next, Value do
        if type(k) ~= "number" then table.insert(Values, k) end
    end

    eggs.mutations = {}
    for k, name in pairs(Values) do
        eggs.mutations[name] = true
    end

    cfg.mutations = Values
    SaveConfig(cfg)
end)

Eggs:OnChanged(function()
    cfg.eggs = Options.Eggs.Value
    SaveConfig(cfg)
    if not Options.Eggs.Value then return end

    task.spawn(function()
        while Options.Eggs.Value do
            local accounts = game:GetService("Players").LocalPlayer.leaderstats["Money $"]
            local AssignedIslandName = game:GetService("Players").LocalPlayer:GetAttribute("AssignedIslandName")
            local Conveyor = game:GetService("ReplicatedStorage").Eggs:WaitForChild(AssignedIslandName):GetChildren()

            for _, Egg in pairs(Conveyor) do
                local T = Egg:GetAttribute('T')
                local M = Egg:GetAttribute('M')
                local UID = Egg:GetAttribute('UID')
                if next(eggs.type) then
                    if (T and eggs.type[T]) then
                        if next(eggs.mutations) then
                            if (M and eggs.mutations[M]) then
                                local args = { [1] = "BuyEgg", [2] = UID }
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
                            end
                        else
                            local args = { [1] = "BuyEgg", [2] = UID }
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
                        end
                    end
                else
                    if next(eggs.mutations) then
                        if (M and eggs.mutations[M]) then
                            local args = { [1] = "BuyEgg", [2] = UID }
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack(args))
                        end
                    end
                end
            end

            task.wait(2)
        end
    end)
end)

Tabs.Store = Window:AddTab({ Title = "ร้านค้า", Icon = "" })

local storeValues = {}
local storeList = {}

local store = Tabs.Store:AddDropdown("store", {
    Title = "สินค้า",
    Values = CONFIG.STORE_LIST,
    Multi = true,
    Default = cfg.storeList or {},
})

local storeToggle = Tabs.Store:AddToggle("storeToggle", { Title = "ซื้อของอัตโนมัติ", Default = cfg.storeToggle or false })

store:OnChanged(function(Value)
    storeList = {}
    for k, v in next, Value do
        if type(k) ~= "number" then table.insert(storeList, k) end
    end

    cfg.storeList = storeList
    SaveConfig(cfg)
end)

storeToggle:OnChanged(function()
    cfg.storeToggle = Options.storeToggle.Value
    SaveConfig(cfg)
    if not Options.storeToggle.Value then return end

    task.spawn(function()
        while Options.storeToggle.Value do
            if next(cfg.storeList) then
                for _, name in pairs(cfg.storeList) do
                    local ScrollingFrame = game:GetService("Players").LocalPlayer.PlayerGui.ScreenFoodStore.Root.Frame.ScrollingFrame
                    local StockFrame = ScrollingFrame:FindFirstChild(name)
                    if StockFrame and StockFrame:FindFirstChild("ItemButton") and StockFrame.ItemButton:FindFirstChild("StockLabel") then
                        local StockLabel = StockFrame.ItemButton.StockLabel
                        if StockLabel.Text ~= "No Stock" then
                            local StockInt = string.gsub(StockLabel.Text, "x", "")
                            StockInt = tonumber(StockInt)

                            for i = 1, StockInt do
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FoodStoreRE"):FireServer(name)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end

            task.wait(5)
        end
    end)
end)

Tabs.Efficiency = Window:AddTab({ Title = "ประสิทธิภาพ", Icon = "" })

local AnimationToggle = Tabs.Efficiency:AddToggle("AnimationToggle", { Title = "ปิด Animation", Default = cfg.AnimationToggle or false })

AnimationToggle:OnChanged(function()
    cfg.AnimationToggle = Options.AnimationToggle.Value
    SaveConfig(cfg)
    if not Options.AnimationToggle.Value then return end

    task.spawn(function()
        while Options.AnimationToggle.Value do
            local pets = game:GetService("Workspace"):WaitForChild("Pets")
            for _, v in pairs(pets:GetChildren()) do
                local petModel = pets:FindFirstChild(v.Name)
                if petModel then
                    local animCtrl = petModel:FindFirstChild("AnimationController")
                    if animCtrl then
                        animCtrl:Destroy()
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
                end
            end

            task.wait(30)
        end
    end)
end)

task.spawn(function()
    local Shared = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"))
    local Formatter = Shared("Format")
    local player = game:GetService("Players").LocalPlayer

    while true do
        local accounts = player.leaderstats["Money $"].Value
        local popupDrop = player.PlayerGui:FindFirstChild("PopupDrop")
        local coinHud = player.PlayerGui.OverlaySafe:WaitForChild("CoinHud")
        local textLabel = coinHud:WaitForChild("Value") -- ตรวจชื่อให้ตรงกับจริง

        if popupDrop then
            popupDrop:Destroy()
        end

        textLabel.Text = Formatter:Number2String(accounts, "en")
        task.wait(0.1)
    end
end)

Window:SelectTab(1)
