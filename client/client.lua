--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
ARP				= nil
local inMenu	= true
local showblips	= true
local atbank	= false
local bankMenu	= true

local closeATM 	= false

local DrawDistance = 50

--================================================================================================
--==                                THREADING - DO NOT EDIT                                     ==
--================================================================================================

--===============================================
--==           Base ESX Threading              ==
--===============================================

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

function GetATMCoords(c)
	if (c.type == 'bank') then
		return (vector3(Config.Banks[c.id].x, Config.Banks[c.id].y, Config.Banks[c.id].z))
	end
	return (vector3(Config.atms[c.id].x, Config.atms[c.id].y, Config.atms[c.id].z))
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
			DisplayHelpText("Appuie sur ~INPUT_PICKUP~ pour accèder à tes comptes ~b~")
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

--[[
--===============================================
--==             Core Threading                ==
--===============================================
if bankMenu then
	Citizen.CreateThread(function()
	while true do
		Wait(0)
	if nearBank() or nearATM() then
			DisplayHelpText("Appuie sur ~INPUT_PICKUP~ pour accèder à tes comptes ~b~")
	
		if IsControlJustPressed(1, 38) then
			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			TriggerServerEvent('bank:balance')
			local ped = GetPlayerPed(-1)
		end
	end
				
		if IsControlJustPressed(1, 322) then
		inMenu = false
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
	end
	end)
end


--===============================================
--==             Map Blips	                   ==
--===============================================




--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
	
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
		})
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:deposit', tonumber(data.amount))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdraw', tonumber(data.amountw))
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)


--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:transfer', data.to, data.amountt)
	TriggerServerEvent('bank:balance')
end)

--===============================================
--==         Result   Event                    ==
--===============================================
RegisterNetEvent('bank:result')
AddEventHandler('bank:result', function(type, message)
	SendNUIMessage({type = 'result', m = message, t = type})
end)

--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
	inMenu = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'closeAll'})
end)


--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 3 then
			return true
		end
	end
end

function nearATM()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)
	
	for _, search in pairs(atms) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'], playerloc['z'], true)
		
		if distance <= 3 then
			return true
		end
	end
end




]]