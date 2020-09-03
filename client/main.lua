--
-- ALTERA PROJECT, 2020
-- ARP_Animations
-- File description:
-- Client side script
--

ARP		 	= nil
MainMenu 	= 'arp_animation:main'
MenuIsOpen 	= false

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
	ARP.Player = playerData
	RegisterAnimationMenus()
	StartThread()
end)

local function ExecuteAnimation(type, data)
	if (type == 'scenario') then
		TaskStartScenarioInPlace(PlayerPedId(), data.anim, 0, false)
	elseif (type == 'attitude') then
		ARP.Streaming.RequestAnimSet(data.lib, function()
			SetPedMovementClipset(PlayerPedId(), data.anim, true)
		end)
	else
		ARP.Streaming.RequestAnimDict(data.lib, function()
			TaskPlayAnim(PlayerPedId(), data.lib, data.anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
		end)
	end
	ARP.Menu.CloseAll()
	return
end

local function VerifyMenuVisibility()
	if (ARP.Menu.GetVisibility(MainMenu, false)) then
		return (true)
	end
	for k, v in pairs(Config.Animations) do
		if (ARP.Menu.GetVisibility(v.menu, true)) then
			return (true)
		end
	end
	return (false)
end

local function DrawSubmenu(List)
	ARP.Menu.IsVisible(List.menu, function()
		for k, v in pairs(List.items) do
			ARP.Menu.Item.Button(v.label, '', {}, true, { onSelected = function()
				ExecuteAnimation(v.type, v.data)
			end}, nil)
		end
	end, function() end, true)
end

local function DrawAnimationMenu()
	MenuIsOpen = true
	ARP.Menu.CloseAll()
	ARP.Menu.Visible(MainMenu, false)
	while (MenuIsOpen) do
		Citizen.Wait(0)
		for k, v in pairs(Config.Animations) do
			DrawSubmenu(v)
		end
		ARP.Menu.IsVisible(MainMenu, function()
			for k, v in pairs(Config.Animations) do
				ARP.Menu.Item.Button(v.label, '', {}, true, {}, v.menu)
			end
		end, function() end, false)
		MenuIsOpen = VerifyMenuVisibility()
	end
end

function StartThread() 
	Citizen.CreateThread(function()
		while (true) do
			Citizen.Wait(0)
			if (IsControlJustPressed(1, 170)) then
				DrawAnimationMenu()
			end
		end
	end)
end

function RegisterAnimationMenus()
	ARP.Menu.RegisterMenu(MainMenu, 'animation', 'MENU ANIMATION')
	for k, v in pairs(Config.Animations) do
		ARP.Menu.RegisterSubmenu(v.menu, MainMenu, v.label, 'SELECTIONNEZ UNE ANIMATION')
	end
end