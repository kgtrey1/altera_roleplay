-- Altera Framework - 2020
-- Made by kgtrey1
-- server/class.lua
-- Object that will be shared between scripts.

ARP         = {}
PlayerData  = {}

--
-- Player data
--

ARP.BuildClientObject = function(source)
    local Alter = ARP.GetPlayerById(source)

    return ({
        source = Alter.GetSource(),
        steamid = Alter.GetSteamid(),
        license = Alter.GetLicense(),
        identity = Alter.GetIdentity()
    })
end

ARP.GetPlayerById = function(source)
    return (PlayerData[source])
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