local playerIsLoaded = false

local function UpdatePlayerPosition()
    while (true) do
        TriggerServerEvent('arp_framework:UpdatePlayerPosition', GetEntityCoords(GetPlayerPed(-1)))
        Citizen.Wait(Config.PositionRefreshTimeout)
    end
end

local function TeleportToLatestPosition()
    if (ARP.Player.position.x ~= 0 and ARP.Player.position.y ~= 0 and ARP.Player.position.z ~= 0) then
        SetEntityCoords(GetPlayerPed(-1), ARP.Player.position.x, ARP.Player.position.y, ARP.Player.position.z, false, false, false, true)
    end
end

local function LoadPlayerSkin()
    if (ARP.Player.identity.skin == "") then
        if (ARP.Player.identity.gender == "M") then
            TriggerEvent('skinchanger:loadSkin', {sex = 0})
            TriggerEvent('arp_skin:OpenFaceSelection')
        else
            TriggerEvent('skinchanger:loadSkin', {sex = 1})
            TriggerEvent('arp_skin:OpenFaceSelection')
        end
    else
        TriggerEvent('skinchanger:loadSkin', ARP.Player.identity.skin)
    end
end

-- Once data has been prepared.

local function PlayerLoaded(data)
    playerIsLoaded = true
    ARP.Player.position = data.position
    ARP.Player.identity = data.identity
    TeleportToLatestPosition()
    LoadPlayerSkin()
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