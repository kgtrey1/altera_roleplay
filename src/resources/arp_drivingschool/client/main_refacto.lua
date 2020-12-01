local ARP       = nil

local MainMenu      = 'arp_drivingschool:MainMenu'
local MenuIsOpen    = false

-- arp_framework Initialization.

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
	ARP.Player = playerData
	ARP.Menu.RegisterMenu(MainMenu, "Auto Ecole", "MENU AUTO ECOLE")
	Citizen.CreateThread(CreateDrivingSchoolBlip)
	Citizen.CreateThread(HandleDrivingSchoolPoint)
end)

function RenderSchoolMenu(licenses)
	if (not licenses.code) then
		ARP.Menu.Item.Button("Passer l'examen du code", 'Passer le code pour avoir accès aux permis.', {}, true, {
			
		}, nil)
		ARP.Menu.Item.Button("Passer le permis A", 'Vous devez avoir le code.', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
		ARP.Menu.Item.Button("Passer le permis B", 'Vous devez avoir le code.', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
		ARP.Menu.Item.Button("Passer le permis C", 'Vous devez avoir le code.', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
	else
		print('has code')
	end
end

-- Driving School Menu Thread

function OpenSchoolMenu(licenses)
	if (MenuIsOpen) then
		return
	end
	MenuIsOpen = true
	if (not licenses.hasidcard) then
		ARP.ShowNotification("Vous devez avoir votre carte d'identité pour passer le permis.")
		Citizen.Wait(10000)
		MenuIsOpen = false
		return
	end
	ARP.Menu.CloseAll()
	ARP.Menu.Visible(MainMenu, false)
	while (MenuIsOpen) do
		ARP.Menu.IsVisible(MainMenu, function()
			RenderSchoolMenu(licenses)
		end, function() end, false)
		if (not ARP.Menu.GetVisibility(MainMenu, false)) then
			MenuIsOpen = false
		end
		Citizen.Wait(0)
	end
	MenuIsOpen = false
end

-- Driving School point

function HandleDrivingSchoolPoint()
	local playerCoords = nil
	local distance = nil

	while (true) do
		playerCoords = GetEntityCoords(PlayerPedId())
		distance = #(playerCoords - Config.Zones.School.pos)
		if (distance <= 50) then
			if (distance <= 3 and not MenuIsOpen) then
				ARP.ShowHelpNotification(STR.OpenMenu)
				if (IsControlJustReleased(1, 38)) then
					ARP.TriggerServerCallback('arp_licenses:GetLicensesData', function(data)
						OpenSchoolMenu(data)
					end)
				end
			elseif (distance > 3)
				MenuIsOpen = false
			end
			Citizen.Wait(0)
		else
			MenuIsOpen = false
			Citizen.Wait(5000)
		end
	end
end

-- Blip

function CreateDrivingSchoolBlip()
	local blip = AddBlipForCoord(Config.Zones.School.pos.x, Config.Zones.School.pos.y, Config.Zones.School.pos.z)

	SetBlipSprite(blip, 438)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 39)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Auto école')
	EndTextCommandSetBlipName(blip)
end