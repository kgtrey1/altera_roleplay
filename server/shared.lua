-- Altera Framework - 2020
-- Made by kgtrey1
-- server/shared.lua
-- Function used to share the ARP object to other scripts.

function ARPFetchObject(cb)
    cb(ARP)
end

AddEventHandler('arp_framework:FetchObject', function(cb)
    cb(ARP)
end)