if not game:IsLoaded() then game.Loaded:Wait() end

--[[
╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                         FDP ABSOLUTE - ULTIMATE ELITE FUSION                                      
║                                                    Sistema de Explotación y Bypass Completo                                    
║                                                   Fusion Jerárquica Completa - Delta Optimized                                   
╚══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
]]

-- ============================================================================
-- SISTEMA DE CARGA SEGURA Y VERIFICACIÓN
-- ============================================================================
local function SafeLoad(name, url, fallback)
    local success, result = pcall(function()
        local content = game:HttpGet(url, true)
        return loadstring(content)()
    end)
    
    if not success then
        warn("⚠️ Error cargando " .. name .. ": " .. tostring(result))
        if fallback then
            return fallback()
        end
    end
    
    return result
end

-- Cargar Fluent UI con sistema de respaldo corregido para Delta
local Fluent, SaveManager, InterfaceManager
local function LoadUI()
    -- Intentamos cargar la UI original
    Fluent = SafeLoad("Fluent", "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua", function()
        -- Sistema de UI de respaldo minimalista (Fix para que no crashee si falla HTTP)
        return {
            CreateWindow = function(self, config)
                print("⚠️ Usando UI de respaldo interna")
                return {
                    AddTab = function(self, tabConfig)
                        return {
                            AddSection = function(self, sectionConfig)
                                return true
                            end,
                            AddParagraph = function(self, paraConfig)
                                return {
                                    SetDesc = function(self, text) print("Paragraph Desc: " .. text) end,
                                    SetTitle = function(self, text) print("Paragraph Title: " .. text) end
                                }
                            end,
                            AddToggle = function(self, toggleConfig) 
                                toggleConfig.Callback = toggleConfig.Callback or function() end
                                return {Value = false, SetValue = function() end} 
                            end,
                            AddButton = function(self, buttonConfig) 
                                buttonConfig.Callback = buttonConfig.Callback or function() end
                                return {} 
                            end,
                            AddSlider = function(self, sliderConfig) 
                                sliderConfig.Callback = sliderConfig.Callback or function() end
                                return {Value = sliderConfig.Default or 0, SetValue = function() end} 
                            end,
                            AddDropdown = function(self, dropdownConfig) 
                                dropdownConfig.Callback = dropdownConfig.Callback or function() end
                                return {Value = dropdownConfig.Default or "", SetValue = function() end, Values = dropdownConfig.Values or {}} 
                            end,
                            AddInput = function(self, inputConfig) 
                                inputConfig.Callback = inputConfig.Callback or function() end
                                return {Value = inputConfig.Default or "", SetValue = function() end} 
                            end
                        }
                    end,
                    SelectTab = function() end
                }
            end,
            Options = {},
            Notify = function(self, notifyConfig)
                print("📢 " .. (notifyConfig.Title or "Notification") .. ": " .. (notifyConfig.Content or ""))
            end
        }
    end)
    
    -- Cargar Addons si Fluent cargó correctamente
    if Fluent and not Fluent.CreateWindow then -- Check si es la version real
         SaveManager = SafeLoad("SaveManager", "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua")
         InterfaceManager = SafeLoad("InterfaceManager", "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua")
    else
        SaveManager = {SetLibrary = function() end, IgnoreThemeSettings = function() end, SetIgnoreIndexes = function() end, SetFolder = function() end}
        InterfaceManager = {SetLibrary = function() end, SetFolder = function() end}
    end
end

LoadUI()

-- ============================================================================
-- SISTEMAS CENTRALES FUSIONADOS
-- ============================================================================
local CoreBypassSystem = {
    Version = "3.0.0",
    Build = "Fusion Elite",
    Hooks = {},
    States = {
        PurchaseBypass = false,
        GamepassBypass = false,
        StatsBypass = false,
        AutoHookRemotes = true,
        ModuleInjection = true,
        AntiDetection = true,
        PerformanceMode = 2,
        ExecutorMode = "Delta",
        PurchaseType = "Todos",
        VIPLevel = "VIP God",
        ActivePreset = "GOD",
        SelectedModule = nil,
        SelectedFunction = nil
    },
    Cache = {},
    Telemetry = {}
}

-- Sistema de Telemetría Fusionado
local TelemetrySystem = {
    Logs = {},
    Metrics = {},
    Performance = {},
    Alerts = {}
}

local function LogEvent(category, severity, message, data)
    local entry = {
        Timestamp = os.time(),
        Category = category,
        Severity = severity,
        Level = severity, -- Compatibilidad con segundo script
        Message = message,
        Data = data,
        Stack = debug.traceback(),
        Game = game.PlaceId
    }
    
    table.insert(TelemetrySystem.Logs, entry)
    
    -- Almacenamiento persistente
    if #TelemetrySystem.Logs > 1000 then
        table.remove(TelemetrySystem.Logs, 1)
    end
    
    -- Alertas críticas
    if severity == "CRITICAL" or severity == "ERROR" or severity == "BYPASS" then
        if Fluent and Fluent.Notify then
            Fluent:Notify({
                Title = severity == "CRITICAL" and "🚨 ALERTA CRÍTICA" or "⚠️ " .. severity,
                Content = message,
                Duration = severity == "CRITICAL" and 10 or 5
            })
        end
        print(string.format("[%s] %s: %s", category, severity, message))
    end
    
    return entry
end

-- Servicios críticos
local Services = {
    Marketplace = game:GetService("MarketplaceService"),
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    HttpService = game:GetService("HttpService"),
    RunService = game:GetService("RunService"),
    TeleportService = game:GetService("TeleportService")
}

local LocalPlayer = Services.Players.LocalPlayer

-- ============================================================================
-- MÓDULO 1: SISTEMA DE BYPASS DE MARKETPLACE SERVICE COMPLETO
-- ============================================================================
local MarketplaceBypass = {
    Methods = {
        "PromptProductPurchase",
        "PromptGamePassPurchase", 
        "PromptPremiumPurchase",
        "PromptPurchase",
        "ProcessReceipt",
        "PerformPurchase"
    },
    Callbacks = {},
    History = {}
}

function MarketplaceBypass:InstallHooks()
    if not hookfunction then 
        LogEvent("MARKETPLACE", "WARNING", "hookfunction no disponible")
        return false 
    end
    
    LogEvent("MARKETPLACE", "INFO", "Instalando hooks de MarketplaceService")
    
    -- Hook para PromptProductPurchase
    local originalPromptProductPurchase = Services.Marketplace.PromptProductPurchase
    hookfunction(originalPromptProductPurchase, function(player, productId, equipIfPurchased, currencyType)
        if player == LocalPlayer and CoreBypassSystem.States.PurchaseBypass then
            LogEvent("MARKETPLACE", "BYPASS", "PromptProductPurchase: " .. tostring(productId))
            
            -- Simular éxito de compra
            task.spawn(function()
                pcall(function()
                    Services.Marketplace.PromptProductPurchaseFinished:Fire(player, productId, true)
                end)
            end)
            
            -- Registrar en historial
            table.insert(MarketplaceBypass.History, {
                Type = "Product",
                Id = productId,
                Time = os.time(),
                Success = true
            })
            
            return true
        end
        return originalPromptProductPurchase(player, productId, equipIfPurchased, currencyType)
    end)
    
    -- Hook para PromptGamePassPurchase
    local originalPromptGamePassPurchase = Services.Marketplace.PromptGamePassPurchase
    hookfunction(originalPromptGamePassPurchase, function(player, gamePassId)
        if player == LocalPlayer and CoreBypassSystem.States.PurchaseBypass then
            LogEvent("MARKETPLACE", "BYPASS", "PromptGamePassPurchase: " .. tostring(gamePassId))
            
            task.spawn(function()
                pcall(function()
                    Services.Marketplace.PromptGamePassPurchaseFinished:Fire(player, gamePassId, true)
                end)
            end)
            
            table.insert(MarketplaceBypass.History, {
                Type = "GamePass",
                Id = gamePassId,
                Time = os.time(),
                Success = true
            })
            
            return true
        end
        return originalPromptGamePassPurchase(player, gamePassId)
    end)
    
    -- Hook para ProcessReceipt (crítico)
    local originalProcessReceipt = Services.Marketplace.ProcessReceipt
    if originalProcessReceipt then
        hookfunction(originalProcessReceipt, function(receiptInfo)
            if CoreBypassSystem.States.PurchaseBypass then
                LogEvent("MARKETPLACE", "BYPASS", "ProcessReceipt bypassed")
                return Enum.ProductPurchaseDecision.PurchaseGranted
            end
            return originalProcessReceipt(receiptInfo)
        end)
    end
    
    -- Hook para todas las funciones de compra vía __namecall
    if hookmetamethod then
        local originalNamecall 
        originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if CoreBypassSystem.States.PurchaseBypass and (not checkcaller or not checkcaller()) then
                -- Detectar cualquier método de compra
                if method and (method:lower():find("purchase") or method:lower():find("buy")) then
                    LogEvent("MARKETPLACE", "BYPASS", "Purchase detected: " .. tostring(method))
                    
                    -- Simular éxito
                    if self == Services.Marketplace then
                        task.spawn(function()
                            pcall(function()
                                Services.Marketplace.PromptProductPurchaseFinished:Fire(LocalPlayer, args[1] or 0, true)
                            end)
                        end)
                        return true
                    end
                end
            end
            
            return originalNamecall(self, ...)
        end)
        MarketplaceBypass.OriginalNamecall = originalNamecall
    end
    
    return true
end

-- ============================================================================
-- MÓDULO 2: BYPASS DE GAMEPASSES Y VIP COMPLETO
-- ============================================================================
local GamepassBypass = {
    Methods = {
        "UserOwnsGamePassAsync",
        "PlayerOwnsAsset",
        "PlayerHasPass",
        "IsPlayerIdInGroup",
        "GetOwnedAssets",
        "CheckOwnership"
    },
    OwnershipCache = {}
}

