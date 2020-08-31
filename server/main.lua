--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- Server side script
--

ARP = nil

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)