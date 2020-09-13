--
-- ALTERA PROJECT, 2020
-- ARP_Fuel
-- File description:
-- Main client side script.
--

ARP = nil

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
    ARP.Player = playerData
end)