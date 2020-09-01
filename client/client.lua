ARP = nil

TriggerEvent('arp_framework:FetchObject', function(Object)
	ARP = Object
end)

AddEventHandler('arp_hud:UpdatePlayerMoney', function(id, value)
	SendNUIMessage({ action = 'SetMoney', id = id, value = value})
end)

function SetJob()
	local job = ARP.Player.GetJob()

	if (job.whitelisted == false) then
		SendNUIMessage({ action = 'SetText', id = 'job', value = job.label })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'enterprise' })
	else
		ARP.TriggerServerCallback('arp_enterprise:GetEnterpriseData', function(ent)
			SendNUIMessage({ action = 'SetText', id = 'job', value = string.format("%s:%s - %s", job.label, ent.label, job.data.label) })
			SendNUIMessage({ action = 'element', task = 'enable', value = 'enterprise' })
			SendNUIMessage({ action = 'SetMoney', id = 'enterprise', value = ent.money})
		end, job.enterprise)
	end
end

function SetMoney()
	local cash  = ARP.Player.money.GetCash()
	local bank  = ARP.Player.money.GetBank()
	local dirty = ARP.Player.money.GetDirty()

	SendNUIMessage({ action = 'SetMoney', id = 'cash', value = cash})
	SendNUIMessage({ action = 'SetMoney', id = 'bank', value = bank})
	SendNUIMessage({ action = 'SetMoney', id = 'dirty', value = dirty})
end

AddEventHandler('arp_framework:PlayerReady', function(Object)
	ARP.Player = Object

	SendNUIMessage({ action = 'ui', config = Config.ui })
	SendNUIMessage({ action = 'setFont', url = Config.font.url, name = Config.font.name })
	SendNUIMessage({ action = 'setLogo', value = Config.serverLogo })
	SetMoney()
	SetJob()
end)