local playerIsLoaded = false

-- Once data has been prepared.

local function PlayerLoaded(data)
    ARP.PlayerData = data
    print('Player loaded.')
    print(json.encode(ARP.PlayerData))
end

RegisterNetEvent('arp_framework:PlayerLoaded')
AddEventHandler('arp_framework:PlayerLoaded', PlayerLoaded)

-- Triggering data loading on player first spawn.

local function LoadPlayer()
    if (not playerIsLoaded) then
        TriggerServerEvent('arp_framework:LoadPlayer')
    end
    return
end

AddEventHandler('playerSpawned', LoadPlayer)