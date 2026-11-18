WildTrace = WildTrace or {}
local WT = WildTrace
WT.name = "WildTrace"
WT.version = (GetAddOnMetadata and GetAddOnMetadata("WildTrace", "Version")) or "desconocida"
WT.displayName = "WildTrace"
WT.initialized = false
WT.MainWindowReady = false

function WT.Print(message)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cff7fd4ff[" .. WT.displayName .. "]|r " .. tostring(message))
    end
end

local componentWarnings = {}

local function safeCall(label, callback)
    if type(callback) ~= "function" then
        if not componentWarnings[label] then
            WT.Print("componente no disponible: " .. label)
            componentWarnings[label] = true
        end
        return false
    end
    local ok, err = pcall(callback)
    if not ok then
        if not componentWarnings[label] then
            WT.Print("ERROR al iniciar " .. label .. ": " .. tostring(err))
            componentWarnings[label] = true
        end
        return false
    end
    componentWarnings[label] = nil
    return true
end

local eventFrame = CreateFrame("Frame", "WT_EventFrame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("WORLD_MAP_UPDATE")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local loadedName = ...
        if loadedName == WT.name then
            if not WT.initialized then
                local ok = safeCall("datos y configuración", function()
                    WT.InitializeSavedVariables()
                    WT.RefreshLocalizedData()
                    WT.LoadFilters()
                end)
                WT.initialized = ok
            end
            WT.Print("versión " .. WT.version .. " cargada.")
        end
    elseif event == "PLAYER_LOGIN" then
        if WT.initialized then
            -- Each component starts independently. A window error must not
            -- prevent the minimap or world-map controls from being created.
            safeCall("ventana principal", WT.CreateMainWindow)
            safeCall("botón del minimapa", WT.CreateMinimapButton)
            safeCall("controles del mapa", WT.CreateMapControls)
            safeCall("integración con el mapa", WT.InstallMapHooks)
            if WT.MainWindowReady then
                safeCall("contenido de la lista", WT.RefreshList)
            end
            safeCall("marcadores del mapa", WT.RefreshMapMarkers)
            safeCall("escáner de modelos", WT.StartModelScanner)
        else
            WT.Print("la inicialización no terminó correctamente; activa los errores Lua para revisar el problema.")
        end
    elseif event == "ZONE_CHANGED_NEW_AREA" or event == "ZONE_CHANGED" then
        if WT.initialized and WT.RefreshModelScannerZone then
            WT.RefreshModelScannerZone()
        end
        -- Refrescar solo si el diario esta abierto. Un cambio de subzona
        -- no debe tocar la seleccion manual mientras el registro esta cerrado.
        if WT.initialized and WT.MainFrame and WT.MainFrame:IsShown() then
            if WT.SelectPlayerZone and WT.SelectPlayerZone() then
                safeCall("actualización de zona del registro", WT.RefreshList)
            end
        end
    elseif event == "WORLD_MAP_UPDATE" then
        if WT.initialized then
            safeCall("actualización de marcadores", WT.RefreshMapMarkers)
            if WT.PositionMapOptionsButton then
                safeCall("posición del botón del mapa", WT.PositionMapOptionsButton)
            end
        end
    end
end)

-- Comando principal del registro.
SLASH_WILDTRACE1 = "/wt"
SlashCmdList["WILDTRACE"] = function(message)
    if not WT.initialized then
        WT.Print("el addon todavía se está inicializando.")
        return
    end
    if message and string.lower(string.gsub(message, "^%s*(.-)%s*$", "%1")) == "zona" then
        if WT.PrintPlayerZoneDiagnostic then WT.PrintPlayerZoneDiagnostic() end
        return
    end
    if not WT.MainWindowReady or not WT.MainFrame then
        WT.Print("la ventana principal no pudo inicializarse. Revisa los errores Lua.")
        return
    end
    if WT.MainFrame:IsShown() then
        WT.MainFrame:Hide()
    else
        WT.MainFrame:Show()
        if WT.RefreshList then safeCall("actualización de la lista", WT.RefreshList) end
    end
end
