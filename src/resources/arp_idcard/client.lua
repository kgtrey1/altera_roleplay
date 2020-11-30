local open = false

function ShowLicense(data, type)
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
	Citizen.CreateThread(ListenUserInput)
end

function ListenUserInput()
	while (open) do
		if ((IsControlJustReleased(0, 322) and open) or (IsControlJustReleased(0, 177) and open)) then
			SendNUIMessage({ action = "close" })
			open = false
		end
		Citizen.Wait(0)
	end
end

RegisterNetEvent('arp_licenses:ShowLicense')
AddEventHandler('arp_licenses:ShowLicense', ShowLicense)

function SpawnCityHallNPC()
	local hash = GetHashKey(Config.CityHallNPC.model)

	RequestModel(hash)
	while not HasModelLoaded(hash) do
		Citizen.Wait(0)
	end
	ped = CreatePed(2, hash, Config.CityHallNPC.pos.x, Config.CityHallNPC.pos.y, Config.CityHallNPC.pos.z, Config.CityHallNPC.heading, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end

Citizen.CreateThread(SpawnCityHallNPC)