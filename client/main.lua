--
-- ALTERA PROJECT, 2020
-- arp_vehiclemanager
-- File description:
-- Main client script.
--

ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

AddEventHandler('arp_framework:PlayerReady', function(data)
    ARP.Player = data
    Citizen.CreateThread(ListenUserInput)
end)

function ListenUserInput()
    while (true) do
        Citizen.Wait(0)
        if (IsControlJustPressed(1, 303)) then 
            if (IsPedInAnyVehicle(PlayerPedId(), true)) then
                manageKeyPicking()
            else
                changeVehicleState()
            end
            Citizen.Wait(3000)
        end
    end
end