-- Load player

local function LoadPersonnalIdentity(data)
    return ({
        firstname   = data.firstname,
        lastname    = data.lastname,
        birthdate   = data.birthdate,
        gender      = data.gender,
        height      = data.height
    })
end

local function LoadDefaultIdentity()
    return ({
        firstname   = "undefined",
        lastname    = "undefined",
        birthdate   = "undefined",
        gender      = "undefined",
        height      = "undefined"
    })
end



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

-- Register player

Citizen.CreateThread(function()
    while true do
        if PlayerData[1] ~= nil then
            print(json.encode(PlayerData[1].GetIdentity()))
        end
        Citizen.Wait(5000)
    end
end)