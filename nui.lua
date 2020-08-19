local display = false

AddEventHandler('arp_framework:RegisterPlayer', function()
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
    print(string)
end