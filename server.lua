local ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
	ARP = obj
end)

local function GetFirearmsInfos(Alter)
	local firearmsLicense = Alter.licenses.GetFirearmsLicense()

	if (firearmsLicense) then
		local userData = Alter.GetIdentity()

		return ({
			firstname	= userData.firstName,
			lastname 	= userData.lastName,
			dateOfBirth = userData.dateOfBirth,
			gender 		= userData.gender,
			height 		= userData.height,
			firearms	= true
		}, true)
	end
	return (nil, false)
end

local function GetDrivingInfos(Alter)
	local drivingLicense = Alter.licenses.GetDrivingLicense()

	if (drivingLicense.car or drivingLicense.bike or drivingLicense.truck) then
		local userData = Alter.GetIdentity()

		return ({
			firstname	= userData.firstName,
			lastname 	= userData.lastName,
			dateOfBirth = userData.dateOfBirth,
			gender 		= userData.gender,
			height 		= userData.height,
			car			= drivingLicense.car,
			truck		= drivingLicense.truck,
			bike		= drivingLicense.bike
		}, true)
	end
	return (nil, false)
end

local function GetIdentityInfos(Alter)
	if (Alter.licenses.GetIdCard()) then
		local userData = Alter.GetIdentity()

		return ({
			firstname	= userData.firstName,
			lastname 	= userData.lastName,
			dateOfBirth = userData.dateOfBirth,
			gender 		= userData.gender,
			height 		= userData.height
		}, true)
	end
	return (nil, false)
end

function ShowLicense(target, type)
	local _source 	= source
	local Altera	= ARP.GetPlayerById(_source)
	local Alterb	= ARP.GetPlayerById(target)
	local show		= false
	local data		= nil

	if (type == "id" or type == "driving" or type == "firearms") then
		if (type == 'id') then
			data, show = GetIdentityInfos(Alterb)
		elseif (type == 'driving') then
			data, show = GetDrivingInfos(Alterb)
		else
			data, show = GetFirearmsInfos(Alterb)
		end
		if (show) then
			Altera.TriggerEvent('arp_idcard:ShowLicense', data, type)
		else
			Altera.ShowNotification("Cette personne ne possède pas ce type de license.")
		end
	else
		print("Illegal call")
	end
	return
end

RegisterServerEvent('arp_idcard:RequestLicense')
AddEventHandler('arp_idcard:RequestLicense', RequestLicense)

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
			Alterb.TriggerEvent('arp_idcard:ShowLicense', data, type)
		else
			Altera.ShowNotification("Vous ne possedez pas ce type de licence.")
		end
	else
		print("Illegal call")
	end
	return
end

RegisterServerEvent('arp_idcard:ShowLicense')
AddEventHandler('arp_idcard:ShowLicense', ShowLicense)