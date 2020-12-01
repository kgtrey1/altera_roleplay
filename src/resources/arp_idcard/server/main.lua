local ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
	ARP = obj
end)

local function GetFirearmsInfos(Alter)
	local firearmsLicense = Alter.licenses.GetFirearmsLicense()

	if (firearmsLicense) then
		local userData = Alter.GetIdentity()

		return {
			firstname	= userData.firstname,
			lastname 	= userData.lastname,
			dateofbirth = userData.birthdate,
			gender 		= userData.gender,
			height 		= userData.height,
			firearms	= true
		}, true
	end
	return nil, false
end

local function GetDrivingInfos(Alter)
	local drivingLicense = Alter.licenses.GetDrivingLicense()

	if (drivingLicense.car or drivingLicense.bike or drivingLicense.truck) then
		local userData = Alter.GetIdentity()

		return {
			firstname	= userData.firstname,
			lastname 	= userData.lastname,
			dateofbirth = userData.birthdate,
			gender 		= userData.gender,
			height 		= userData.height,
			car			= drivingLicense.car,
			truck		= drivingLicense.truck,
			bike		= drivingLicense.bike
		}, true
	end
	return nil, false
end

local function GetIdentityInfos(Alter)
	if (Alter.licenses.GetIdCard()) then
		local userData = Alter.GetIdentity()

		return {
			firstname	= userData.firstname,
			lastname 	= userData.lastname,
			dateofbirth = userData.birthdate,
			gender 		= userData.gender,
			height 		= userData.height
		}, true
	end
	return nil, false
end

function ShowLicense(target, type)
	local _source 	= source
	local Altera	= ARP.GetPlayerById(_source)
	local Alterb	= ARP.GetPlayerById(target)
	local show		= false
	local data		= nil

	if (type == "id" or type == "driving" or type == "firearms") then
		if (type == 'id') then
			data, show = GetIdentityInfos(Altera)
		elseif (type == 'driving') then
			data, show = GetDrivingInfos(Altera)
		else
			data, show = GetFirearmsInfos(Altera)
		end
		if (show) then
			Alterb.TriggerEvent('arp_licenses:ShowLicense', data, type)
		else
			Altera.ShowNotification("Vous ne possedez pas ce type de licence.")
		end
	else
		print("Illegal call")
	end
	return
end

RegisterServerEvent('arp_licenses:ShowLicense')
AddEventHandler('arp_licenses:ShowLicense', ShowLicense)

function SetFirearmsLicense(target, value)
	local _source = source
	local Altera = ARP.GetPlayerById(target)
	local Alterb = ARP.GetPlayerById(_source)

	if (type(value) == 'boolean' and Altera ~= nil) then
		Altera.licenses.SetFirearmsLicense(value)
	else
		string.format('ARP> Trying to set firearms licence with value ' .. value .. '(Called by SteamID %s on SteamId %s).', Alterb.GetSteamid(), Altera.GetSteamid())
	end
end

RegisterNetEvent('arp_licenses:SetFirearmsLicense')
AddEventHandler('arp_licenses:SetFirearmsLicense', SetFirearmsLicense)

function SetIdLicense(target, value)
	local _source = source
	local Altera = ARP.GetPlayerById(target)
	local Alterb = ARP.GetPlayerById(_source)

	if (type(value) == 'boolean' and Altera ~= nil) then
		Altera.licenses.SetIdCard(value)
	else
		string.format('ARP> Trying to set ID licence with value ' .. value .. ' (Called by SteamID %s on SteamId %s).', Alterb.GetSteamid(), Altera.GetSteamid())
	end
end

RegisterNetEvent('arp_licenses:SetIdLicense')
AddEventHandler('arp_licenses:SetIdLicense', SetIdLicense)

function SetDrivingLicense(target, type, value)
	local _source = source
	local Altera = ARP.GetPlayerById(target)
	local Alterb = ARP.GetPlayerById(_source)

	if (type == 'car' or type == 'truck' or type == 'bike' and type(value) == 'boolean' and Altera ~= nil) then
		Altera.licenses.SetDrivingLicense(type, value)
	else
		string.format('ARP> Trying to set driving licences for %s with value ' .. value .. ' (Called by SteamID %s on SteamId %s).', type, Alterb.GetSteamid(), Altera.GetSteamid())
	end
end

RegisterNetEvent('arp_licenses:SetDrivingLicense')
AddEventHandler('arp_licenses:SetDrivingLicense', SetDrivingLicense)

ARP.RegisterServerCallback('arp_licenses:GetLicensesData', function(_source, cb)
	local Alter = ARP.GetPlayerById(_source)
	local obj 	= {}

	obj.hasdriving			= Alter.licenses.GetDrivingOwnership()
	obj.hasdriving	 		= Alter.licenses.GetIdCardOwnership()
	obj.hasfirearms			= Alter.licenses.GetFirearmsOwnership()
	obj.driving				= Alter.licenses.GetDrivingLicense()
	obj.idcard				= Alter.licenses.GetIdCard()
	obj.firearms			= Alter.licenses.GetFirearmsLicense()
	cb(obj)
end)

function RegisterAsCitizen()
	local _source = source
	local Alter = ARP.GetPlayerById(_source)

	if (Alter == nil) then
		return
	elseif (Alter.money.GetCash() >= Config.price.CitizenRegistration) then
		Alter.money.RemoveCash(Config.price.CitizenRegistration)
		Alter.licenses.SetIdCard(true)
		Alter.licenses.SetIdCardOwnership(true)
		Alter.ShowNotification("Vous êtes officiellement citoyen.")
	else
		Alter.ShowNotification("Vous n'avez pas assez d'argent.")
	end
	return
end

RegisterNetEvent('arp_idcard:RegisterAsCitizen')
AddEventHandler('arp_idcard:RegisterAsCitizen', RegisterAsCitizen)