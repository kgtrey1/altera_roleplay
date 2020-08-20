function GetSteamIdById(id)
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

function GetLicenseById(id)
    local identifiers = GetPlayerIdentifiers(id)

    for _, v in pairs(identifiers) do
        if string.find(v, "license") then
            return (string.gsub(v, "license:", ""))
        end
    end
end



-- Update player

function UpdatePlayerPosition(coords)
    local _source = source

    print(coords)
    ARP.PlayerData[_source].position = coords
end

RegisterNetEvent('arp_framework:UpdatePlayerPosition')
AddEventHandler('arp_framework:UpdatePlayerPosition', UpdatePlayerPosition)

-- Save player on disconnection and delete stored informations.

function SavePlayer(reason)
    local _source = source
    local position = json.encode({
        x = ARP.PlayerData[_source].position.x,
        y = ARP.PlayerData[_source].position.y,
        z = ARP.PlayerData[_source].position.z
    })

    MySQL.Sync.execute('UPDATE users SET `position` = @lastPosition WHERE steamid = @steamid', {
        ['@lastPosition'] = position,
        ['@steamid'] = ARP.PlayerData[_source].steamid
    })
    ARP.PlayerData[_source] = nil
end

AddEventHandler('playerDropped', SavePlayer)

-- Load player

local function LoadPersonnalData(source, data)
    ARP.PlayerData[source]              = {}
    ARP.PlayerData[source].steamid      = GetSteamIdById(source)
    ARP.PlayerData[source].license      = GetLicenseById(source)
    ARP.PlayerData[source].firstname    = tostring(data.firstname)
    ARP.PlayerData[source].lastname     = tostring(data.lastname)
    ARP.PlayerData[source].birthdate    = tostring(data.birthdate)
    ARP.PlayerData[source].gender       = tostring(data.gender)
    ARP.PlayerData[source].height       = tostring(data.height)
    ARP.PlayerData[source].position     = json.decode(data.position)
end

local function LoadDefaultData(source)
    ARP.PlayerData[source]              = {}
    ARP.PlayerData[source].steamid      = GetSteamIdById(source)
    ARP.PlayerData[source].license      = GetLicenseById(source)
    ARP.PlayerData[source].firstname    = "undefined"
    ARP.PlayerData[source].lastname     = "undefined"
    ARP.PlayerData[source].birthdate    = "undefined"
    ARP.PlayerData[source].gender       = "undefined"
    ARP.PlayerData[source].height       = "undefined"
    ARP.PlayerData[source].position     = "undefined"
end

ARP.RegisterServerCallback('arp:LoadPlayer', function(source, cb)
    local steamid = GetSteamIdById(source)
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE steamid = @identifier", {
		['@identifier'] = steamid
    })

    
    if (result[1] ~= nil) then
        LoadPersonnalData(source, result[1])
        cb(true, ARP.PlayerData[source])
    else
        LoadDefaultData(source)
        cb(false, ARP.PlayerData[source])
    end
    return
end)

-- Register player

local function AddPlayerToDb(source, data)
    MySQL.Sync.execute('INSERT INTO users                                       \
    (steamid, license, firstname, lastname, birthdate, gender, height, position) VALUES   \
    (@steamid, @license, @firstname, @lastname, @birthdate, @gender, @height, @position)',
	{
		['@steamid']    = GetSteamIdById(source),
		['@license']    = GetLicenseById(source),
        ['@firstname']  = data.firstName,
        ['@lastname']   = data.lastName,
        ['@birthdate']  = data.birthdate,
        ['@gender']     = data.gender,
        ['@height']     = data.height,
        ['@position']   = data.position
	})
end

function Capitalize(str)
    return (str:gsub("^%l", string.upper))
end

function RegisterPlayer(playerData)
    local _source   = source
    local newPlayer = {}

    -- birth date format
    if (string.len(playerData.day) == 1) then
        playerData.day = "0" .. tostring(playerData.day)
    end
    if (string.len(playerData.month) == 1) then
        playerData.month = "0" .. tostring(playerData.month)
    end
    newPlayer.birthdate = tostring(playerData.day .. '/' .. playerData.month .. '/' .. playerData.year)
    -- Name format
    newPlayer.firstName   = Capitalize(string.lower(playerData.firstname))
    newPlayer.lastName    = Capitalize(string.lower(playerData.lastname))
    -- Gender format
    if (playerData.gender == "Masculin") then
        newPlayer.gender = 'M'
    else
        newPlayer.gender = 'F'
    end
    newPlayer.height = playerData.height
    newPlayer.position = json.encode({x = 0, y = 0, z = 0})
    AddPlayerToDb(_source, newPlayer)
    LoadPersonnalData(_source, newPlayer)
    TriggerClientEvent('arp_framework:RefreshPlayerData', _source, ARP.PlayerData[_source])
end

RegisterNetEvent('arp_framework:RegisterPlayer')
AddEventHandler('arp_framework:RegisterPlayer', RegisterPlayer)