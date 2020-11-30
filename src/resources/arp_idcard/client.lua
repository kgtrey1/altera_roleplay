local open = false
local NPCMenuIsOpen = false
local ARP = nil

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

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

function HandleNPC()
	local playerCoords = nil
	local distance = nil
	local playerPed = PlayerPedId()

	while (true) do
		playerCoords = GetEntityCoords(playerPed)
		distance = GetDistanceBetweenCoords(playerCoords, Config.CityHallNPC.pos)
		if (distance <= 10 and not NPCMenuIsOpen) then
			ARP.ShowNotification("Appuyez sur ~INPUT_CONTEXT~ pour faire vos papiers.")
			if (IsControlJustReleased(IsControlJustPressed(1, 38)) then
				ARP.TriggerServerCallback('arp_licenses:GetLicensesData', function(data)
					
				end)
			end
			Citizen.Wait(0)
		else
			NPCMenuIsOpen = false
			if (distance < 50 and distance > 10) then
				Citizen.Wait(1000)
			else
				Citizen.Wait(5000)
			end
		end
	end
end

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