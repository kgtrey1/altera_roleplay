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
    ARP.Streaming.RequestAnimDict(Config.Dict)
    Citizen.CreateThread(ListenUserInput)
end)

function ChangeVehicleState()
    local vehicle, distance = ARP.World.GetClosestVehicle()
    local plate = GetVehicleNumberPlateText(vehicle)
    local state = GetVehicleDoorLockStatus(vehicle)

    if (vehicle == nil or distance > Config.MaxDistance or not IsPlateValid()) then
        ARP.ShowNotification("~r~Aucun véhicule à proximité~s~")
        return
    end
    ARP.TriggerServerCallback('arp_vehiclemanager:DoesPlayerHaveKey', function(resp)
        if (resp == false) then
            ARP.ShowNotification("Vous n'avez pas les ~r~clés~s~ de ce véhicule.")
            return
        elseif (state == 1) then
            ARP.ShowNotification("Vous avez ~r~fermé~s~ le vehicule.")
            TaskPlayAnim(PlayerPedId(), Config.Dict, Config.Anim, 8.0, 8.0, -1, 48, 1, false, false, false)
            SetVehicleDoorsLocked(vehicle, 2)
            PlayVehicleDoorCloseSound(vehicle, 1)
        else
            ARP.ShowNotification("Vous avez ~g~ouvert~s~ le véhicule")
            TaskPlayAnim(PlayerPedId(), Config.Dict, Config.Anim, 8.0, 8.0, -1, 48, 1, false, false, false)
            SetVehicleDoorsLocked(vehicle, 1)
			PlayVehicleDoorOpenSound(vehicle, 3)
        end
    end, plate)
end

function IsPlateValid(plate)
    return (true)
end

function PickupAndDropKeys()
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))

    if (IsPlateValid(plate) == true) then
        TriggerServerEvent('arp_vehiclemanager:PickupKeys', plate)
    else
        ARP.ShowNotification("~r~Il n'y a pas de clés dans ce véhicule~s~")
    end
    return
end

function ListenUserInput()
    while (true) do
        if (IsControlJustPressed(1, 303)) then 
            if (IsPedInAnyVehicle(PlayerPedId(), true)) then
                PickupAndDropKeys()
            else
                ChangeVehicleState()
            end
            Citizen.Wait(3000)
        end
        Citizen.Wait(0)
    end
end