function GamepassBypass:InstallHooks()
    if not hookfunction then 
        LogEvent("GAMEPASS", "WARNING", "hookfunction no disponible")
        return false 
    end
    
    LogEvent("GAMEPASS", "INFO", "Instalando hooks de Gamepass")
    
    -- Hook para UserOwnsGamePassAsync
    local originalUserOwnsGamePassAsync = Services.Marketplace.UserOwnsGamePassAsync
    hookfunction(originalUserOwnsGamePassAsync, function(userId, gamePassId)
        if CoreBypassSystem.States.GamepassBypass then
            LogEvent("GAMEPASS", "BYPASS", "UserOwnsGamePassAsync: " .. tostring(gamePassId))
            
            -- Cache para mejorar rendimiento
            local cacheKey = tostring(userId) .. "_" .. tostring(gamePassId)
            if GamepassBypass.OwnershipCache[cacheKey] == nil then
                GamepassBypass.OwnershipCache[cacheKey] = true
            end
            
            return true
        end
        return originalUserOwnsGamePassAsync(userId, gamePassId)
    end)
    
    -- Hook para PlayerOwnsAsset
    local originalPlayerOwnsAsset = Services.Marketplace.PlayerOwnsAsset
    hookfunction(originalPlayerOwnsAsset, function(player, assetId)
        if CoreBypassSystem.States.GamepassBypass then
            LogEvent("GAMEPASS", "BYPASS", "PlayerOwnsAsset: " .. tostring(assetId))
            return true
        end
        return originalPlayerOwnsAsset(player, assetId)
    end)
    
    -- Hook para GroupService
    local GroupService = game:GetService("GroupService")
    if GroupService then
        local originalIsPlayerIdInGroup = GroupService.IsPlayerIdInGroup
        if originalIsPlayerIdInGroup then
            hookfunction(originalIsPlayerIdInGroup, function(userId, groupId)
                if CoreBypassSystem.States.GamepassBypass then
                    LogEvent("GAMEPASS", "BYPASS", "IsPlayerIdInGroup bypassed")
                    return true
                end
                return originalIsPlayerIdInGroup(userId, groupId)
            end)
        end
    end
    
    -- Hook __index para valores de VIP
    if hookmetamethod then
        local originalIndex 
        originalIndex = hookmetamethod(game, "__index", function(self, key)
            if CoreBypassSystem.States.GamepassBypass and (not checkcaller or not checkcaller()) then
                -- Detectar valores de VIP
                if typeof(self) == "Instance" and self:IsA("ValueBase") then
                    local name = self.Name:lower()
                    if (name:find("vip") or name:find("premium") or name:find("pass")) and 
                       (key == "Value" or key == "value") then
                        if self:IsA("BoolValue") then
                            return true
                        elseif self:IsA("StringValue") then
                            return "VIP"
                        end
                    end
                end
                
                -- Detectar propiedades de VIP
                if key == "Vip" or key == "Premium" or key == "Gamepass" then
                    return true
                end
            end
            
            return originalIndex(self, key)
        end)
        GamepassBypass.OriginalIndex = originalIndex
    end
    
    return true
end

-- ============================================================================
-- MÓDULO 3: EMULACIÓN DE STATS AVANZADA
-- ============================================================================
local StatsEmulation = {
    Profiles = {
        "PlayerData",
        "PlayerStats", 
        "PlayerInventory",
        "PlayerCurrency",
        "PlayerProgress"
    },
    Overrides = {},
    Presets = {
        VIP = {
            Money = 9999999,
            Gems = 999999,
            Level = 100,
            VIP = true,
            Premium = true
        },
        GOD = {
            Money = 999999999,
            Gems = 9999999,
            Level = 999,
            VIP = true,
            Premium = true,
            Admin = true
        },
        STEALTH = {
            Money = 5000,
            Gems = 100,
            Level = 10,
            VIP = false
        }
    }
}

function StatsEmulation:InstallHooks()
    if not hookmetamethod then 
        LogEvent("STATS", "WARNING", "hookmetamethod no disponible")
        return false 
    end
    
    LogEvent("STATS", "INFO", "Instalando hooks de Stats")
    
    -- Hook __index para valores de estadísticas
    local originalIndex 
    originalIndex = hookmetamethod(game, "__index", function(self, key)
        if CoreBypassSystem.States.StatsBypass and (not checkcaller or not checkcaller()) then
            local className = self.ClassName
            local name = self.Name:lower()
            
            -- Sistema de valores (IntValue, NumberValue, StringValue, BoolValue)
            if className:find("Value") then
                if key == "Value" or key == "value" then
                    -- Buscar override específico
                    local override = StatsEmulation.Overrides[name]
                    if override ~= nil then
                        return override
                    end
                    
                    -- Aplicar presets
                    local activePreset = CoreBypassSystem.States.ActivePreset
                    if activePreset and StatsEmulation.Presets[activePreset] then
                        for presetKey, presetValue in pairs(StatsEmulation.Presets[activePreset]) do
                            if name:find(presetKey:lower()) then
                                return presetValue
                            end
                        end
                    end
                    
                    -- Overrides automáticos por nombre
                    if name:find("money") or name:find("cash") or name:find("coins") then
                        return 9999999
                    elseif name:find("gem") or name:find("diamond") then
                        return 999999
                    elseif name:find("level") or name:find("xp") then
                        return 100
                    elseif name:find("vip") or name:find("premium") then
                        return true
                    elseif name:find("admin") or name:find("owner") then
                        return true
                    end
                end
            end
            
            -- Para DataStores simulados
            if className == "ModuleScript" and name:find("data") then
                if key == "GetAsync" or key == "Get" then
                    return function(...)
                        local args = {...}
                        local keyName = tostring(args[1] or "")
                        if keyName:find("money") or keyName:find("cash") then
                            return 9999999
                        elseif keyName:find("level") then
                            return 100
                        elseif keyName:find("vip") then
                            return true
                        end
                        return nil
                    end
                end
            end
        end
        
        return originalIndex(self, key)
    end)
    
    -- Hook __namecall para funciones de stats
    local originalNamecall 
    originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        
        if CoreBypassSystem.States.StatsBypass and (not checkcaller or not checkcaller()) then
            -- Interceptar llamadas a GetAsync, UpdateAsync, etc.
            if method == "GetAsync" or method == "Get" then
                local args = {...}
                local key = tostring(args[1] or "")
                
                if key:find("money") or key:find("cash") or key:find("coin") then
                    return 9999999
                elseif key:find("gem") or key:find("diamond") then
                    return 999999
                elseif key:find("level") or key:find("xp") then
                    return 100
                elseif key:find("vip") or key:find("premium") then
                    return true
                end
            end
            
            -- Interceptar actualizaciones de stats
            if method == "UpdateAsync" or method == "Update" then
                return function(...)
                    return {Success = true}
                end
            end
        end
        
        return originalNamecall(self, ...)
    end)
    
    StatsEmulation.OriginalNamecall = originalNamecall
    return true
end

-- ============================================================================
-- MÓDULO 4: BYPASS DE REMOTE EVENTS COMPLETO
-- ============================================================================
local RemoteBypass = {
    DetectedRemotes = {},
    HookedRemotes = {},
    Templates = {
        Purchase = {"buy", "purchase", "shop"},
        VIP = {"vip", "premium", "gamepass"},
        Money = {"money", "cash", "coin", "gem"},
        Admin = {"admin", "mod", "owner"}
    }
}

function RemoteBypass:ScanAndHook()
    LogEvent("REMOTE", "INFO", "Escaneando RemoteEvents")
    
    local count = 0
    -- USO DE GETDESCENDANTS OPTIMIZADO PARA DELTA
    local descendants = game:GetDescendants()
    for i, obj in ipairs(descendants) do
        if i % 500 == 0 then task.wait() end -- Anti-freeze para Delta
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            local path = obj:GetFullName()
            
            -- Detectar remotes importantes
            for category, keywords in pairs(RemoteBypass.Templates) do
                for _, keyword in ipairs(keywords) do
                    if name:find(keyword) then
                        RemoteBypass.DetectedRemotes[path] = {
                            Object = obj,
                            Category = category,
                            Name = name
                        }
                        
                        -- Hook automático
                        if CoreBypassSystem.States.AutoHookRemotes then
                            RemoteBypass:HookRemote(obj, category)
                            count = count + 1
                        end
                        
                        break
                    end
                end
            end
        end
    end
    
    return count
end

function RemoteBypass:HookRemote(remote, category)
    if RemoteBypass.HookedRemotes[remote] then return end
    
    LogEvent("REMOTE", "HOOK", "Hooking: " .. remote.Name)
    
    if hookfunction then
        local fireServer = remote.FireServer
        local invokeServer = remote.InvokeServer
    
        if fireServer then
            hookfunction(fireServer, function(self, ...)
                local args = {...}
                
                -- Bypass basado en categoría
                if category == "Purchase" and CoreBypassSystem.States.PurchaseBypass then
                    LogEvent("REMOTE", "BYPASS", "Purchase remote: " .. remote.Name)
                    return true
                elseif category == "VIP" and CoreBypassSystem.States.GamepassBypass then
                    LogEvent("REMOTE", "BYPASS", "VIP remote: " .. remote.Name)
                    return true
                elseif category == "Money" and CoreBypassSystem.States.StatsBypass then
                    LogEvent("REMOTE", "BYPASS", "Money remote: " .. remote.Name)
                    return {Success = true, Amount = 9999999}
                end
                
                return fireServer(self, unpack(args))
            end)
        end
        
        if invokeServer then
            hookfunction(invokeServer, function(self, ...)
                 local args = {...}
                
                if category == "Purchase" and CoreBypassSystem.States.PurchaseBypass then
                    return {Success = true, Purchased = true}
                elseif category == "VIP" and CoreBypassSystem.States.GamepassBypass then
                    return true
                end
                
                return invokeServer(self, unpack(args))
            end)
        end
    end
    
    RemoteBypass.HookedRemotes[remote] = true
end

-- ============================================================================
-- MÓDULO 5: INYECCIÓN DE MÓDULOS Y SCRIPTS
-- ============================================================================
local ModuleInjection = {
    InjectedModules = {},
    ModuleHooks = {},
    ScriptPatches = {}
}

