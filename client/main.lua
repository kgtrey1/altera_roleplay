local playerIsLoaded = false

local function WarpToLastPosition()
    SetEntityCoords(GetPlayerPed(-1), ARP.PlayerData.position.x, ARP.PlayerData.position.y, ARP.PlayerData.position.z, false, false, false, true)
end

local function UpdatePlayerPosition()
    while (true) do
        TriggerServerEvent('arp_framework:UpdatePlayerPosition', GetEntityCoords(GetPlayerPed(-1)))
        Citizen.Wait(5000)
    end
end

function LoadPlayer()
    if (not playerIsLoaded) then
        ARP.TriggerServerCallback('arp:LoadPlayer', function(isRegistered, data)
            if (isRegistered) then
                ARP.PlayerData = data
                WarpToLastPosition()
            else
                ARP.PlayerData = data
                TriggerEvent('arp_register:OpenRegistrationForm')
            end
            playerIsLoaded = true
            Citizen.CreateThread(UpdatePlayerPosition)
        end)
    end
    return
end

AddEventHandler('playerSpawned', LoadPlayer)

-- Data reload

local function RefreshPlayerData(data)
    ARP.PlayerData = data
    print("data refreshed.")
end

RegisterNetEvent('arp_framework:RefreshPlayerData')
AddEventHandler('arp_framework:RefreshPlayerData', RefreshPlayerData)

-- Regular task

