-- Blips and threading management

local Enterprises = {}

AddEventHandler('arp_enterprise:RegisterEnterpriseStatus', function(ent)
    Enterprises[ent.name] = ent
    ARP.TriggerServerCallback('arp_enterprise:GetEnterpriseSaleStatus', function(status)
        if (status == true) then
            Enterprises[ent.name].forSale = true
            SetSaleBlip(ent.name)
            CreateSaleThread(ent.name)
        else
            Enterprises[ent.name].forSale = false
            SetActiveBlip(ent.name)
        end
    end, ent.name)
end)

RegisterNetEvent('arp_enterprise:SetEnterpriseStatus')
AddEventHandler('arp_enterprise:SetEnterpriseStatus', function(ent_name, status)
    Enterprises[ent_name].forSale = status
    RemoveBlip(Enterprises[ent_name].blip)
    if (forSale) then
        SetSaleBlip(ent_name)
        CreateSaleThread(ent_name)
    else
        SetActiveBlip(ent_name)
    end
end)

function SetSaleBlip(ent_name)
    Enterprises[ent_name].blip = AddBlipForCoord(Enterprises[ent_name].config.sale.pos)
    SetBlipSprite(Enterprises[ent_name].blip, Enterprises[ent_name].config.sale.sprite)
    SetBlipScale(Enterprises[ent_name].blip, 1.0)
    SetBlipAsShortRange(Enterprises[ent_name].blip, true)
    SetBlipColour(Enterprises[ent_name].blip, Enterprises[ent_name].config.sale.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Enterprises[ent_name].config.sale.text)
    EndTextCommandSetBlipName(Enterprises[ent_name].blip)
end

function SetActiveBlip(ent_name)
    Enterprises[ent_name].blip = AddBlipForCoord(Enterprises[ent_name].config.main.pos)
    SetBlipSprite(Enterprises[ent_name].blip, Enterprises[ent_name].config.main.sprite)
    SetBlipScale(Enterprises[ent_name].blip, 1.0)
    SetBlipAsShortRange(Enterprises[ent_name].blip, true)
    SetBlipColour(Enterprises[ent_name].blip, Enterprises[ent_name].config.main.color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Enterprises[ent_name].config.main.text)
    EndTextCommandSetBlipName(Enterprises[ent_name].blip)
end

function CreateSaleThread(ent_name)
    Citizen.CreateThread(function()
        local distance = nil
        local playerCoords = nil
        while (Enterprises[ent_name].forSale) do
            playerCoords = GetEntityCoords(PlayerPedId())
		    distance = #(playerCoords - Enterprises[ent_name].config.sale.pos)
            if (distance <= 50) then
                if (distance < 5) then
				    ARP.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour acheter cette entreprise.")
				    if (IsControlJustReleased(1, 38)) then
                        TriggerServerEvent('arp_enterprise:BuyEnterprise', ent_name)
                    end
                end
                DrawMarker(1, Enterprises[ent_name].config.sale.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 204, 204, 0, 100, false, true, 2, false, nil, nil, false)
                Citizen.Wait(0)
            else
                Citizen.Wait(5000)
            end
        end
    end)
end