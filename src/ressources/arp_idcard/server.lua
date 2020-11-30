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
			dateofbirth = userData.dateOfBirth,
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

function SetFirearmsLicense(value)
	local _source = source
	local Alter = ARP.GetPlayerById(_source)

	if (value == true or value == false) then
		Alter.licenses.SetFirearmsLicense(value)
	else
		print('Illegal call')
	end
end

RegisterNetEvent('arp_licenses:SetFirearmsLicense')
AddEventHandler('arp_licenses:SetFirearmsLicense', SetFirearmsLicense)

function SetIdLicense(value)
	local _source = source
	local Alter = ARP.GetPlayerById(_source)

	if (value == true or value == false) then
		Alter.licenses.SetIdCard(value)
	else
		print('Illegal call')
	end
end

RegisterNetEvent('arp_licenses:SetIdLicense')
AddEventHandler('arp_licenses:SetIdLicense', SetIdLicense)

function SetDrivingLicense(type, value)
	local _source = source
	local Alter = ARP.GetPlayerById(_source)

	if (type == 'car' or type == 'truck' or type == 'bike' and value == true or value == false) then
		Alter.licenses.SetDrivingLicense(type, value)
	else
		print('Illegal call')
	end
end

RegisterNetEvent('arp_licenses:SetDrivingLicense')
AddEventHandler('arp_licenses:SetDrivingLicense', SetDrivingLicense)