-- Altera Framework - 2020
-- Made by kgtrey1
-- client/class.lua
-- Object that will be shared between scripts.

ARP = {}
ARP.Player 		= {}
ARP.World  		= {}
ARP.Streaming 	= {}
--
-- Menus handling (RageUI)
--

ARP.Menu 				= {}
ARP.Menu.List			= {}
ARP.Menu.Sublist 		= {}
ARP.Menu.Item			= {}

ARP.Menu.Closable = function(name, value)
	ARP.Menu.List[name].Closable = value
end

ARP.Menu.CloseAll = function()
	for _, v in pairs(ARP.Menu.List) do
		RageUI.Visible(v, false)
	end
	for _, v in pairs(ARP.Menu.Sublist) do
		RageUI.Visible(v, false)
	end
	TriggerEvent('arp_framework:CloseAllMenus')
end

ARP.Menu.Item.List = function(Label, Items, StartedAtIndex, Description, Style, Enabled, Actions)
	RageUI.Item.List(Label, Items, StartedAtIndex, Description, Style, Enabled, Actions, nil)
end

ARP.Menu.Item.Button = function(label, description, style, enabled, action, submenu)
	if (submenu ~= nil) then
		RageUI.Item.Button(label, description, style, enabled, action, ARP.Menu.Sublist[submenu])
	else
		RageUI.Item.Button(label, description, style, enabled, action, nil)
	end
	return
end

ARP.Menu.IsVisible = function(name, items, panels, submenu)
	if (submenu == false) then
		RageUI.IsVisible(ARP.Menu.List[name], items, panels)
	else
		RageUI.IsVisible(ARP.Menu.Sublist[name], items, panels)
	end
	return
end

ARP.Menu.Visible = function(name, submenu)
	if (not submenu) then
		RageUI.Visible(ARP.Menu.List[name], not RageUI.Visible(ARP.Menu.List[name]))
	else
		RageUI.Visible(ARP.Menu.Sublist[name], not RageUI.Visible(ARP.Menu.Sublist[name]))
	end
end

ARP.Menu.GetVisibility = function(name, submenu)
	if (submenu) then
		return RageUI.Visible(ARP.Menu.Sublist[name])
	end
	return (RageUI.Visible(ARP.Menu.List[name]))
end

ARP.Menu.RegisterMenu = function(name, title, subtitle)
	ARP.Menu.List[name] = RageUI.CreateMenu(title, subtitle)
end

ARP.Menu.RegisterSubmenu = function(name, parent, title, subtitle)
	if (ARP.Menu.List[parent] ~= nil) then
		ARP.Menu.Sublist[name] = RageUI.CreateSubMenu(ARP.Menu.List[parent], title, subtitle)
	else
		ARP.Menu.Sublist[name] = RageUI.CreateSubMenu(ARP.Menu.Sublist[parent], title, subtitle)
	end
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

ARP.GetPlayerData = function()
	return (ARP.Player)
end