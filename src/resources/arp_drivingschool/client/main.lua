local ARP       = nil

local MainMenu      = 'arp_drivingschool:MainMenu'
local MenuIsOpen    = false

local CurrentTest	= nil

local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint, DriveErrors = 0, 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil

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

-- Drive

function SetCurrentZoneType(type)
	CurrentZoneType = type
end

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function StopDriveTest(success)
	if success then
		TriggerServerEvent('arp_licenses:SetDrivingLicense', GetPlayerServerId(PlayerId()), CurrentTestType, trues)
		ARP.ShowNotification("Vous avez ~g~réussi~s~ l'examen de conduite.")
	else
		ARP.ShowNotification("Vous avez ~r~échoué~s~ l'examen de conduite.")
	end
	CurrentTest     = nil
	CurrentTestType = nil
end

function ManageTest()
	Citizen.CreateThread(function()
		while (CurrentTest ~= nil) do
			Citizen.Wait(0)
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end
				CurrentTest = nil
				ARP.ShowNotification("Vous avez terminé l'examen de conduite.")
				if DriveErrors < Config.MaxErrors then
					StopDriveTest(true)
				else
					StopDriveTest(false)
				end
			else
				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end
					CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)
					LastCheckPoint = CurrentCheckPoint
				end
				local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end
				if distance <= 3.0 then
					Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end
		end
	end)
end

-- Speed / Damage control
function ManageVehicle()
	Citizen.CreateThread(function()
		while (CurrentTest ~= nil) do
			Citizen.Wait(10)
			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then
				local vehicle      = GetVehiclePedIsIn(playerPed, false)
				local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
				local tooMuchSpeed = false

				for k,v in pairs(Config.SpeedLimits) do
					if CurrentZoneType == k and speed > v then
						tooMuchSpeed = true
						if not IsAboveSpeedLimit then
							DriveErrors       = DriveErrors + 1
							IsAboveSpeedLimit = true
							ARP.ShowNotification(string.format("Vous conduisez trop vite. Vitesse limitée à: ~y~%s~s~ km/h!", v))
							ARP.ShowNotification(string.format("Erreur(s): ~r~%s~s~/%s.", DriveErrors, Config.MaxErrors))
						end
					end
				end
				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end
				local health = GetEntityHealth(vehicle)
				if health < LastVehicleHealth then
					DriveErrors = DriveErrors + 1
					ARP.ShowNotification("Vous avez endommagé votre véhicule.")
					ARP.ShowNotification(string.format("Erreur(s): ~r~%s~s~/%s.", DriveErrors, Config.MaxErrors))
					LastVehicleHealth = health
					Citizen.Wait(1500)
				end
			end
		end
	end)
end

function StartDriveTest(type)
	ARP.World.SpawnVehicle(Config.VehicleModels[type], Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Pos.h, function(vehicle)
		CurrentTest       = 'drive'
		CurrentTestType   = type
		CurrentCheckPoint = 0
		LastCheckPoint    = -1
		CurrentZoneType   = 'residence'
		DriveErrors       = 0
		IsAboveSpeedLimit = false
		CurrentVehicle    = vehicle
		LastVehicleHealth = GetEntityHealth(vehicle)

		local playerPed   = PlayerPedId()
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		SetVehicleFuelLevel(vehicle, 100.0)
		DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
		ManageTest()
		ManageVehicle()
	end)
end

-- Code

function StopTheoryTest(success)
	CurrentTest = nil
	SendNUIMessage({
		openQuestion = false
	})
	SetNuiFocus(false)
	if (success) then
		TriggerServerEvent('arp_licenses:SetCodeLicense', GetPlayerServerId(PlayerId()), true)
		ARP.ShowNotification("Vous avez ~g~réussi~s~ l'examen du code.")
	else
		ARP.ShowNotification("Vous avez ~r~échoué~s~ l'examen du code.")
	end
end

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
		openSection = 'question'
	})
	cb()
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb()
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb()
end)

function StartTheoryTest()
	CurrentTest = 'theory'
	SendNUIMessage({
		openQuestion = true
	})
	SetNuiFocus(true, true)
end

function StartTest(type)
	if (type == 'code') then
		StartTheoryTest()
	else
		StartDrivingTest(type)
	end
end

RegisterNetEvent('arp_drivingschool:StartTest')
AddEventHandler('arp_drivingschool:StartTest', StartTest)

-- Driving School Menu Thread

function RenderSchoolMenu(licenses)
	if (not licenses.code) then
		ARP.Menu.Item.Button("Passer l'examen du code", 'Passer le code pour avoir accès aux permis.', {}, true, {
			onSelected = function()
				TriggerServerEvent('arp_drivingschool:Buy', 'code')
				ARP.Menu.CloseAll()
			end
		}, nil)
		ARP.Menu.Item.Button("Passer le permis A", 'Vous devez avoir le code.', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
		ARP.Menu.Item.Button("Passer le permis B", 'Vous devez avoir le code.', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
		ARP.Menu.Item.Button("Passer le permis C", 'Vous devez avoir le code.', {RightBadge = ARP.Menu.BadgeStyle.Lock}, true, {}, nil)
	else
		print('has code')
	end
end

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
		distance = #(playerCoords - Config.Zones.School.Pos)
		if (distance <= 50) then
			if (distance <= 3 and not MenuIsOpen and CurrentTest == nil) then
				ARP.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accèder à l'auto école.")
				if (IsControlJustReleased(1, 38)) then
					ARP.TriggerServerCallback('arp_licenses:GetLicensesData', function(data)
						OpenSchoolMenu(data)
					end)
				end
			elseif (distance > 3) then
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
	print(json.encode(Config))
	local blip = AddBlipForCoord(Config.Zones.School.Pos)

	SetBlipSprite(blip, 438)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 39)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Auto école')
	EndTextCommandSetBlipName(blip)
end