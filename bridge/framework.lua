Bridge = Bridge or {}
Bridge.Name = Bridge.Name or 'standalone'
Bridge.Core = Bridge.Core or nil
Bridge.Ready = Bridge.Ready or false

local function resStarted(name)
    return GetResourceState(name) == 'started'
end

function GetFramework()
    if Config and Config.Bridge and Bridge then
        return 'bridge'
    elseif resStarted('qb-core') then
        QBCore = exports['qb-core']:GetCoreObject()
        return 'qbcore'
    elseif resStarted('qbx_core') or resStarted('qbx-core') then
        QBox = exports.qbx_core
        return 'qbox'
    elseif resStarted('es_extended') then
        ESX = exports['es_extended']:getSharedObject()
        return 'esx'
    end
    return 'qbcore' -- fallback
end

local function bindCore(framework)
    if framework == 'qbcore' then
        if not QBCore then
            QBCore = exports['qb-core']:GetCoreObject()
        end
        Bridge.Core = QBCore
    elseif framework == 'qbox' then
        if not QBox then
            QBox = exports.qbx_core
        end
        Bridge.Core = QBox
    elseif framework == 'esx' then
        if not ESX then
            ESX = exports['es_extended']:getSharedObject()
        end
        Bridge.Core = ESX
    elseif framework == 'bridge' then
        Bridge.Core = nil
    else
        Bridge.Core = nil
    end
end

function Bridge.Init()
    local detected = GetFramework()
    Bridge.Name = detected
    bindCore(detected)
    Bridge.Ready = (Bridge.Core ~= nil) or (detected == 'bridge')

    print(('[UiForge] framework set to %s'):format(Bridge.Name))

    if Bridge.Ready then
        return
    end

    print('[UiForge] Warning: framework bridge could not be initialized properly!')
end

function Bridge.GetFramework()
    return Bridge.Name
end

function Bridge.IsReady()
    return Bridge.Ready
end

function Bridge.GetPlayer(src)
    if not src or src <= 0 then
        return nil
    end
    if Bridge.Name == 'qbcore' and QBCore and QBCore.Functions then
        return QBCore.Functions.GetPlayer(src)
    elseif Bridge.Name == 'qbox' and QBox then
        return QBox:GetPlayer(src)
    elseif Bridge.Name == 'esx' and ESX then
        return ESX.GetPlayerFromId(src)
    end
    return nil
end

function Bridge.GetPlayerData()
    if Bridge.Name == 'qbcore' and QBCore and QBCore.Functions then
        return QBCore.Functions.GetPlayerData()
    elseif Bridge.Name == 'qbox' and QBox and QBox.GetPlayerData then
        return QBox:GetPlayerData()
    elseif Bridge.Name == 'esx' and ESX then
        return ESX.GetPlayerData()
    end
    return nil
end

-- TODO: expand bridge with inventory/money/notify for later on

CreateThread(function()
    Bridge.Init()
end)
