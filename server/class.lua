-- Altera Framework - 2020
-- Made by kgtrey1
-- server/class.lua
-- Object that will be shared between scripts.

ARP = {}

--
-- Callbacks (server side implementation)
--

ARP.ServerCallbacks = {}

ARP.RegisterServerCallback = function(callbackName, functionPointer)
    print("registering callback")
    ARP.ServerCallbacks[callbackName] = functionPointer
end

ARP.TriggerServerCallback = function(callbackName, requestId, source, functionPointer, ...)
    if (ARP.ServerCallbacks[callbackName] ~= nil) then
        ARP.ServerCallbacks[callbackName](source, functionPointer, ...)
    else
        print(string.format("arp_framework: Cannot find callback '%s'.", callbackName))
    end
end

RegisterServerEvent('arp:TriggerServerCallback')
AddEventHandler('arp:TriggerServerCallback', function(callbackName, requestId, ...)
    local _source = source

    print("trigered")
    ARP.TriggerServerCallback(callbackName, requestId, _source, function(...)
        TriggerClientEvent('arp:ServerCallback', _source, requestId, ...)
    end, ...)
end)