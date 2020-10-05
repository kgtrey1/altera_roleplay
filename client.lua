local open = false

function ShowLicense(data, type)
	open = true
	SendNUIMessage({
		action = "open",
		array  = data,
		type   = type
	})
end

function ListenUserInput()
	while (true) do
		if (open) then
			if ((IsControlJustReleased(0, 322) and open) or (IsControlJustReleased(0, 177) and open) then
				SendNUIMessage({ action = "close" })
				open = false
			end
			Citizen.Wait(0)
		else
			Citizen.Wait(2000)
		end
	end
end

RegisterNetEvent('arp_idcard:ShowLicense')
AddEventHandler('arp_idcard:ShowLicense', ShowLicense)

Citizen.CreateThread(ListenUserInput)