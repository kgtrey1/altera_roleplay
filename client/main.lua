--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- Client side script
--

ARP				= nil

BossMenu            = 'arp_enterprise:BossMenu'


TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
	ARP.Player = playerData
end)

