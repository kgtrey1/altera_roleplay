ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

local function AddPlayerToDb(source, data)
    MySQL.Sync.execute('INSERT INTO users                                       \
    (steamid, license, firstname, lastname, birthdate, gender, height, position) VALUES   \
    (@steamid, @license, @firstname, @lastname, @birthdate, @gender, @height, @position)',
	{
		['@steamid']    = ARP.GetSteamIdById(source),
		['@license']    = ARP.GetLicenseById(source),
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
    local Alter     = ARP.GetPlayerById(_source)
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

    -- Updating the player data
    Alter.identity.SetFirstname(newPlayer.firstName)
    Alter.identity.SetLastname(newPlayer.lastName)
    Alter.identity.SetBirthdate(newPlayer.birthdate)
    Alter.identity.SetGender(newPlayer.gender)
    Alter.identity.SetHeight(newPlayer.height)
    Alter.identity.SetSkin("")
    Alter.SetRegistrationStatus(true)

    -- Telling the client that the player is loaded.
    TriggerClientEvent('arp_framework:PlayerLoaded', _source, ARP.BuildClientObject(_source))
end

RegisterNetEvent('arp_register:RegisterPlayer')
AddEventHandler('arp_register:RegisterPlayer', RegisterPlayer)