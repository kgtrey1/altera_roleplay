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
    Citizen.Wait(5000)
    HandleDrops()

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

function GetCloseDrops(playerCoords)
    local closeObject  = {}
    local isEmpty      = true

    for i = 1, #Drops, 1 do
        if (Drops[i].name ~= nil and GetDistanceBetweenCoords(playerCoords, Drops[i].coords) < 10) then
            closeObject[i] = Drops[i]
            if (isEmpty) then
                isEmpty = false
            end
        end
    end
    if (isEmpty) then
        return (nil)
    end
    return (closeObject)
end

function HandleDrops()
    Citizen.CreateThread(function()
        local drops = {}
        local playerCoords = nil
        local distance     = nil
        local playerPed    = nil

        while (true) do
            Citizen.Wait(0)

            playerPed    = GetPlayerPed(-1)
            playerCoords = GetEntityCoords(playerPed)
            drops        = GetCloseDrops(playerCoords)
            if (drops == nil) then
                Citizen.Wait(3000)
                print('not')
            else
                for k, v in pairs(drops) do
                    distance = GetDistanceBetweenCoords(playerCoords, v.coords)
                    if distance <= 5 then
                        ARP.World.DrawText3D({
                            x = v.coords.x,
                            y = v.coords.y,
                            z = v.coords.z + 0.25
                        }, string.format('%s x%d', v.label, v.amount))
                    end
                    if (distance <= 1.0 and IsPedOnFoot(playerPed)) then
                        TriggerServerEvent('arp_framework:OnItemPickup', tonumber(k))
                    end
                end
            end
        end
    end)
end