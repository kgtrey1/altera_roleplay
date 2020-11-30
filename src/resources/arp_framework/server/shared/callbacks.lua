--
-- ALTERA PROJECT, 2020
-- ARP_Framework
-- File description:
-- Callback implementation.
--

ARP.ServerCallbacks = {}

ARP.RegisterServerCallback = function(callbackName, callbackFunction)
    ARP.ServerCallbacks[callbackName] = callbackFunction
end

ARP.TriggerServerCallback = function(callbackName, requestId, source, callbackFunction, ...)
    if (ARP.ServerCallbacks[callbackName] ~= nil) then
        ARP.ServerCallbacks[callbackName](source, callbackFunction, ...)
    else
        print(string.format("ARP> Cannot find callback '%s'.", callbackName))
    end
end

function CallBackHandler(callbackName, requestId, ...)
    local _source = source

    ARP.TriggerServerCallback(callbackName, requestId, _source, function(...)
        TriggerClientEvent('arp_framework:ServerCallback', _source, requestId, ...)
    end, ...)
end

RegisterNetEvent('arp_framework:TriggerServerCallback')
AddEventHandler('arp_framework:TriggerServerCallback', CallBackHandler)