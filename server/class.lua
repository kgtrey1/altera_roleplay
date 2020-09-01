-- Altera Framework - 2020
-- Made by kgtrey1
-- server/class.lua
-- Object that will be shared between scripts.

ARP          = {}
PlayerData   = {}
Items        = {}
Drops        = {}
Drops.List   = {}
Drops.Ticket = 1

--
-- Player data
--

ARP.BuildClientObject = function(source)
    local Alter = ARP.GetPlayerById(source)
    local obj   = {}

    obj.money       = Alter.GetMoney()
    obj.position    = Alter.GetPosition()
    obj.identity    = Alter.GetIdentity()
    obj.inventory   = Alter.GetInventory()
    obj.job         = Alter.GetJob()
    return (obj)
end

ARP.GetPlayerById = function(source)
    return (PlayerData[source])
end

ARP.GetPlayerBySteamid  = function(steamid)
    for i = 1, #PlayerData, 1 do
        if (PlayerData[i].GetSteamid() == steamid) then
            return (PlayerData[i])
        end
    end
    return (nil)
end

-- Section done
-- Callbacks (server side implementation).
--

ARP.ServerCallbacks = {} -- Contain all server callback.

ARP.RegisterServerCallback = function(callbackName, functionPointer)
    ARP.ServerCallbacks[callbackName] = functionPointer
end

ARP.TriggerServerCallback = function(callbackName, requestId, source, functionPointer, ...)
    if (ARP.ServerCallbacks[callbackName] ~= nil) then
        ARP.ServerCallbacks[callbackName](source, functionPointer, ...)
    else
        print(string.format("arp_framework: Cannot find callback '%s'.", callbackName))
    end
end

RegisterNetEvent('arp:TriggerServerCallback')
AddEventHandler('arp:TriggerServerCallback', function(callbackName, requestId, ...)
    local _source = source

    ARP.TriggerServerCallback(callbackName, requestId, _source, function(...)
        TriggerClientEvent('arp:ServerCallback', _source, requestId, ...)
    end, ...)
end)

-- Utils function

ARP.GetSteamIdById = function(id)
    local identifiers = GetPlayerIdentifiers(id)
    local steamid = nil

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamid = string.gsub(v, "steam:", "")
            steamid = tostring(tonumber(steamid, 16))
            return (steamid)
        end
    end
end

ARP.GetLicenseById = function(id)
    local identifiers = GetPlayerIdentifiers(id)

    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            return (string.gsub(v, "license:", ""))
        end
    end
end

-- Jobs

ARP.Jobs = {}

ARP.Jobs.List = {}

ARP.Jobs.GetJob = function(jobname)
    if (ARP.Jobs.List[jobname] ~= nil) then
        return (ARP.Jobs.List[jobname])
    end
    return (nil)
end

ARP.Jobs.GetGradeData = function(jobname, grade)
    if (ARP.Jobs.List[jobname] ~= nil and ARP.Jobs.List[jobname].grades[grade]) then
        return (ARP.Jobs.List[jobname].grades[grade])
    end
    return (nil)
end

-- Items

ARP.Item = {}

ARP.Item.GetItem = function(name)
    return (Items[name])
end