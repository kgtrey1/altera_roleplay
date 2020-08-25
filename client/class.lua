-- Altera Framework - 2020
-- Made by kgtrey1
-- client/class.lua
-- Object that will be shared between scripts.

ARP = {}
ARP.Player = {}

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

ARP.Menu.IsVisible = function(name, items, panels)
	RageUI.IsVisible(ARP.Menu.List[name], items, panels)
end

ARP.Menu.Visible = function(name, submenu)
	if (not submenu) then
		RageUI.Visible(ARP.Menu.List[name], not RageUI.Visible(ARP.Menu.List[name]))
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

-- Player values updates

local function UpdateMoney()
	ARP.TriggerServerCallback('arp_framework:UpdateMoney', function(money)
		ARP.Player.money.cash		= money.cash
		ARP.Player.money.bank		= money.bank
		ARP.Player.money.dirty		= money.dirty
		ARP.Player.money.bankname	= money.bankname
		return
	end)
	return
end

RegisterNetEvent('arp_framework:UpdateMoney')
AddEventHandler('arp_framework:UpdateMoney', UpdateMoney)

local function UpdateSkin()
	ARP.TriggerServerCallback('arp_framework:UpdateSkin', function(skin)
		ARP.Player.identity.skin = skin
		return
	end)
	return
end

RegisterNetEvent('arp_framework:UpdateIdentity')
AddEventHandler('arp_framework:UpdateIdentity', UpdateSkin)

local function UpdateIdentity()
	ARP.TriggerServerCallback('arp_framework:UpdateIdentity', function(newIdentity)
		ARP.Player.identity.firstname 	= newIdentity.firstname
		ARP.Player.identity.lastname	= newIdentity.lastname
		ARP.Player.identity.height		= newIdentity.height
		ARP.Player.identity.birthdate	= newIdentity.birthdate
		ARP.Player.identity.skin		= newIdentity.skin
		return
	end)
	return
end

RegisterNetEvent('arp_framework:UpdateIdentity')
AddEventHandler('arp_framework:UpdateIdentity', UpdateIdentity)

ARP.GetPlayerData = function()
	return (ARP.Player)
end