ARP = {}

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

local display = false

RegisterNetEvent('arp_register:OpenRegistrationForm')
AddEventHandler('arp_register:OpenRegistrationForm', function()
    SetDisplay(not display)
end)

RegisterNUICallback('main', function(data)
    TriggerServerEvent('arp_register:RegisterPlayer', data)
    SetDisplay(not display)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
    return
end