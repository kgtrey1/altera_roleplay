local open = false
local NPCMenuIsOpen = false
local ARP = nil

local MainMenu 		= 'arp_licenses:MainMenu'
local LicenseMenu 	= 'arp_licenses:LicensesMenu'

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
	ARP.Player = playerData
	ARP.Menu.RegisterMenu(MainMenu, "Mairie", "MENU D'ADMINISTRATION")
	Citizen.CreateThread(CreateCityHallBlip)
	Citizen.CreateThread(SpawnCityHallNPC)
	Citizen.CreateThread(HandleNPC)
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

function RenderMainMenu(data)
	if (not data.idcard) then -- if player have to make his ID Card
		ARP.Menu.Item.Button("M'enregistrer comme citoyen", '', {}, true, {
			onSelected = function()
				TriggerServerEvent('arp_idcard:RegisterAsCitizen')
				ARP.Menu.CloseAll()
			end
		}, nil)
	else
		ARP.Menu.Item.Button("M'enregistrer comme citoyen", 'Vous êtes déjà recensé.', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
	end
end

function OpenNPCMenu(data)
	if (NPCMenuIsOpen) then
		return
	end
	ARP.Menu.CloseAll()
	ARP.Menu.Visible(MainMenu, false)
	NPCMenuIsOpen = true
	while (NPCMenuIsOpen) do
		ARP.Menu.IsVisible(MainMenu, function()
			RenderMainMenu(data)
		end, function() end, false)
		if (not ARP.Menu.GetVisibility(MainMenu, false)) then
			NPCMenuIsOpen = false
		end
		Citizen.Wait(0)
	end
	NPCMenuIsOpen = false
end

function HandleNPC()
	local playerCoords = nil
	local distance = nil

	while (true) do
		playerCoords = GetEntityCoords(PlayerPedId())
		distance = #(playerCoords - Config.CityHallNPC.pos)
		if (distance <= 10) then
			if (not NPCMenuIsOpen) then
				ARP.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au menu de la mairie.")
				if (IsControlJustReleased(1, 38)) then
					ARP.TriggerServerCallback('arp_licenses:GetLicensesData', function(data)
						OpenNPCMenu(data)
					end)
				end
			end
			Citizen.Wait(0)
		else
			NPCMenuIsOpen = false
			if (distance < 50) then
				Citizen.Wait(1000)
			else
				Citizen.Wait(5000)
			end
		end
	end
end

function CreateCityHallBlip()
	local blip = AddBlipForCoord(Config.CityHallNPC.pos.x, Config.CityHallNPC.pos.y, Config.CityHallNPC.pos.z)
	
	SetBlipSprite(blip, 438)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 39)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Mairie')
	EndTextCommandSetBlipName(blip)
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