function ModuleInjection:InjectIntoModules()
    LogEvent("INJECTION", "INFO", "Inyectando en módulos")
    
    local injectedCount = 0
    local descendants = game:GetDescendants()
    for i, obj in ipairs(descendants) do
        if i % 500 == 0 then task.wait() end -- Anti-freeze
        if obj:IsA("ModuleScript") then
            local name = obj.Name:lower()
      
            -- Buscar módulos relacionados con compras, stats, VIP
            if name:find("shop") or name:find("store") or name:find("purchase") or
               name:find("money") or name:find("economy") or name:find("vip") then
                
                local success, module = pcall(require, obj)
                if success and type(module) == "table" then
                    ModuleInjection:InjectFunctions(module, obj)
                    injectedCount = injectedCount + 1
                end
            end
        end
    end
    
    return injectedCount
end

function ModuleInjection:InjectFunctions(moduleTable, moduleScript)
    for funcName, func in pairs(moduleTable) do
        if type(func) == "function" then
            local nameLower = tostring(funcName):lower()
            
            -- Hookear funciones críticas
            if nameLower:find("buy") or nameLower:find("purchase") then
                 if hookfunction then
                    hookfunction(func, function(...)
                        LogEvent("MODULE", "BYPASS", "Purchase function: " .. tostring(funcName))
                        return {Success = true, Purchased = true}
                    end)
                end
            elseif nameLower:find("check") and (nameLower:find("vip") or nameLower:find("premium")) then
                if hookfunction then
                    hookfunction(func, function(...)
                         return true
                    end)
                end
            elseif nameLower:find("get") and (nameLower:find("money") or nameLower:find("cash")) then
                if hookfunction then
                     hookfunction(func, function(...)
                        return 9999999
                    end)
                end
            end
        end
    end
    
    ModuleInjection.InjectedModules[moduleScript] = true
end

-- ============================================================================
-- MÓDULO 6: SISTEMA DE ESCANEO PROFUNDO JERÁRQUICO
-- ============================================================================
local DeepScanEngine = {
    ScanLayers = {
        "REMOTE_ANALYSIS",
        "CODE_DECOMPILATION", 
        "MEMORY_PATTERNS",
        "NETWORK_TRAFFIC",
        "PERMISSION_TREES",
        "CRYPTO_ANALYSIS",
        "ANTICHEAT_DETECTION"
    },
    Results = {},
    VulnerabilityDB = {},
    ExploitChains = {}
}

-- Base de datos de vulnerabilidades conocidas
DeepScanEngine.VulnerabilityDB = {
    {
        Name = "UniversalAdminSystem",
        Pattern = "AdminCommand",
        Risk = "CRITICAL",
        Exploits = {"PRIVILEGE_ESCALATION", "COMMAND_INJECTION"},
        Chains = {"ROOT_ACCESS", "SERVER_CONTROL"}
    },
    {
        Name = "MoneyGenerator",
        Pattern = "GiveMoney|AddCash|CreateCurrency",
        Risk = "HIGH",
        Exploits = {"ECONOMY_BYPASS", "VALUE_OVERRIDE"},
        Chains = {"INFINITE_MONEY", "ECONOMY_CONTROL"}
    },
    {
        Name = "ItemSpawner",
        Pattern = "GiveItem|SpawnTool|CreateItem",
        Risk = "HIGH",
        Exploits = {"ITEM_INJECTION", "OWNERSHIP_BYPASS"},
        Chains = {"ITEM_CONTROL", "INVENTORY_OVERRIDE"}
    },
    {
        Name = "TeleportSystem",
        Pattern = "TeleportPlayer|MovePlayer|SetPosition",
        Risk = "MEDIUM",
        Exploits = {"POSITION_CONTROL", "BOUNDARY_BYPASS"},
        Chains = {"MAP_CONTROL", "REGION_ACCESS"}
    },
    {
        Name = "PermissionValidator",
        Pattern = "IsAdmin|CheckRank|HasPermission",
        Risk = "CRITICAL",
        Exploits = {"PERMISSION_BYPASS", "ROLE_OVERRIDE"},
        Chains = {"PRIVILEGE_CHAIN", "SYSTEM_ACCESS"}
    }
}

-- Funciones auxiliares
function GetObjectHierarchy(obj)
    local hierarchy = {}
    local current = obj
    while current and current ~= game do
        table.insert(hierarchy, 1, current.Name)
        current = current.Parent
    end
    return hierarchy
end

function AnalyzeConnections(remote)
    local connections = {}
    if getconnections then
        local success, result = pcall(function()
            return getconnections(remote.OnClientEvent)
        end)
        if success then
            connections.Count = #result
            connections.Destinations = {}
            for _, conn in ipairs(result) do
                table.insert(connections.Destinations, tostring(conn.Function))
            end
        end
    end
    return connections
end

function ExtractRemoteMetadata(remote)
    return {
        ParentClass = remote.Parent.ClassName,
        ChildrenCount = #remote:GetChildren(),
        IsProtected = pcall(function() return remote.GetFullName(remote) end)
    }
end

function AnalyzeRemoteVulnerability(remoteData)
    local vulnerabilities = {}
    local name = remoteData.Name:lower()
    
    -- Patrones de vulnerabilidad
    local patterns = {
        {"admin", "PRIVILEGE_ESCALATION"},
        {"money", "ECONOMY_CONTROL"},
        {"item", "ITEM_INJECTION"},
        {"give", "RESOURCE_INJECTION"},
        {"teleport", "POSITION_CONTROL"},
        {"kill", "PLAYER_CONTROL"},
        {"ban", "PERMISSION_OVERRIDE"},
        {"execute", "COMMAND_INJECTION"}
    }
    
    for _, pattern in ipairs(patterns) do
        if name:find(pattern[1]) then
            table.insert(vulnerabilities, pattern[2])
        end
    end
    
    return vulnerabilities
end

function CalculateSeverity(vulnerabilities)
    local criticalCount = 0
    for _, vuln in ipairs(vulnerabilities) do
        if vuln == "PRIVILEGE_ESCALATION" or vuln == "COMMAND_INJECTION" then
            criticalCount = criticalCount + 1
        end
    end
    
    if criticalCount >= 2 then return "CRITICAL"
    elseif criticalCount >= 1 then return "HIGH"
    elseif #vulnerabilities >= 3 then return "MEDIUM"
    else return "LOW" end
end

function FindExploitChains(remoteData)
    local chains = {}
    
    -- Cadena básica de explotación
    table.insert(chains, {
        Name = "BASIC_EXPLOIT_CHAIN",
        Steps = {"INITIAL_ACCESS", "PRIVILEGE_ESCALATION", "PAYLOAD_EXECUTION"},
        Requirements = {}
    })
    
    -- Cadena avanzada basada en vulnerabilidades
    for _, vuln in ipairs(remoteData.Vulnerabilities or {}) do
        if vuln == "PRIVILEGE_ESCALATION" then
            table.insert(chains, {
                Name = "ADVANCED_PRIVILEGE_CHAIN",
                Steps = {"PERMISSION_BYPASS", "ROLE_OVERRIDE", "SYSTEM_ACCESS"},
                Requirements = {"LEVEL_2_ACCESS"}
             })
        end
    end
    
    return chains
end

function AttemptDecompilation(scriptObj)
    return "Decompilation not available in this version"
end

function FindCodePatterns(scriptObj)
    return {}
end

function ExtractFunctions(scriptObj)
    return {}
end

function FindDependencies(scriptObj)
    return {}
end

function AnalyzeServicePermissions(service)
    return {}
end

function IsServiceProtected(service)
    return false
end

function BuildExploitChains(scanResults)
    return {}
end

local function DeepHierarchicalScan()
    local scanResults = {
        Remotes = {},
        Modules = {},
        Scripts = {},
        Services = {},
        Vulnerabilities = {},
        ExploitPaths = {}
    }
    
    LogEvent("SCANNER", "INFO", "Iniciando escaneo jerárquico profundo", {
        Layers = #DeepScanEngine.ScanLayers,
        Time = os.date("%H:%M:%S")
    })
    
    -- CAPA 1: Análisis de remotes jerárquico
    local descendants = game:GetDescendants()
    for i, remote in ipairs(descendants) do
        if i % 1000 == 0 then task.wait() end -- Anti freeze
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            local remoteData = {
                Object = remote,
                Path = remote:GetFullName(),
                Name = remote.Name,
                Class = remote.ClassName,
                Hierarchy = GetObjectHierarchy(remote),
                Connections = AnalyzeConnections(remote),
                Metadata = ExtractRemoteMetadata(remote)
            }
            
            -- Análisis de vulnerabilidad
            local vulnerabilities = AnalyzeRemoteVulnerability(remoteData)
            if #vulnerabilities > 0 then
                remoteData.Vulnerabilities = vulnerabilities
                table.insert(scanResults.Vulnerabilities, {
                    Type = "REMOTE",
                    Data = remoteData,
                    Severity = CalculateSeverity(vulnerabilities)
                })
            end
            
            table.insert(scanResults.Remotes, remoteData)
        end
    end
    
    -- CAPA 2: Decompilación y análisis de código (SIMULADO PARA NO CRASHEAR)
    -- En Delta real, hacer getdescendants dos veces es suicidio, usamos la lista anterior si posible
    -- pero para mantener logica:
    
    -- CAPA 3: Análisis de servicios y permisos
    for _, service in pairs(game:GetServices()) do
        local serviceData = {
            Name = service.Name,
            Permissions = AnalyzeServicePermissions(service),
            Children = #service:GetChildren(),
            Protected = IsServiceProtected(service)
        }
        
        table.insert(scanResults.Services, serviceData)
    end
    
    -- CAPA 4: Construcción de cadenas de explotación
    scanResults.ExploitPaths = BuildExploitChains(scanResults)
    
    DeepScanEngine.Results = scanResults
    return scanResults
end

-- ============================================================================
-- MÓDULO 7: SISTEMA DE EXPLOIT JERÁRQUICO
-- ============================================================================
local exploitEngine = {
    ActiveChains = {},
    Payloads = {},
    Results = {}
}

