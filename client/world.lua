ARP.World.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		ARP.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
		local id      = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(id, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end 
		SetVehRadioStation(vehicle, 'OFF')
		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

ARP.World.SpawnLocalObject = function(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		ARP.Streaming.RequestModel(model)

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

ARP.World.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

ARP.World.DrawText3D = function(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)

		AddTextComponentString(text)
		DrawText(x, y)
	end
end

ARP.World.GetClosestVehicle = function()
	local playerCoords = GetEntityCoords(PlayerPedId())
	local closestVehicle = nil
	local closestDistance = 1000000
	local distance = 0
	local vehicleCoords = nil
	local handle, vehicle = FindFirstVehicle()
	local success = false

	repeat
		coords = GetEntityCoords(vehicle)
		distance = GetDistanceBetweenCoords(playerCoords, vehicleCoords)
		if (distance <= closestDistance) then
			closestDistance = distance
			closestVehicle = vehicle
		end
		success, vehicle = FindNextVehicle(handle, vehicle)
	until not success
	EndFindVehicle(handle)
	return (closestVehicle, closestDistance)
end