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

function IsPlateValid(plate)
    return (true)
end

function PickupAndDropKeys()
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), true))

    if (IsPlateValid(plate) == true) then
        TriggerServerEvent('arp_vehiclelock:PickupKeys', plate)
    else
        ARP.ShowNotification(_U('keys_taken'))
    end
    return
end

function ListenUserInput()
    while (true) do
        if (IsControlJustPressed(1, 303)) then 
            if (IsPedInAnyVehicle(PlayerPedId(), true)) then
                PickupAndDropKeys()
            else
                changeVehicleState()
            end
            Citizen.Wait(3000)
        end
        Citizen.Wait(0)
    end
end