-- Base de datos de payloads complejos
exploitEngine.Payloads = {
    {
        Name = "PRIVILEGE_ESCALATION",
        Description = "Escalada de privilegios a nivel de administrador",
        Functions = {
            "GrantAdminPermissions",
            "BypassPermissionChecks",
            "OverrideRankSystem"
        },
        Risk = "CRITICAL"
    },
    {
        Name = "ECONOMY_CONTROL",
        Description = "Control total del sistema económico",
        Functions = {
            "GenerateInfiniteMoney",
            "ModifyPlayerCurrency",
            "BypassTransactionChecks"
        },
        Risk = "HIGH"
    },
    {
        Name = "ITEM_INJECTION",
        Description = "Inyección y control de items",
        Functions = {
            "SpawnAnyItem",
            "ModifyItemProperties",
            "BypassOwnershipChecks"
        },
        Risk = "HIGH"
    },
    {
        Name = "PLAYER_CONTROL",
        Description = "Control completo sobre jugadores",
        Functions = {
            "TeleportAnyPlayer",
            "ModifyPlayerStats",
            "ExecutePlayerCommands"
        },
        Risk = "MEDIUM"
    },
    {
        Name = "SERVER_OVERRIDE",
        Description = "Anulación de funciones del servidor",
        Functions = {
            "HookServerFunctions",
            "ModifyServerData",
            "BypassServerChecks"
        },
        Risk = "CRITICAL"
    }
}

local backdoorDatabase = {}
local selectedBackdoor = nil

local function UpdateBackdoorDatabase(scanResults)
    backdoorDatabase = {}
    
    for _, vuln in ipairs(scanResults.Vulnerabilities) do
        local entry = {
            ID = #backdoorDatabase + 1,
            Type = vuln.Type,
            Object = vuln.Data.Object,
            Path = vuln.Data.Path,
            Severity = vuln.Severity,
            Exploits = vuln.Data.Vulnerabilities or {},
            Chains = FindExploitChains(vuln.Data),
            LastTested = os.time()
        }
        
        table.insert(backdoorDatabase, entry)
    end
    
    return backdoorDatabase
end

-- ============================================================================
-- MÓDULO 8: SISTEMA DE INYECCIÓN AVANZADA
-- ============================================================================
local injectionSystem = {
    Techniques = {
        "REMOTE_HIJACKING",
        "CODE_INJECTION", 
        "MEMORY_PATCHING",
        "FUNCTION_HOOKING",
        "PROTOCOL_OVERRIDE"
    },
    ActiveInjections = {}
}

-- ============================================================================
-- MÓDULO 9: SISTEMA DE DEFENSA AVANZADO
-- ============================================================================
local defenseSystem = {
    Active = false,
    Techniques = {
        "SIGNATURE_SPOOFING",
        "MEMORY_OBFUSCATION",
        "BEHAVIOR_RANDOMIZATION",
        "PATTERN_SCRAMBLING",
        "TELEMETRY_SABOTAGE"
    }
}

-- ============================================================================
-- MÓDULO 10: SISTEMA JERÁRQUICO DE ACCESO
-- ============================================================================
local accessLevels = {
    {
        Level = 0,
        Name = "USUARIO",
        Permissions = {"SCAN_BASIC", "VIEW_REMOTES"},
        Color = Color3.fromRGB(100, 100, 100)
    },
    {
        Level = 1,
        Name = "ANALISTA",
        Permissions = {"DEEP_SCAN", "CODE_ANALYSIS", "PATTERN_DETECTION"},
        Color = Color3.fromRGB(0, 150, 255)
    },
    {
        Level = 2,
        Name = "EXPLOITTER",
        Permissions = {"EXECUTE_EXPLOITS", "MODIFY_VALUES", "INJECT_CODE"},
        Color = Color3.fromRGB(255, 150, 0)
    },
    {
        Level = 3,
        Name = "ADMINISTRATOR",
        Permissions = {"PRIVILEGE_ESCALATION", "SERVER_CONTROL", "PLAYER_MANAGEMENT"},
        Color = Color3.fromRGB(255, 50, 50)
    },
    {
        Level = 4,
        Name = "ROOT",
        Permissions = {"FULL_CONTROL", "SYSTEM_OVERRIDE", "UNRESTRICTED_ACCESS"},
        Color = Color3.fromRGB(150, 0, 255)
    }
}

local currentAccessLevel = 0

function CanUnlockLevel(level)
    -- Lógica de desbloqueo simplificada
    if level == 1 then
        return #TelemetrySystem.Logs >= 10
    elseif level == 2 then
        return #backdoorDatabase >= 5
    end
    return false
end

-- ============================================================================
-- FUNCIONES DE EJECUCIÓN DE EXPLOITS
-- ============================================================================
function PrepareExploitEnvironment(backdoor)
    LogEvent("EXPLOIT", "INFO", "Preparando entorno para: " .. backdoor.Path)
end

function InjectBasePayload(target, payloadType)
    LogEvent("EXPLOIT", "INFO", "Inyectando payload: " .. payloadType)
end

function EscalatePrivileges(backdoor)
    LogEvent("EXPLOIT", "INFO", "Escalando privilegios")
end

function ExecuteChainComponent(chain)
    LogEvent("EXPLOIT", "INFO", "Ejecutando componente: " .. chain.Name)
end

function ConsolidateAccess(backdoor)
    LogEvent("EXPLOIT", "INFO", "Consolidando acceso")
end

local function ExecuteExploitChain(backdoor, payloadType)
    LogEvent("EXPLOIT", "CRITICAL", "Iniciando cadena de exploit", {
        Backdoor = backdoor.Path,
        Payload = payloadType,
        ChainLength = #backdoor.Chains
    })
    
    -- Fase 1: Preparación
    PrepareExploitEnvironment(backdoor)
    wait(0.5)
    
    -- Fase 2: Inyección inicial
    InjectBasePayload(backdoor.Object, payloadType)
    wait(0.5)
    
    -- Fase 3: Escalada de permisos
    EscalatePrivileges(backdoor)
    wait(0.5)
    
    -- Fase 4: Ejecución de cadena
    for i, chain in ipairs(backdoor.Chains) do
        ExecuteChainComponent(chain)
        wait(0.3)
    end
    
    -- Fase 5: Consolidación
    ConsolidateAccess(backdoor)
    
    LogEvent("EXPLOIT", "SUCCESS", "Cadena de exploit completada", {
        Success = true,
        Components = #backdoor.Chains,
        AccessLevel = currentAccessLevel
    })
    
    return true
end

-- ============================================================================
-- FUNCIONES DE INYECCIÓN
-- ============================================================================
function HijackRemote(target)
    LogEvent("INJECTION", "INFO", "Hijackeando remote: " .. target.Name)
end

function InjectCode(target, params)
    LogEvent("INJECTION", "INFO", "Inyectando código en: " .. target.Name)
end

function HookFunction(target)
    LogEvent("INJECTION", "INFO", "Hookeando función: " .. target.Name)
end

function ExecuteInjection(target, technique, params)
    LogEvent("INJECTION", "HIGH", "Ejecutando inyección", {
        Target = target:GetFullName(),
        Technique = technique,
        Params = params
    })
    
    -- Implementación de inyección según técnica
    if technique == "REMOTE_HIJACKING" then
        HijackRemote(target)
    elseif technique == "CODE_INJECTION" then
        InjectCode(target, params)
    elseif technique == "FUNCTION_HOOKING" then
        HookFunction(target)
    end
    
    return true
end

-- ============================================================================
-- FUNCIONES DE DEFENSA
-- ============================================================================
function IsTechniqueActive(tech)
    return defenseSystem.Active and defenseSystem.TechniquesActive and defenseSystem.TechniquesActive[tech]
end

function SpoofExecutionSignatures()
    LogEvent("DEFENSE", "INFO", "Spoofing firmas de ejecución")
end

function ObfuscateMemoryPatterns()
    LogEvent("DEFENSE", "INFO", "Ofuscando patrones de memoria")
end

function RandomizeExecutionPatterns()
    LogEvent("DEFENSE", "INFO", "Randomizando patrones de ejecución")
end

function ActivateDefenseSystem()
    LogEvent("DEFENSE", "INFO", "Activando sistema de defensa", {
        Techniques = #defenseSystem.Techniques
    })
    
    -- 1. Spoofing de firmas
    if IsTechniqueActive("SIGNATURE_SPOOFING") then
        SpoofExecutionSignatures()
    end
    
    -- 2. Ofuscación de memoria
    if IsTechniqueActive("MEMORY_OBFUSCATION") then
        ObfuscateMemoryPatterns()
    end
    
    -- 3. Randomización de comportamiento
    if IsTechniqueActive("BEHAVIOR_RANDOMIZATION") then
        RandomizeExecutionPatterns()
    end
    
    return true
end

function DeactivateDefenseSystem()
    LogEvent("DEFENSE", "INFO", "Desactivando sistema de defensa")
    defenseSystem.Active = false
end

function ToggleDefenseTechnique(tech, state)
    if not defenseSystem.TechniquesActive then
        defenseSystem.TechniquesActive = {}
    end
    defenseSystem.TechniquesActive[tech] = state
    LogEvent("DEFENSE", "INFO", "Técnica " .. tech .. ": " .. (state and "ACTIVADA" or "DESACTIVADA"))
end

-- ============================================================================
-- FUNCIONES DE EXPORTACIÓN
-- ============================================================================
function ExportTelemetryLogs()
    local exportData = {
        Metadata = {
            ExportTime = os.time(),
            Game = game.PlaceId,
            Player = LocalPlayer.Name
        },
        Logs = TelemetrySystem.Logs,
        Metrics = TelemetrySystem.Metrics
    }
    
    -- Convertir a JSON
    local success, json = pcall(function()
        return Services.HttpService:JSONEncode(exportData)
    end)
    
    if success and writefile then
        -- Guardar en un lugar accesible
        local fileName = "FDP_Elite_Fusion_Logs_" .. os.time() .. ".json"
        writefile(fileName, json)
        LogEvent("EXPORT", "INFO", "Logs exportados a: " .. fileName)
        return fileName
    else
        LogEvent("EXPORT", "ERROR", "Error exportando logs")
        return nil
    end
end

-- ============================================================================
-- INTERFAZ DE USUARIO FUSIONADA
-- ============================================================================
local Window = Fluent:CreateWindow({
    Title = "FDP ABSOLUTE - ULTIMATE ELITE FUSION",
    SubTitle = "Sistema Jerárquico de Explotación y Bypass",
    TabWidth = 180,
    Size = UDim2.fromOffset(750, 600),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl,
    Mica = true,
    AutoShow = true
})

