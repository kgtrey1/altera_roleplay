-- Altera Framework - 2020
-- Made by kgtrey1
-- server/class.lua
-- Object that will be shared between scripts.

ARP          = {}
Items        = {}
Drops        = {}
Drops.List   = {}
Drops.Ticket = 1

AddEventHandler('arp_framework:FetchObject', function(cb)
    cb(ARP)
end)

ARP.BuildClientObject = function(source)
    local Alter = ARP.GetPlayerById(source)
    local obj   = {}

    obj.money       = Alter.GetMoney()
    obj.position    = Alter.GetPosition()
    obj.identity    = Alter.GetIdentity()
    obj.inventory   = Alter.GetInventory()
    obj.job         = Alter.GetJob()
    obj.stats       = Alter.GetStats()
    obj.licenses    = ALter.
    return (obj)
end

ARP.GetPlayerById = function(source)
    return (PlayerData[source])
end

ARP.GetPlayerBySteamid  = function(steamid)
    for i = 1, #PlayerData, 1 do
        if (PlayerData[i].GetSteamid() == steamid) then
            return (PlayerData[i])
        end
    end
    return (nil)
end

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