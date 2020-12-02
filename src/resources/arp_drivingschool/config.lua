Config = {}

Config.MaxErrors       = 5
Config.SpeedMultiplier = 3.6

Config.Zones = {
	School = {
		Pos   = vector3(239.471, -1380.960, 32.741),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = 1
	},
	VehicleSpawnPoint = {
		Pos   = {x = 249.409, y = -1407.230, z = 30.4094, h = 317.0},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Type  = -1
	}
}

Config.Prices = {
	code   	= 500,
	car		= 1000,
	bike	= 240,
	truck	= 100
}

Config.VehicleModels = {
	car		= 'blista',
	bike  	= 'sanchez',
	truck 	= 'mule3'
}

Config.SpeedLimits = {
	residence = 50,
	town      = 80,
	freeway   = 120
}

Config.CheckPoints = {
	{
		Pos = {x = 255.139, y = -1400.731, z = 29.537},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText(string.format('Allez vers le prochain checkpoint. Vitesse limitée à: ~y~%s~s~ KM/H!', Config.SpeedLimits['residence']), 5000)
		end
	},
	{
		Pos = {x = 271.874, y = -1370.574, z = 30.932},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Allez vers le prochain checkpoint.", 5000)
		end
	},
	{
		Pos = {x = 234.907, y = -1345.385, z = 29.542},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			Citizen.CreateThread(function()
				DrawMissionText("Marquez un ~r~arrêt~s~ pour laisser traverser les ~y~piétons~s~.", 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(3000)
				FreezeEntityPosition(vehicle, false)
				DrawMissionText("~g~Bien~s~, continuons.", 5000)
			end)
		end
	},
	{
		Pos = {x = 217.821, y = -1410.520, z = 28.292},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')

			Citizen.CreateThread(function()
				DrawMissionText(string.format("Marquez un ~r~arrêt~s~ et regardez à votre ~y~gauche~s~. Vitesse limitée à: ~y~%s~s~ KM/H!"), Config.SpeedLimits['town']), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Citizen.Wait(6000)
				FreezeEntityPosition(vehicle, false)
				DrawMissionText("~g~Bien,~s~ prenez à ~y~droite~s~ et suivez votre file.", 5000)
			end)
		end
	},
	{
		Pos = {x = 178.550, y = -1401.755, z = 27.725},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Soyez bien attentif aux autres usagers.", 5000)
		end
	},
	{
		Pos = {x = 113.160, y = -1365.276, z = 27.725},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Allez vers le prochain checkpoint.", 5000)
		end
	},
	{
		Pos = {x = -73.542, y = -1364.335, z = 27.789},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Marquez un arrêt pour laisser passer les véhicules.", 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			FreezeEntityPosition(vehicle, true)
			Citizen.Wait(6000)
			FreezeEntityPosition(vehicle, false)
		end
	},
	{
		Pos = {x = -355.143, y = -1420.282, z = 27.868},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Allez vers le prochain checkpoint.", 5000)
		end
	},
	{
		Pos = {x = -439.148, y = -1417.100, z = 27.704},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Allez vers le prochain checkpoint.", 5000)
		end
	},
	{
		Pos = {x = -453.790, y = -1444.726, z = 27.665},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('freeway')
			DrawMissionText(string.format("Allez sur l'autoroute! Vitesse limitée à: ~y~%s~s~ KM/H!", Config.SpeedLimits['freeway']), 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
		end
	},
	{
		Pos = {x = -463.237, y = -1592.178, z = 37.519},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Allez vers le prochain checkpoint.", 5000)
		end
	},
	{
		Pos = {x = -900.647, y = -1986.28, z = 26.109},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Allez vers le prochain checkpoint.", 5000)
		end
	},
	{
		Pos = {x = 1225.759, y = -1948.792, z = 38.718},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Allez vers le prochain checkpoint.", 5000)
		end
	},
	{
		Pos = {x = 1225.759, y = -1948.792, z = 38.718},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			setCurrentZoneType('town')
			DrawMissionText(string.format('Vous arrivez en ville, attention à votre vitesse. Vitesse limitée à: ~y~%s~s~ KM/H!', Config.SpeedLimits['town']), 5000)
		end
	},
	{
		Pos = {x = 1163.603, y = -1841.771, z = 35.679},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			DrawMissionText("Vous avez presque terminé, restez vigilant.", 5000)
			PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
		end
	},
	{
		Pos = {x = 235.283, y = -1398.329, z = 28.921},
		Action = function(playerPed, vehicle, setCurrentZoneType)
			ARP.Game.DeleteVehicle(vehicle)
		end
	}
}