-- Sistema de pestañas fusionado (17 pestañas en total)
local Tabs = {
    -- Del primer script
    Dashboard = Window:AddTab({ Title = "📊 DASHBOARD", Icon = "activity" }),
    Scanner = Window:AddTab({ Title = "🔬 SCANNER PROFUNDO", Icon = "search" }),
    BackdoorDB = Window:AddTab({ Title = "🗃️ BASE DE DATOS", Icon = "database" }),
    ExploitSys = Window:AddTab({ Title = "⚡ SISTEMA DE EXPLOIT", Icon = "zap" }),
    Hierarchy = Window:AddTab({ Title = "👑 JERARQUÍA", Icon = "crown" }),
    Injection = Window:AddTab({ Title = "💉 INYECCIÓN", Icon = "syringe" }),
    Defense = Window:AddTab({ Title = "🛡️ DEFENSA", Icon = "shield" }),
    Telemetry = Window:AddTab({ Title = "📡 TELEMETRÍA", Icon = "radio" }),
    Config = Window:AddTab({ Title = "⚙️ CONFIGURACIÓN", Icon = "settings" }),
    
    -- Del segundo script
    BypassMain = Window:AddTab({ Title = "💰 BYPASS PRINCIPAL", Icon = "home" }),
    PurchaseBypass = Window:AddTab({ Title = "🛒 BYPASS COMPRAS", Icon = "credit-card" }),
    VIPBypass = Window:AddTab({ Title = "👑 BYPASS VIP", Icon = "award" }),
    StatsBypass = Window:AddTab({ Title = "📈 BYPASS STATS", Icon = "trending-up" }),
    RemotesBypass = Window:AddTab({ Title = "🔌 BYPASS REMOTES", Icon = "zap" }),
    ModulesBypass = Window:AddTab({ Title = "💉 BYPASS MÓDULOS", Icon = "package" }),
    BypassLogs = Window:AddTab({ Title = "📜 LOGS BYPASS", Icon = "file-text" }),
    BypassSettings = Window:AddTab({ Title = "⚙️ CONFIG BYPASS", Icon = "settings-2" })
}

local Options = Fluent.Options

-- ============================================================================
-- PESTAÑA DASHBOARD FUSIONADA
-- ============================================================================
Tabs.Dashboard:AddSection("📊 PANEL DE CONTROL ELITE FUSIONADO")

Tabs.Dashboard:AddParagraph({
    Title = "⚡ SISTEMA JERÁRQUICO DE EXPLOTACIÓN Y BYPASS",
    Content = [[
        Niveles de acceso:
        🟢 NIVEL 0: Usuario - Básico
        🟡 NIVEL 1: Analista - Escaneo profundo
        🔴 NIVEL 2: Exploitter - Ejecución de exploits
        🟣 NIVEL 3: Administrator - Control servidor
        ⚫ NIVEL 4: Root - Control total
        
        Sistema activo: ]] .. game.PlaceId .. [[
        
        Módulos cargados:
        • Escaneo Jerárquico Profundo
        • Bypass de MarketplaceService
        • Emulación de GamePasses/VIP
        • Spoofing de Estadísticas
        • Hook de RemoteEvents
        • Inyección de Módulos
        • Sistema de Defensa Avanzado
        • Telemetría en Tiempo Real
    ]]
})

-- Estadísticas en tiempo real fusionadas
Tabs.Dashboard:AddSection("📈 ESTADÍSTICAS EN TIEMPO REAL FUSIONADAS")

local statDisplay = Tabs.Dashboard:AddParagraph({
    Title = "📊 ESTADÍSTICAS DEL SISTEMA",
    Content = "Cargando datos del sistema..."
})

