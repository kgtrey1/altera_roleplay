local playerIsLoaded = false

local function UpdatePlayerPosition()
    while (true) do
        TriggerServerEvent('arp_framework:UpdatePlayerPosition', GetEntityCoords(GetPlayerPed(-1)))
        Citizen.Wait(Config.PositionRefreshTimeout)
    end
end

local function TeleportToLatestPosition(position)
    if (position.x ~= 0 and position.y ~= 0 and position.z ~= 0) then
        SetEntityCoords(GetPlayerPed(-1), position.x, position.y, position.z, false, false, false, true)
    end
end

local function LoadPlayerSkin()
    if (ARP.Player.identity.GetSkin() == "") then
        if (ARP.Player.identity.GetGender() == "M") then
            TriggerEvent('skinchanger:loadSkin', {sex = 0})
            TriggerEvent('arp_skin:OpenFaceSelection')
        else
            TriggerEvent('skinchanger:loadSkin', {sex = 1})
            TriggerEvent('arp_skin:OpenFaceSelection')
        end
    else
        TriggerEvent('skinchanger:loadSkin', ARP.Player.identity.GetSkin())
    end
end

-- Once data has been prepared.

local function PlayerLoaded(data)
    ARP.Player = CreatePlayerObject(data)

    TeleportToLatestPosition(data.position)
    LoadPlayerSkin()
    Citizen.CreateThread(UpdatePlayerPosition)
    playerIsLoaded = true
    TriggerEvent('arp_framework:PlayerReady', ARP.Player)
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


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
    end
end)