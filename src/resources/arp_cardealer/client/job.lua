--
-- ALTERA PROJECT, 2020
-- arp_cardealer
-- File description:
-- job client side script
--

local MainMenuIsOpen = false


function OpenMainMenu()
    if (MainMenuIsOpen) then
        return
    end
    ARP.Menu.CloseAll()
    ARP.TriggerServerCallback('arp_cardealer:GetJobData', function(isCardealer, Categories, Owned, NotOwned)
        ARP.Menu.Visible(Menus.Main, false)
        MainMenuIsOpen = true
        while (MainMenuIsOpen) do
            ARP.Menu.IsVisible(Menus.Main, function()
                ARP.Menu.Item.Button("Achat de véhicule", '', {}, true, {
                    onSelected = function()

                    end
                }, nil)
                ARP.Menu.Item.Button("Achat de droit de vente", '', {}, true, {
                    onSelected = function()
                        TriggerServerEvent('arp_drivingschool:Buy', 'truck')
                        ARP.Menu.CloseAll()
                    end
                }, nil)
                ARP.Menu.Item.Button("Sortir un véhicule", '', {}, true, {}, nil)
                ARP.Menu.Item.Button("Facturer le véhicule", '', {}, true, {}, nil)
                ARP.Menu.Item.Button("Assigner le véhicule à l'entreprise", '', {}, true, {}, nil)
                ARP.Menu.Item.Button("Assigner le véhicule au joueur", '', {}, true, {}, nil)
            end, function() end, false)
            if (not ARP.Menu.GetVisibility(Menus.Main, false)) then
                MainMenuIsOpen = false
            end
            Citizen.Wait(0)
        end
        MainMenuIsOpen = false
    end, ENT.name)
end

-- functions to handle points
local function GetClosestPoints()
    local Points    = {}
    local closest   = nil

    for _, Point in pairs(ENT.point) do
        local distance  = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Point.pos)
        if (closest == nil or distance < closest) then
            closest = distance
        end
        if (distance <= Config.DrawDistance) then
            table.insert(Points, {distance = distance, pos = Point.pos, name = Point.name})
        end
    end
    return Points, closest
end

function Cardealer()
    local Points = {}

    while (ENT ~= nil) do
        Points, closest = GetClosestPoints()
        if (closest < 50) then
            print("im close")
            for _, Point in ipairs(Points) do
                DrawMarker(1, Point.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 204, 204, 0, 100, false, true, 2, false, nil, nil, false)
                if (Point.distance < 5) then
                    if (Point.name == 'menu' and not MainMenuIsOpen) then
                        ARP.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accèder au menu.")
				        if (IsControlJustReleased(1, 38)) then OpenMainMenu() end
                    elseif (Point.name == 'order') then
                    end
                else
                    if (Point.name == 'menu') then
                        MainMenuIsOpen = false
                    elseif (Point.name == 'order') then
                        -- function to call menu for order vehicle
                    end
                end
            end
            Citizen.Wait(0)
        else
            print('im not close')
            MainMenuIsOpen = false
            Citizen.Wait(5000)
        end
    end
end