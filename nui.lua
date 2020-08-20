local display = false
ARP = nil

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

AddEventHandler('arp_register:OpenRegistrationForm', function()
    SetDisplay(not display)
end)

RegisterNUICallback('main', function(data)
    Submit(data)
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

function Submit(string)
    TriggerServerEvent('arp_framework:RegisterPlayer', string)
end