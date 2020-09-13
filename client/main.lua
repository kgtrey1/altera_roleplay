--
-- ALTERA PROJECT, 2020
-- ARP_Fuel
-- File description:
-- Main client side script.
--

ARP     = nil
Pumps   = {}
PumpsAreLoaded  = false

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
    ARP.Player = playerData
    while (PumpsAreLoaded) do
        Citizen.Wait(1000)
    end
end)

-- Fetching each pump object & coordinates.
Citizen.CreateThread(function()
	local handle, object    = FindFirstObject()
	local success           = false

	repeat
		if Config.PumpModels[GetEntityModel(object)] then
			table.insert(Pumps, {
                obj     = object,
                coords  = GetEntityCoords(fuelPumpObject)
            })
		end
		success, object = FindNextObject(handle, object)
	until not success
    EndFindObject(handle)
    PumpsAreLoaded = true
    return
end)

-- Blips creation
Citizen.CreateThread(function()
    for _, GasStation in pairs(Config.GasStations) do
        local blip = AddBlipForCoord(GasStation)

        SetBlipSprite (blip, Config.Blips.sprite)
		SetBlipScale(blip, Config.Blips.scale)
		SetBlipColour(blip, Config.Blips.color)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 4)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blips.string)
		EndTextCommandSetBlipName(blip)
    end
    return
end)