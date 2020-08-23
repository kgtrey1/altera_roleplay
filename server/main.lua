-- Load player

local function LoadPersonnalIdentity(data)
    local skin = nil

    if (data.skin == "") then
        skin = ''
    else
        skin = json.decode(data.skin)
    end
    return ({
        firstname   = data.firstname,
        lastname    = data.lastname,
        birthdate   = data.birthdate,
        gender      = data.gender,
        height      = data.height,
        skin        = skin,
        position    = json.decode(data.position)
    })
end

local function LoadDefaultIdentity()
    return ({
        firstname   = "undefined",
        lastname    = "undefined",
        birthdate   = "undefined",
        gender      = "undefined",
        height      = "undefined",
        skin        = "",
        position    = { x = 0, y = 0, z = 0 }
    })
end

-- Updating position

local function UpdatePlayerPosition(pos)
    local _source = source

    PlayerData[_source].SetPosition(pos)
    return
end

RegisterNetEvent('arp_framework:UpdatePlayerPosition')
AddEventHandler('arp_framework:UpdatePlayerPosition', UpdatePlayerPosition)

-- Saving player

local function SavePlayerIdentity(source)
    local position = PlayerData[source].GetPosition()

    position = json.encode({x = position.x, y = position.y, z = position.z})
    MySQL.Sync.execute('UPDATE users \
    SET `position` = @position, `firstname` = @firstname, `lastname` = @lastname, `height` = @height, `birthdate` = @birthdate \
    WHERE steamid = @steamid', {
        ['@position']   = position,
        ['@firstname']  = PlayerData[source].identity.GetFirstname(),
        ['@lastname']   = PlayerData[source].identity.GetLastname(),
        ['@height']     = PlayerData[source].identity.GetHeight(),
        ['@birthdate']  = PlayerData[source].identity.GetBirthdate(),
        ['@steamid']    = PlayerData[source].GetSteamid()
    })
    return
end

local function SavePlayer(reason)
    local _source = source

    if (PlayerData[_source].GetRegistrationStatus() == true) then
        SavePlayerIdentity(_source)
    end
    if (reason ~= 'global_save') then
        if (PlayerData[_source].GetRegistrationStatus() == true) then
            print(string.format('ARP> Saving %s. Reason: %s', PlayerData[_source].GetSteamid(), reason))
        end
        PlayerData[_source] = nil
    end
    return
end

AddEventHandler('playerDropped', SavePlayer)

-- Loading player

local function LoadPlayer()
    local _source       = source
    local steamid       = ARP.GetSteamIdById(_source)
    local result        = MySQL.Sync.fetchAll("SELECT * FROM users WHERE steamid = @identifier", {
		['@identifier'] = steamid
    })

    if (result[1] ~= nil) then
        PlayerData[_source] = CreateAlter(_source, steamid, ARP.GetLicenseById(_source), true, LoadPersonnalIdentity(result[1]))
        TriggerClientEvent('arp_framework:PlayerLoaded', _source, ARP.BuildClientObject(_source))
    else
        PlayerData[_source] = CreateAlter(_source, steamid, ARP.GetLicenseById(_source), false, LoadDefaultIdentity())
        TriggerClientEvent('arp_register:OpenRegistrationForm', _source)
    end
    return
end

RegisterNetEvent('arp_framework:LoadPlayer')
AddEventHandler('arp_framework:LoadPlayer', LoadPlayer)