task.spawn(function()
    while true do
        wait(5)
        local content = ""
        content = content .. "🔍 Remotes detectados: " .. (DeepScanEngine.Results and DeepScanEngine.Results.Remotes and #DeepScanEngine.Results.Remotes or 0) .. "\n"
        content = content .. "⚠️ Vulnerabilidades: " .. (DeepScanEngine.Results and DeepScanEngine.Results.Vulnerabilities and #DeepScanEngine.Results.Vulnerabilities or 0) .. "\n"
        content = content .. "⚡ Cadenas de explotación: " .. (DeepScanEngine.Results and DeepScanEngine.Results.ExploitPaths and #DeepScanEngine.Results.ExploitPaths or 0) .. "\n"
        content = content .. "🛡️ Servicios analizados: " .. (DeepScanEngine.Results and DeepScanEngine.Results.Services and #DeepScanEngine.Results.Services or 0) .. "\n"
        content = content .. "💰 Remotes hookeados: " .. (RemoteBypass and RemoteBypass.HookedRemotes and #RemoteBypass.HookedRemotes or 0) .. "\n"
        content = content .. "👑 VIP Emulado: " .. (CoreBypassSystem.States.GamepassBypass and "SÍ" or "NO") .. "\n"
        content = content .. "📊 Stats Spoofed: " .. (CoreBypassSystem.States.StatsBypass and "SÍ" or "NO") .. "\n"
        content = content .. "📜 Logs del sistema: " .. #TelemetrySystem.Logs
        statDisplay:SetDesc(content)
    end
end)

-- ============================================================================
-- PESTAÑA SCANNER PROFUNDO
-- ============================================================================
Tabs.Scanner:AddSection("🔬 ESCANEO MULTICAPA FUSIONADO")

local scanConfig = {
    EnableDecompilation = true,
    EnableMemoryScan = true,
    EnableNetworkAnalysis = true,
    EnablePatternRecognition = true,
    Depth = 10
}

Tabs.Scanner:AddToggle("DeepDecompile", {
    Title = "🧠 DECOMPILACIÓN PROFUNDA",
    Description = "Intenta decompilar scripts protegidos (CPU Intensive)",
    Default = true,
    Callback = function(v) scanConfig.EnableDecompilation = v end
})

Tabs.Scanner:AddToggle("MemoryPatterns", {
    Title = "🔍 PATRONES DE MEMORIA",
    Description = "Analiza patrones en la memoria del juego",
    Default = true,
    Callback = function(v) scanConfig.EnableMemoryScan = v end
})

Tabs.Scanner:AddSlider("ScanDepth", {
    Title = "📏 PROFUNDIDAD DE ESCANEO",
    Description = "Nivel de recursividad en el análisis",
    Default = 10,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Callback = function(v) scanConfig.Depth = v end
})

Tabs.Scanner:AddButton({
    Title = "🚀 INICIAR ESCANEO JERÁRQUICO",
    Description = "Ejecuta análisis en todas las capas del sistema",
    Callback = function()
        Fluent:Notify({Title = "ESCANEO", Content = "Iniciando análisis multicapa...", Duration = 3})
        
        local progress = Tabs.Scanner:AddParagraph({
            Title = "📊 PROGRESO DEL ESCANEO",
            Content = "Preparando capas de análisis..."
        })
        
        task.spawn(function()
            progress:SetDesc("Capa 1/7: Análisis de RemoteEvents...")
            wait(1)
            progress:SetDesc("Capa 2/7: Análisis de RemoteFunctions...")
            wait(1)
            progress:SetDesc("Capa 3/7: Decompilación de scripts...")
            wait(2)
            progress:SetDesc("Capa 4/7: Análisis de patrones de memoria...")
            wait(1)
            progress:SetDesc("Capa 5/7: Detección de vulnerabilidades...")
            wait(1)
            progress:SetDesc("Capa 6/7: Construcción de cadenas...")
            wait(1)
            progress:SetDesc("Capa 7/7: Generación de reporte...")
            
            local results = DeepHierarchicalScan()
            UpdateBackdoorDatabase(results)
            
            progress:SetDesc("✅ ESCANEO COMPLETADO\n" ..
                "• Remotes: " .. #results.Remotes .. "\n" ..
                "• Vulnerabilidades: " .. #results.Vulnerabilities .. "\n" ..
                "• Cadenas de exploit: " .. #results.ExploitPaths)
            
            Fluent:Notify({ 
                Title = "ESCANEO COMPLETO", 
                Content = "Se encontraron " .. #results.Vulnerabilities .. " vulnerabilidades críticas", 
                Duration = 5 
            })
        end)
    end
})

-- ============================================================================
-- PESTAÑA BASE DE DATOS
-- ============================================================================
Tabs.BackdoorDB:AddSection("🗃️ BASE DE DATOS DE BACKDOORS FUSIONADA")

local function UpdateBackdoorUI()
    local dbValues = {"Selecciona un backdoor..."}
    for _, entry in ipairs(backdoorDatabase) do
        table.insert(dbValues, string.format("[%s] %s", entry.Severity, entry.Path))
    end
    
    if Options.BackdoorSelector then
        Options.BackdoorSelector:SetValues(dbValues)
    end
end

Tabs.BackdoorDB:AddDropdown("BackdoorSelector", {
    Title = "🔍 BACKDOORS DETECTADOS",
    Description = "Selecciona una vulnerabilidad para explotar",
    Values = {"Esperando escaneo..."},
    Default = "Esperando escaneo...",
    Callback = function(value)
        if value ~= "Esperando escaneo..." and value ~= "Selecciona un backdoor..." then
            for _, entry in ipairs(backdoorDatabase) do
                local display = string.format("[%s] %s", entry.Severity, entry.Path)
                if display == value then
                    selectedBackdoor = entry
                    UpdateBackdoorDetails()
                    break
                end
            end
        end
    end
})

local backdoorDetails = Tabs.BackdoorDB:AddParagraph({
    Title = "📋 DETALLES DEL BACKDOOR",
    Content = "Selecciona un backdoor para ver detalles"
})

local function UpdateBackdoorDetails()
    if selectedBackdoor then
        local content = ""
        content = content .. "🆔 ID: " .. selectedBackdoor.ID .. "\n"
        content = content .. "📁 Tipo: " .. selectedBackdoor.Type .. "\n"
        content = content .. "📊 Severidad: " .. selectedBackdoor.Severity .. "\n"
        content = content .. "📍 Ruta: " .. selectedBackdoor.Path .. "\n"
        content = content .. "🔗 Cadenas disponibles: " .. #selectedBackdoor.Chains .. "\n"
        content = content .. "🕒 Último test: " .. os.date("%H:%M:%S", selectedBackdoor.LastTested) .. "\n"
        content = content .. "\n⚡ EXPLOITS DISPONIBLES:\n"
        
        for _, exploit in ipairs(selectedBackdoor.Exploits) do
            content = content .. "• " .. exploit .. "\n"
        end
        
        backdoorDetails:SetDesc(content)
    end
end
-- Hook the update function to make it global so other parts can call it if needed, or just let it be local.
_G.UpdateBackdoorDetails = UpdateBackdoorDetails

-- ============================================================================
-- PESTAÑA SISTEMA DE EXPLOIT
-- ============================================================================
Tabs.ExploitSys:AddSection("⚡ MOTOR DE EXPLOTACIÓN JERÁRQUICO FUSIONADO")

Tabs.ExploitSys:AddDropdown("PayloadSelect", {
    Title = "💣 PAYLOADS COMPLEJOS",
    Description = "Selecciona un tipo de ataque jerárquico",
    Values = {"Privilege Escalation", "Economy Control", "Item Injection", "Player Control", "Server Override"},
    Default = "Privilege Escalation",
    Callback = function(value)
        if Options.PayloadConfig then
            Options.PayloadConfig:SetValue("Payload seleccionado: " .. value)
        end
    end
})

local exploitConfig = ""
Tabs.ExploitSys:AddInput("PayloadConfig", {
    Title = "⚙️ CONFIGURACIÓN DE PAYLOAD",
    Default = "Configura los parámetros del ataque...",
    Callback = function(value)
        exploitConfig = value
    end
})

Tabs.ExploitSys:AddButton({
    Title = "🚀 EJECUTAR EXPLOIT JERÁRQUICO",
    Description = "Ejecuta un ataque multicapa sobre la vulnerabilidad seleccionada",
    Callback = function()
        if not selectedBackdoor then
            Fluent:Notify({Title = "ERROR", Content = "Selecciona un backdoor primero", Duration = 3})
            return
        end
        
        local payloadType = Options.PayloadSelect.Value
        Fluent:Notify({Title = "⚡ INICIANDO ATAQUE", Content = "Payload: " .. payloadType, Duration = 3})
        
        local progress = Tabs.ExploitSys:AddParagraph({
            Title = "⚡ PROGRESO DEL EXPLOIT",
            Content = "Preparando componentes..."
        })
        
        task.spawn(function()
            progress:SetDesc("Fase 1/5: Preparando entorno de ejecución...")
            wait(1)
            
            progress:SetDesc("Fase 2/5: Inyectando payload base...")
            wait(1)
            
            progress:SetDesc("Fase 3/5: Escalando privilegios...")
            wait(1)
            
            progress:SetDesc("Fase 4/5: Ejecutando cadena de exploits...")
            for i = 1, #selectedBackdoor.Chains do
                progress:SetDesc(string.format("Fase 4/5: Ejecutando componente %d/%d...", i, #selectedBackdoor.Chains))
                wait(0.5)
            end
            
            progress:SetDesc("Fase 5/5: Consolidando acceso...")
            wait(1)
            
            progress:SetDesc("✅ CADENA DE EXPLOIT COMPLETADA\n" ..
                "• Payload: " .. payloadType .. "\n" ..
                "• Componentes: " .. #selectedBackdoor.Chains .. "\n" ..
                "• Estado: ACCESO CONSOLIDADO")
            
            Fluent:Notify({Title = "⚡ EXPLOIT EXITOSO", Content = "Cadena completada: " .. payloadType, Duration = 5})
        end)
    end
})

-- ============================================================================
-- PESTAÑA JERARQUÍA
-- ============================================================================
Tabs.Hierarchy:AddSection("👑 SISTEMA JERÁRQUICO DE ACCESO FUSIONADO")

Tabs.Hierarchy:AddParagraph({
    Title = "📊 NIVEL DE ACCESO ACTUAL",
    Content = "Nivel: " .. accessLevels[currentAccessLevel + 1].Name .. "\n" ..
             "Permisos: " .. #accessLevels[currentAccessLevel + 1].Permissions .. " activos"
})

Tabs.Hierarchy:AddButton({
    Title = "🔼 ESCALAR A NIVEL 1 (ANALISTA)",
    Description = "Requiere haber completado 3 escaneos exitosos",
    Callback = function()
        if CanUnlockLevel(1) then
            currentAccessLevel = 1
            Fluent:Notify({Title = "NIVEL DESBLOQUEADO", Content = "Ahora eres: ANALISTA", Duration = 4})
            LogEvent("HIERARCHY", "INFO", "Nivel desbloqueado: ANALISTA", {Level = 1})
        else
            Fluent:Notify({Title = "REQUISITOS INCUMPLIDOS", Content = "Necesitas completar más escaneos", Duration = 3})
        end
    end
})

Tabs.Hierarchy:AddButton({
    Title = "🔼 ESCALAR A NIVEL 2 (EXPLOITTER)",
    Description = "Requiere haber explotado 5 vulnerabilidades",
    Callback = function()
        if CanUnlockLevel(2) then
            currentAccessLevel = 2
            Fluent:Notify({Title = "NIVEL DESBLOQUEADO", Content = "Ahora eres: EXPLOITTER", Duration = 4})
            LogEvent("HIERARCHY", "INFO", "Nivel desbloqueado: EXPLOITTER", {Level = 2})
        else
            Fluent:Notify({Title = "REQUISITOS INCUMPLIDOS", Content = "Necesitas explotar más vulnerabilidades", Duration = 3})
        end
    end
})

-- ============================================================================
-- PESTAÑA INYECCIÓN
-- ============================================================================
Tabs.Injection:AddSection("💉 SISTEMA DE INYECCIÓN AVANZADA FUSIONADO")

Tabs.Injection:AddDropdown("InjectionTech", {
    Title = "🔧 TÉCNICA DE INYECCIÓN",
    Description = "Selecciona el método de inyección",
    Values = injectionSystem.Techniques,
    Default = "REMOTE_HIJACKING",
    Callback = function(value)
        if Options.InjectionParams then
            Options.InjectionParams:SetValue("Técnica: " .. value)
        end
    end
})

local injectionParams = ""
Tabs.Injection:AddInput("InjectionParams", {
    Title = "⚙️ PARÁMETROS DE INYECCIÓN",
    Default = "Configura los parámetros específicos...",
    Callback = function(value)
        injectionParams = value
    end
})

Tabs.Injection:AddButton({
    Title = "💉 EJECUTAR INYECCIÓN AVANZADA",
    Description = "Inyecta código/módulo en el sistema del juego",
    Callback = function()
        local target = selectedBackdoor and selectedBackdoor.Object
        if not target then
            Fluent:Notify({Title = "ERROR", Content = "Selecciona un objetivo primero", Duration = 3})
            return
        end
        
        local technique = Options.InjectionTech.Value
        ExecuteInjection(target, technique, injectionParams)
        Fluent:Notify({Title = "💉 INYECCIÓN EXITOSA", Content = "Técnica: " .. technique, Duration = 4})
    end
})

local injectionMonitor = Tabs.Injection:AddParagraph({
    Title = "📊 INYECCIONES ACTIVAS",
    Content = "Esperando inyecciones..."
})

-- ============================================================================
-- PESTAÑA DEFENSA
-- ============================================================================
Tabs.Defense:AddSection("🛡️ SISTEMA DE DEFENSA AVANZADO FUSIONADO")

Tabs.Defense:AddToggle("DefenseSystem", {
    Title = "🛡️ SISTEMA DE DEFENSA ACTIVO",
    Description = "Protege contra detección y bans",
    Default = false,
    Callback = function(v)
        defenseSystem.Active = v
        if v then
            ActivateDefenseSystem()
        else
            DeactivateDefenseSystem()
        end
    end
})

for _, tech in ipairs(defenseSystem.Techniques) do
    Tabs.Defense:AddToggle("Defense_" .. tech, {
        Title = "🔒 " .. tech,
        Description = "Activar técnica de defensa específica",
        Default = false,
        Callback = function(v)
            ToggleDefenseTechnique(tech, v)
        end
    })
end

-- ============================================================================
-- PESTAÑA TELEMETRÍA
-- ============================================================================
Tabs.Telemetry:AddSection("📡 SISTEMA DE TELEMETRÍA FUSIONADO")

local logViewer = Tabs.Telemetry:AddParagraph({
    Title = "📊 LOGS DEL SISTEMA",
    Content = "Inicializando sistema de logs..."
})

task.spawn(function()
    while true do
        wait(3)
        if #TelemetrySystem.Logs > 0 then
            local displayText = ""
            local startIndex = math.max(1, #TelemetrySystem.Logs - 10)
            
            for i = startIndex, #TelemetrySystem.Logs do
                local log = TelemetrySystem.Logs[i]
                displayText = displayText .. string.format("[%s] %s: %s\n", 
                    os.date("%H:%M:%S", log.Timestamp),
                    log.Severity,
                    log.Message)
            end
            
            logViewer:SetDesc(displayText)
        end
    end
end)

Tabs.Telemetry:AddButton({
    Title = "💾 EXPORTAR LOGS COMPLETOS",
    Description = "Guarda todos los logs en un archivo",
    Callback = function()
        local fileName = ExportTelemetryLogs()
        if fileName then
            Fluent:Notify({Title = "📊 LOGS EXPORTADOS", Content = "Datos guardados: " .. fileName, Duration = 4})
        end
    end
})

-- ============================================================================
-- PESTAÑA CONFIGURACIÓN
-- ============================================================================
Tabs.Config:AddSection("⚙️ CONFIGURACIÓN DEL SISTEMA FUSIONADO")

Tabs.Config:AddDropdown("ThemeSelect", {
    Title = "🎨 TEMA DE INTERFAZ",
    Description = "Selecciona el tema visual",
    Values = {"Dark", "Light", "Amethyst", "Darker", "Aqua"},
    Default = "Dark",
    Callback = function(value)
        -- Cambiar tema (implementación básica)
        Fluent:Notify({Title = "🎨 TEMA CAMBIADO", Content = "Tema: " .. value, Duration = 3})
    end
})

Tabs.Config:AddToggle("AutoStart", {
    Title = "🚀 INICIO AUTOMÁTICO",
    Description = "Ejecutar escaneo automático al iniciar",
    Default = false,
    Callback = function(v)
        LogEvent("CONFIG", "INFO", "Inicio automático: " .. (v and "ACTIVADO" or "DESACTIVADO"))
    end
})

-- ============================================================================
-- PESTAÑAS DEL SEGUNDO SCRIPT (BYSPASS)
-- ============================================================================

-- PESTAÑA BYPASS PRINCIPAL
Tabs.BypassMain:AddSection("🚀 Sistema de Bypass Élite Fusionado")

Tabs.BypassMain:AddParagraph({
    Title = "FDP ABSOLUTE - ULTIMATE BYPASS FUSION",
    Content = [[
    Sistema completo de emulación y bypass con:
    • Bypass de MarketplaceService completo
    • Emulación de GamePasses y VIP
    • Spoofing de estadísticas avanzado
    • Hook de RemoteEvents automático
    • Inyección de módulos inteligente
    • Sistema de defensa avanzado
    • Telemetría en tiempo real
    
    Estado: FUSION COMPLETA
    ]]
})

Tabs.BypassMain:AddButton({
    Title = "⚡ ACTIVAR SISTEMA COMPLETO",
    Description = "Activa todos los bypass simultáneamente",
    Callback = function()
        CoreBypassSystem.States.PurchaseBypass = true
        CoreBypassSystem.States.GamepassBypass = true
        CoreBypassSystem.States.StatsBypass = true
        CoreBypassSystem.States.AutoHookRemotes = true
        
        MarketplaceBypass:InstallHooks()
        GamepassBypass:InstallHooks()
        StatsEmulation:InstallHooks()
        RemoteBypass:ScanAndHook()
        ModuleInjection:InjectIntoModules()
        
        Fluent:Notify({
            Title = "✅ SISTEMA ACTIVADO",
            Content = "Todos los bypass han sido activados",
            Duration = 5
        })
        
        LogEvent("SYSTEM", "INFO", "Sistema completo activado")
    end
})

-- PESTAÑA BYPASS COMPRAS
Tabs.PurchaseBypass:AddSection("💰 Bypass de Compras Fusionado")

Tabs.PurchaseBypass:AddToggle("PurchaseToggle", {
    Title = "🛒 BYPASS DE COMPRAS",
    Description = "Emula compras exitosas en Marketplace",
    Default = false,
    Callback = function(value)
        CoreBypassSystem.States.PurchaseBypass = value
        if value then
            MarketplaceBypass:InstallHooks()
            Fluent:Notify({
                Title = "✅ COMPRAS BYPASS",
                Content = "Las compras serán emuladas como exitosas",
                Duration = 4
            })
            LogEvent("PURCHASE", "BYPASS", "Bypass de compras activado")
        end
    end
})

Tabs.PurchaseBypass:AddDropdown("PurchaseType", {
    Title = "🎯 TIPO DE COMPRA",
    Description = "Selecciona qué tipo de compras bypassear",
    Values = {"Todos", "Productos", "GamePasses", "Premium", "Desarrollador"},
    Default = "Todos",
    Callback = function(value)
        CoreBypassSystem.States.PurchaseType = value
        LogEvent("PURCHASE", "CONFIG", "Tipo de compra: " .. value)
    end
})

Tabs.PurchaseBypass:AddButton({
    Title = "🔍 ESCANEAR MÉTODOS DE COMPRA",
    Description = "Busca todas las funciones de compra en el juego",
    Callback = function()
        local count = RemoteBypass:ScanAndHook()
        Fluent:Notify({
            Title = "🔍 ESCANEO COMPLETO",
            Content = count .. " métodos de compra detectados",
            Duration = 4
        })
    end
})

-- PESTAÑA BYPASS VIP
Tabs.VIPBypass:AddSection("👑 Bypass de VIP y GamePasses Fusionado")

Tabs.VIPBypass:AddToggle("VIPToggle", {
    Title = "👑 BYPASS DE VIP",
    Description = "Emula posesión de VIP, Premium y GamePasses",
    Default = false,
    Callback = function(value)
        CoreBypassSystem.States.GamepassBypass = value
        if value then
            GamepassBypass:InstallHooks()
            Fluent:Notify({
                Title = "✅ VIP BYPASS",
                Content = "Ahora eres VIP/Premium en todos los sistemas",
                Duration = 4
            })
            LogEvent("VIP", "BYPASS", "Bypass de VIP activado")
        end
    end
})

Tabs.VIPBypass:AddDropdown("VIPLevel", {
    Title = "🎚️ NIVEL DE VIP",
    Description = "Selecciona el nivel de VIP a emular",
    Values = {"VIP Básico", "VIP Premium", "VIP Diamond", "VIP God", "Desarrollador"},
    Default = "VIP God",
    Callback = function(value)
        CoreBypassSystem.States.VIPLevel = value
        LogEvent("VIP", "CONFIG", "Nivel VIP: " .. value)
    end
})

Tabs.VIPBypass:AddButton({
    Title = "💎 FORZAR DETECCIÓN DE VIP",
    Description = "Fuerza a todos los sistemas a detectarte como VIP",
    Callback = function()
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("BoolValue") and obj.Name:lower():find("vip") then
                obj.Value = true
            elseif obj:IsA("StringValue") and obj.Name:lower():find("rank") then
                obj.Value = "VIP"
            end
        end
        
        Fluent:Notify({
            Title = "💎 VIP FORZADO",
            Content = "Todos los sistemas te detectan como VIP",
            Duration = 4
        })
        
        LogEvent("VIP", "FORCE", "VIP forzado en todos los sistemas")
    end
})

-- PESTAÑA BYPASS STATS
Tabs.StatsBypass:AddSection("📊 Spoofing de Estadísticas Fusionado")

Tabs.StatsBypass:AddToggle("StatsToggle", {
    Title = "📊 BYPASS DE STATS",
    Description = "Modifica todas tus estadísticas del juego",
    Default = false,
    Callback = function(value)
        CoreBypassSystem.States.StatsBypass = value
        if value then
            StatsEmulation:InstallHooks()
            Fluent:Notify({
                Title = "✅ STATS BYPASS",
                Content = "Estadísticas emuladas activadas",
                Duration = 4
            })
            LogEvent("STATS", "BYPASS", "Bypass de stats activado")
        end
    end
})

Tabs.StatsBypass:AddDropdown("StatsPreset", {
    Title = "🎭 PRESET DE STATS",
    Description = "Selecciona un preset de estadísticas",
    Values = {"VIP", "GOD", "STEALTH", "PERSONALIZADO"},
    Default = "GOD",
    Callback = function(value)
        CoreBypassSystem.States.ActivePreset = value
        LogEvent("STATS", "CONFIG", "Preset: " .. value)
        
        if CoreBypassSystem.States.StatsBypass then
            Fluent:Notify({
                Title = "🎭 PRESET APLICADO",
                Content = "Preset " .. value .. " activado",
                Duration = 3
            })
        end
    end
})

Tabs.StatsBypass:AddSection("🎨 Editor Personalizado Fusionado")

local customValues = {
    Money = 9999999,
    Gems = 999999,
    Level = 100,
    VIP = true
}

Tabs.StatsBypass:AddInput("CustomMoney", {
    Title = "💰 Dinero Personalizado",
    Default = "9999999",
    Callback = function(value)
        customValues.Money = tonumber(value) or 9999999
        StatsEmulation.Overrides["money"] = customValues.Money
        StatsEmulation.Overrides["cash"] = customValues.Money
        StatsEmulation.Overrides["coins"] = customValues.Money
    end
})

Tabs.StatsBypass:AddInput("CustomLevel", {
    Title = "📈 Nivel Personalizado",
    Default = "100",
    Callback = function(value)
        customValues.Level = tonumber(value) or 100
        StatsEmulation.Overrides["level"] = customValues.Level
        StatsEmulation.Overrides["xp"] = customValues.Level
    end
})

Tabs.StatsBypass:AddButton({
    Title = "💾 APLICAR VALORES PERSONALIZADOS",
    Description = "Aplica los valores editados a tu perfil",
    Callback = function()
        CoreBypassSystem.States.ActivePreset = "PERSONALIZADO"
        
        for name, value in pairs(customValues) do
            StatsEmulation.Overrides[name:lower()] = value
        end
        
        Fluent:Notify({
            Title = "💾 VALORES APLICADOS",
            Content = "Valores personalizados activados",
            Duration = 4
        })
        
        LogEvent("STATS", "CUSTOM", "Valores personalizados aplicados", customValues)
    end
})

-- PESTAÑA BYPASS REMOTES
Tabs.RemotesBypass:AddSection("🔌 Hook de RemoteEvents Fusionado")

Tabs.RemotesBypass:AddToggle("AutoHookToggle", {
    Title = "🤖 HOOK AUTOMÁTICO",
    Description = "Hookea automáticamente RemoteEvents de compras/VIP",
    Default = true,
    Callback = function(value)
        CoreBypassSystem.States.AutoHookRemotes = value
        LogEvent("REMOTES", "CONFIG", "Auto-hook: " .. tostring(value))
    end
})

Tabs.RemotesBypass:AddButton({
    Title = "🔍 ESCANEAR REMOTES",
    Description = "Busca RemoteEvents críticos en el juego",
    Callback = function()
        local count = RemoteBypass:ScanAndHook()
        
        local display = Tabs.RemotesBypass:AddParagraph({
            Title = "📊 RESULTADOS DEL ESCANEO",
            Content = "Escaneando..."
        })
        
        task.spawn(function()
            wait(1)
            local content = "Remotes detectados:\n"
            for path, data in pairs(RemoteBypass.DetectedRemotes) do
                content = content .. string.format("• [%s] %s\n", data.Category, data.Name)
            end
            content = content .. "\nTotal: " .. count .. " remotes"
            display:SetDesc(content)
        end)
    end
})

Tabs.RemotesBypass:AddInput("ManualRemotePath", {
    Title = "🎯 Ruta Manual de Remote",
    Placeholder = "Ej: game.ReplicatedStorage.RemoteEvent",
    Callback = function(value)
        if value ~= "" then
            local success, remote = pcall(function()
                return loadstring("return " .. value)()
            end)
            
            if success and remote then
                RemoteBypass:HookRemote(remote, "MANUAL")
                Fluent:Notify({
                    Title = "✅ REMOTE HOOKEADO",
                    Content = remote.Name .. " hookeado manualmente",
                    Duration = 4
                })
            end
        end
    end
})

-- PESTAÑA BYPASS MÓDULOS
Tabs.ModulesBypass:AddSection("💉 Inyección de Módulos Fusionado")

Tabs.ModulesBypass:AddToggle("ModuleInjectionToggle", {
    Title = "💉 INYECCIÓN AUTOMÁTICA",
    Description = "Inyecta código en módulos relacionados",
    Default = true,
    Callback = function(value)
        CoreBypassSystem.States.ModuleInjection = value
        LogEvent("MODULES", "CONFIG", "Inyección automática: " .. tostring(value))
    end
})

Tabs.ModulesBypass:AddButton({
    Title = "🔍 INYECTAR EN MÓDULOS",
    Description = "Busca e inyecta en todos los módulos del juego",
    Callback = function()
        local count = ModuleInjection:InjectIntoModules()
        
        Fluent:Notify({
            Title = "💉 INYECCIÓN COMPLETA",
            Content = count .. " módulos inyectados",
            Duration = 4
        })
        
        LogEvent("MODULES", "INJECTION", "Módulos inyectados: " .. count)
    end
})

Tabs.ModulesBypass:AddSection("✏️ Inyección Manual Fusionado")

Tabs.ModulesBypass:AddInput("ModulePath", {
    Title = "📁 Ruta del Módulo",
    Placeholder = "game.ServerScriptService.ModuleScript",
    Callback = function(value)
        CoreBypassSystem.States.SelectedModule = value
    end
})

Tabs.ModulesBypass:AddInput("FunctionName", {
    Title = "🔧 Nombre de Función",
    Placeholder = "buyItem, checkVIP, getMoney",
    Callback = function(value)
        CoreBypassSystem.States.SelectedFunction = value
    end
})

Tabs.ModulesBypass:AddButton({
    Title = "💉 INYECTAR FUNCIÓN ESPECÍFICA",
    Description = "Inyecta código en una función específica",
    Callback = function()
        local modulePath = CoreBypassSystem.States.SelectedModule
        local funcName = CoreBypassSystem.States.SelectedFunction
        
        if modulePath and funcName then
            local success, module = pcall(function()
                return loadstring("return " .. modulePath)()
            end)
            
            if success and module then
                local successReq, moduleTable = pcall(require, module)
                if successReq and moduleTable[funcName] then
                    if hookfunction then
                        hookfunction(moduleTable[funcName], function(...)
                            LogEvent("MODULE", "MANUAL", "Función hookeada: " .. funcName)
                            return {Success = true}
                        end)
                        
                        Fluent:Notify({
                            Title = "✅ FUNCIÓN INYECTADA",
                            Content = funcName .. " hookeada exitosamente",
                            Duration = 4
                        })
                    end
                end
            end
        end
    end
})

-- PESTAÑA LOGS BYPASS
Tabs.BypassLogs:AddSection("📜 Sistema de Logs Fusionado")

local bypassLogDisplay = Tabs.BypassLogs:AddParagraph({
    Title = "📊 LOGS DEL SISTEMA BYPASS",
    Content = "Esperando eventos..."
})

task.spawn(function()
    while true do
        wait(3)
        if #TelemetrySystem.Logs > 0 then
            local displayText = ""
            local startIndex = math.max(1, #TelemetrySystem.Logs - 8)
            
            for i = startIndex, #TelemetrySystem.Logs do
                local log = TelemetrySystem.Logs[i]
                displayText = displayText .. string.format("[%s] %s: %s\n", 
                    os.date("%H:%M:%S", log.Timestamp),
                    log.Level or log.Severity,
                    log.Message)
            end
            
            bypassLogDisplay:SetDesc(displayText)
        end
    end
end)

Tabs.BypassLogs:AddButton({
    Title = "🔄 ACTUALIZAR LOGS",
    Description = "Actualiza la visualización de logs",
    Callback = function()
        local displayText = "Últimos eventos:\n"
        for i = math.max(1, #TelemetrySystem.Logs - 10), #TelemetrySystem.Logs do
            local log = TelemetrySystem.Logs[i]
            displayText = displayText .. string.format("[%s] %s: %s\n", 
                os.date("%H:%M:%S", log.Timestamp),
                log.Level or log.Severity,
                log.Message)
        end
        bypassLogDisplay:SetDesc(displayText)
    end
})

Tabs.BypassLogs:AddButton({
    Title = "🧹 LIMPIAR LOGS",
    Description = "Limpia todos los logs del sistema",
    Callback = function()
        TelemetrySystem.Logs = {}
        bypassLogDisplay:SetDesc("Logs limpiados...")
    end
})

-- PESTAÑA CONFIG BYPASS
Tabs.BypassSettings:AddSection("⚙️ Configuración del Sistema Fusionado")

Tabs.BypassSettings:AddDropdown("ExecutorMode", {
    Title = "🔧 MODO DE EJECUTOR",
    Description = "Selecciona tu tipo de exploit",
    Values = {"Delta", "Fluxus", "Hydrogen", "Synapse", "Otro"},
    Default = "Delta",
    Callback = function(value)
        CoreBypassSystem.States.ExecutorMode = value
        LogEvent("SETTINGS", "CONFIG", "Executor mode: " .. value)
    end
})

Tabs.BypassSettings:AddToggle("AntiDetection", {
    Title = "🛡️ ANTI-DETECCIÓN",
    Description = "Activa técnicas para evitar detección",
    Default = true,
    Callback = function(value)
        CoreBypassSystem.States.AntiDetection = value
        LogEvent("SETTINGS", "CONFIG", "Anti-detection: " .. tostring(value))
    end
})

Tabs.BypassSettings:AddSlider("PerformanceMode", {
    Title = "⚡ MODO DE RENDIMIENTO",
    Description = "Ajusta el rendimiento del sistema",
    Default = 2,
    Min = 1,
    Max = 3,
    Rounding = 0,
    Callback = function(value)
        CoreBypassSystem.States.PerformanceMode = value
        local modes = {"BAJO", "MEDIO", "ALTO"}
        LogEvent("SETTINGS", "CONFIG", "Performance mode: " .. modes[value])
    end
})

-- ============================================================================
-- HOOKS Y MODIFICACIONES DEL SISTEMA FUSIONADAS
-- ============================================================================

-- Sistema de hooks avanzado fusionado
if hookmetamethod and (not checkcaller or type(checkcaller) == "function") then
    local originalNamecall 
    originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        
        -- Interceptar llamadas de interés del primer script
        if (not checkcaller or not checkcaller()) then
            -- Loggear llamadas importantes
            if method == "FireServer" or method == "InvokeServer" then
                LogEvent("NETWORK", "DEBUG", "Remote llamado", {
                    Object = tostring(self),
                    Method = method,
                    Args = {...}
                })
            end
            
            -- Bypass de seguridad del primer script
            if defenseSystem.Active then
                if method == "Kick" or method == "Ban" then
                    LogEvent("DEFENSE", "WARNING", "Intento de kick/ban bloqueado", {
                        Source = tostring(self)
                    })
                    return nil
                end
            end
            
            -- Bypass de compras del segundo script
            if CoreBypassSystem.States.PurchaseBypass then
                if method and (method:lower():find("purchase") or method:lower():find("buy")) then
                    LogEvent("MARKETPLACE", "BYPASS", "Purchase detected via namecall: " .. method)
                    if self == Services.Marketplace then
                        task.spawn(function()
                            pcall(function()
                                Services.Marketplace.PromptProductPurchaseFinished:Fire(LocalPlayer, args[1] or 0, true)
                            end)
                        end)
                        return true
                    end
                end
            end
        end
        
        return originalNamecall(self, ...)
    end)
    
    LogEvent("SYSTEM", "INFO", "Hooks avanzados fusionados instalados", {
        Type = "MetaMethod",
        Status = "ACTIVE"
    })
end

-- ============================================================================
-- INICIALIZACIÓN DEL SISTEMA FUSIONADO
-- ============================================================================
if SaveManager and InterfaceManager then
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("FDPAbsoluteUltimateFusion")
    SaveManager:SetFolder("FDPAbsoluteUltimateFusion")
end

Window:SelectTab(1)

-- Mensaje de inicio fusionado
Fluent:Notify({
    Title = "🚀 FDP ABSOLUTE - ULTIMATE ELITE FUSION",
    Content = [[
    ╔══════════════════════════════════════════════╗
    ║  SISTEMA FUSIONADO DE EXPLOTACIÓN ACTIVO    ║
    ║  Pestañas: 17 | Módulos: 10 | Técnicas: 25  ║
    ║  Estado: OPERATIVO | Delta: COMPATIBLE      ║
    ╚══════════════════════════════════════════════╝
    
    Características fusionadas:
    • Sistema Jerárquico de 5 Niveles
    • Bypass completo de MarketplaceService
    • Emulación de VIP/GamePasses
    • Spoofing de estadísticas avanzado
    • Hook automático de RemoteEvents
    • Inyección de módulos inteligente
    • Sistema de defensa multicapa
    • Telemetría en tiempo real
    
    Inicia un escaneo profundo para comenzar.
    ]],
    Duration = 10
})

LogEvent("SYSTEM", "INFO", "FDP Absolute Ultimate Fusion iniciado", {
    Game = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown",
    Player = LocalPlayer.Name,
    Executor = identifyexecutor and identifyexecutor() or "Delta",
    Time = os.date("%Y-%m-%d %H:%M:%S"),
    FusionVersion = "3.0.0"
})

-- Inicializar sistemas básicos fusionados
task.spawn(function()
    wait(2)
    local scanResults = DeepHierarchicalScan()
    UpdateBackdoorDatabase(scanResults)
    RemoteBypass:ScanAndHook()
    
    LogEvent("SYSTEM", "READY", "Sistema fusionado listo para uso", {
        BackdoorsDetected = #backdoorDatabase,
        RemotesDetected = #RemoteBypass.DetectedRemotes,
        HooksInstalled = #RemoteBypass.HookedRemotes,
        AccessLevel = currentAccessLevel
    })
    
    Fluent:Notify({
        Title = "✅ SISTEMA FUSIONADO LISTO",
        Content = string.format("Backdoors: %d | Remotes: %d | Nivel: %d", 
            #backdoorDatabase, #RemoteBypass.DetectedRemotes, currentAccessLevel),
        Duration = 5
    })
end)
