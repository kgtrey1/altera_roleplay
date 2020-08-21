-- Altera Framework - 2020
-- Made by kgtrey1
-- client/class.lua
-- Object that will be shared between scripts.

ARP = {}
ARP.PlayerData = {}

--
-- Callbacks (client side implementation).
--

ARP.ServerCallbacks     = {}
ARP.CurrentRequestId    = 0

ARP.TriggerServerCallback = function(callbackName, functionPointer, ...)
	ARP.ServerCallbacks[ARP.CurrentRequestId] = functionPointer
	TriggerServerEvent('arp:TriggerServerCallback', callbackName, ARP.CurrentRequestId, ...)
	if (ARP.CurrentRequestId < 65535) then
		ARP.CurrentRequestId = ARP.CurrentRequestId + 1
	else
		ARP.CurrentRequestId = 0
	end
end

RegisterNetEvent('arp:ServerCallback')
AddEventHandler('arp:ServerCallback', function(requestId, ...)
	ARP.ServerCallbacks[requestId](...)
	ARP.ServerCallbacks[requestId] = nil
end)