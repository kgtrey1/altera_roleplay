--
-- ALTERA PROJECT, 2020
-- ARP_Fuel
-- File description:
-- Main client side script.
--

ARP             = nil
Pumps           = {}
PumpsAreLoaded  = false
PumpFueling     = false
JericanFueling  = false
IsCloseToPump   = false

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
    ARP.Player = playerData
    while (PumpsAreLoaded) do
        Citizen.Wait(1000)
    end
end)

-- Pump fueling.
function ManagePumpFueling()
    local vehicle, distance = ARP.World.GetClosestVehicle()
    PumpFueling = true
    while (JCanFueling == false and distance < 5) do


        Citizen.Wait(0)
    end
    PumpFueling = false
end

-- Get the closest pump entity, and distance.
function GetClosestPump(validPumps)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestPump, closestDist = nil
    local currentDist = nil

    for k, v in pairs(validPumps) do
        currentDist = GetDistanceBetweenCoords(v.coords, playerCoords)
        if (closestDist == nil or closestDist > currentDist) then
            closestDist = currentDist
            closestPump = v
        end
    end
    return (closestPump, closestDist)
end

-- Manage valid pumps until player is too far from them.
function ManageValidPumps(validPumps)
    local closestPump = nil
    local distance    = 49

    while (distance <= Config.Distance) do
        closestPump, distance = GetClosestPump(validPumps)
        if (distance < 5) then
            ManagePumpFueling(closestPump, distance)
        else
            Citizen.Wait(500)
        end
    end
    return
end

-- Gets closest pumps.
function GetValidPumps()
    local playerCoords  = GetEntityCoords(PlayerPedId())
    local validPumps    = {}
    local resultIsNil   = true

    for k, v in pairs(Pumps) do
         if (GetDistanceBetweenCoords(v.coords, playerCoords) < Config.Distance) then
            table.insert(validPumps, v)
            resultIsNil = false
         end
    end
    if (resultIsNil) then
        return (nil)
    end
    return (validPumps)
end

-- Proximity management with fuel pumps
Citizen.CreateThread(function()
    local closestValidPump = nil

    while (true) do
        closestValidPump = GetValidPumps()
        if (closestValidPump ~= nil) then
            ManageValidPumps(closestValidPump)
        end
        Citizen.Wait(5000)
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