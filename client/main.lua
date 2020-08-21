local playerIsLoaded = false

local function UpdatePlayerPosition()
    while (true) do
        TriggerServerEvent('arp_framework:UpdatePlayerPosition', GetEntityCoords(GetPlayerPed(-1)))
        Citizen.Wait(Config.PositionRefreshTimeout)
    end
end

local function TeleportToLatestPosition()
    if (ARP.PlayerData.position.x ~= 0 and ARP.PlayerData.position.y ~= 0 and ARP.PlayerData.position.z ~= 0) then
        SetEntityCoords(GetPlayerPed(-1), ARP.PlayerData.position.x, ARP.PlayerData.position.y, ARP.PlayerData.position.z, false, false, false, true)
    end
end

-- Once data has been prepared.

local function PlayerLoaded(data)
    playerIsLoaded = true
    ARP.PlayerData = data
    TeleportToLatestPosition()
    Citizen.CreateThread(UpdatePlayerPosition)
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