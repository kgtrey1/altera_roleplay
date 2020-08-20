-- Altera Framework - 2020
-- Made by kgtrey1
-- server/class.lua
-- Object that will be shared between scripts.

ARP = {}

ARP.test = 1

--
-- PlayerData
--

ARP.PlayerData = {}

--
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

--
-- Items.
--

ARP.Items       = {}
ARP.Items.List  = {} -- Contains all items with their informations
ARP.Items.Usage = {} -- Contains function that will be called uppon use of an item.

ARP.Items.RegisterUsage = function(name, functionPointer)
    ARP.Items.Usage[name] = functionPointer
end

RegisterNetEvent('arp_framework:UseItem')
AddEventHandler('arp_framework:UseItem', function(itemName)
    local _source = source

    if (ARP.Items.Usage[name] ~= nil) then
        ARP.Items.Usage[name](_source)
    else
        print(string.format("arp_framework: User with SteamID %s tried to use %s. (Invalid item)", ARP.PlayerData.steamid, itemName))
    end
end)