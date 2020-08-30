
ARP				= nil
local inMenu	= true
local showblips	= true
local atbank	= false
local bankMenu	= true

local closeATM 	= false

local DrawDistance = 50


TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
	ARP.Player = playerData
	StartMainThread()
end)

function GetATMCoords(c)
	if (c.type == 'bank') then
		return (vector3(Config.Banks[c.id].x, Config.Banks[c.id].y, Config.Banks[c.id].z))
	end
	return (vector3(Config.atms[c.id].x, Config.atms[c.id].y, Config.atms[c.id].z))
end

function BankMenuListenners()
	if IsControlJustPressed(1, 38) then
		inMenu = true
		SetNuiFocus(true, true)
		SendNUIMessage({type = 'openGeneral', bank = ARP.Player.money.GetBankname()})
		SendBalanceToUI()
	end
	if IsControlJustPressed(1, 322) then
		inMenu = false
		SetNuiFocus(false, false)
		SendNUIMessage({type = 'close'})
	end
end

function handleClosestAtm(closest)
	local ATMCoords 	= GetATMCoords(closest)
	local playerCoords 	= nil
	local distance 		= nil

	while (closeATM == true) do
		playerCoords = GetEntityCoords(PlayerPedId())
		distance = GetDistanceBetweenCoords(playerCoords, ATMCoords)
		if (distance > DrawDistance) then
			closeATM = false
			break
		elseif (distance < 1.9) then
			if (ARP.Player.money.GetBankname() == 'none') then
				DisplayHelpText("Vous n'avez pas de compte bancaire~b~")
			else
				DisplayHelpText("Appuie sur ~INPUT_PICKUP~ pour accèder à tes comptes ~b~")
				BankMenuListenners()
			end
		else
			Citizen.Wait(500)
		end
		Citizen.Wait(10)
	end
	return
end

function GetClosestValidAtm()
	local playerCoords 	= GetEntityCoords(PlayerPedId(-1))
	local closest		= { type = 'bank', id = 1 }
	local closestDist	= GetDistanceBetweenCoords(playerCoords, vector3(Config.Banks[1].x, Config.Banks[1].y, Config.Banks[1].z))
	local currentDist	= nil

	for i = 2, #Config.Banks, 1 do
		currentDist = GetDistanceBetweenCoords(playerCoords, vector3(Config.Banks[i].x, Config.Banks[i].y, Config.Banks[i].z))
		if (currentDist < closestDist) then
			closestDist = currentDist
			closest 	= { type = 'bank', id = i }
		end
	end
	for i = 1, #Config.atms, 1 do
		currentDist = GetDistanceBetweenCoords(playerCoords, vector3(Config.atms[i].x, Config.atms[i].y, Config.atms[i].z))
		if (currentDist < closestDist) then
			closestDist = currentDist
			closest 	= { type = 'atm', id = i }
		end
	end
	if (closestDist <= DrawDistance) then return (closest) end
	return (nil)
end

function StartMainThread()
	Citizen.CreateThread(function()
		local playerCoords 		= nil
		local closestValidATM	= nil
	
		while (true) do
	
			closestValidATM = GetClosestValidAtm()
			if (closestValidATM ~= nil and not closeATM) then
				closeATM = true
				handleClosestAtm(closestValidATM)
			end
			Citizen.Wait(5000)
		end
	end)	
end

Citizen.CreateThread(function()
	for k,v in ipairs(Config.Banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)
		if v.principal ~= nil and v.principal then
			SetBlipColour(blip, 77)
		end
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
	end
	for k,v in ipairs(Config.atms)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 0.7)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function SendBalanceToUI()
	ARP.TriggerServerCallback('arp_bank:Balance', function(money, bankname)
		SendNUIMessage({
			type = "balanceHUD",
			balance = money,
			player = string.format("%s %s", ARP.Player.identity.GetFirstname(), ARP.Player.identity.GetLastname())
		})
		print(money)
		print(bankname)
		return
	end)
	return
end

RegisterNUICallback('deposit', function(data)
	ARP.TriggerServerCallback('arp_bank:Deposit', function(newBalance)
		SendNUIMessage({type = 'BalanceUpdate', balance = newBalance})
		return
	end, tonumber(data.amount))
	return
end)

RegisterNUICallback('withdraw', function(data)
	ARP.TriggerServerCallback('arp_bank:Withdraw', function(newBalance)
		SendNUIMessage({type = 'BalanceUpdate', balance = newBalance})
		return
	end, tonumber(data.amount))
	return
end)

RegisterNUICallback('transfer', function(data)
	ARP.TriggerServerCallback('arp_bank:Transfer', function(newBalance)
		SendNUIMessage({type = 'BalanceUpdate', balance = newBalance})
		return
	end, tonumber(data.amount), tostring(data.to))
	return
end)

RegisterNetEvent('arp_bank:Result')
AddEventHandler('arp_bank:Result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
	return
end)

RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
	return
end)