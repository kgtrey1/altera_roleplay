--
-- ALTERA PROJECT, 2020
-- ARP_Skin
-- File description:
-- Server side script.
--

local ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

local function SaveSkin(skin)
    local _source   = source
    local newSkin   = json.encode(skin)
    local Alter     = ARP.GetPlayerById(_source)

    Alter.identity.SetSkin(skin)
    MySQL.Sync.execute('UPDATE users \
    SET `skin` = @skin WHERE steamid = @steamid', {
        ['@skin']       = newSkin,
        ['@steamid']    = Alter.GetSteamid()
    })
    return
end

RegisterNetEvent('arp_skin:SaveSkin')
AddEventHandler('arp_skin:SaveSkin', SaveSkin)