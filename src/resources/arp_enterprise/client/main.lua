--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- Client side script
--

ARP	= nil

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
	ARP.Player = playerData
	RegisterSafeMenus()
	RegisterBossMenus()
end)