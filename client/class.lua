-- Altera Framework - 2020
-- Made by kgtrey1
-- client/class.lua
-- Object that will be shared between scripts.

ARP = {}
ARP.PlayerData = {}

ARP.RageUI = RageUI

--
-- Menus handling (RageUI)
--

ARP.Menu 				= {}
ARP.Menu.List			= {}
ARP.Menu.Sublist 		= {}

ARP.Menu.CloseAll = function()
	for _, v in pairs(ARP.Menu.List) do
		RageUI.Visible(v, false)
	end
end

ARP.Menu.Button = function(label, description, style, enabled, action, submenu)
	if (submenu ~= nil) then
		RageUI.Item.Button(label, description, style, enabled, action, ARP.Menu.Sublist[submenu])
	else
		RageUI.Item.Button(label, description, style, enabled, action, nil)
	end
	return
end

ARP.Menu.IsVisible = function(name, items, panels)
	RageUI.IsVisible(ARP.Menu.List[name], items, panels)
end

ARP.Menu.Visible = function(name, submenu)
	if (not submenu) then
		RageUI.Visible(ARP.Menu.List[name], not RageUI.Visible(ARP.Menu.List[name]))
		print("changing visibility")
	else
		RageUI.Visible(ARP.Menu.Sublist[name], not RageUI.Visible(ARP.Menu.Sublist[name]))
	end
end

ARP.Menu.RegisterMenu = function(name, title, subtitle)
	ARP.Menu.List[name] = RageUI.CreateMenu(title, subtitle)
end

ARP.Menu.RegisterSubmenu = function(name, parent, title, subtitle)
	ARP.Menu.Sublist[name] = RageUI.CreateSubmenu(ARP.Menu.List[parent], title, subtitle)
end

--
-- Callbacks (client side implementation).
--

ARP.ServerCallbacks     = {}
ARP.CurrentRequestId    = 0

ARP.TriggerServerCallback = function(callbackName, functionPointer, ...)
	ARP.ServerCallbacks[ARP.CurrentRequestId] = functionPointer
	TriggerServerEvent('arp:TriggerServerCallback', callbackName, ARP.CurrentRequestId, ...)
	if (ARP.CurrentRequestId < 65535) then
		ARP.CurrentRequestId = ARP.CurrentRequestId + 1
	else
		ARP.CurrentRequestId = 0
	end
end

RegisterNetEvent('arp:ServerCallback')
AddEventHandler('arp:ServerCallback', function(requestId, ...)
	ARP.ServerCallbacks[requestId](...)
	ARP.ServerCallbacks[requestId] = nil
end)