--
-- ALTERA PROJECT, 2020
-- ARP_Skin
-- File description:
-- Client side script.
--

local ARP           = nil
local FSMenu        = 'arp_skin:FaceSelection'
local FSItems       = {}
local Items         = {}

TriggerEvent('arp_framework:FetchObject', function(obj)
    ARP = obj
end)

ARP.Menu.RegisterMenu(FSMenu, 'Création de perso', 'Personnalisation')
ARP.Menu.Closable(FSMenu, false)

function ShowFaceSelectionMenu()
    local FSIsOpen = true

    ARP.Menu.CloseAll()
    ARP.Menu.Visible(FSMenu, false)
    while (FSIsOpen) do
        DisableInput()
        Citizen.Wait(1)
        ARP.Menu.IsVisible(FSMenu, function()
            for i = 1, #FSItems, 1 do
                ARP.Menu.Item.List(FSItems[i].Component.label, FSItems[i].List, 1, 'Personnalisez votre visage', {}, true, {
                    onListChange = function(index, item)
                        TriggerEvent('skinchanger:change', FSItems[i].Component.name, index)
                end, onSelected = function(index, item) end, onHovered = function(index, item)end })
            end
            ARP.Menu.Item.Button('Confirmer', 'Attention: Ceci est définitif.', {}, true, {
                onSelected = function()
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('arp_skin:SaveSkin', skin)
                    end)
                    FSIsOpen = false
            end, onHovered = function() end, onActive = function() end}, function() end)
        end, function() end)
    end
end

function DisableInput()
    DisableControlAction(2, 30, true)
    DisableControlAction(2, 31, true)
    DisableControlAction(2, 32, true)
    DisableControlAction(2, 33, true)
    DisableControlAction(2, 34, true)
    DisableControlAction(2, 35, true)
    DisableControlAction(0, 25, true) -- Input Aim
    DisableControlAction(0, 24, true) -- Input Attack
    DisableControlAction(0, 169, true)
end

function LoadFaceData()
    for i = 1, #Config.AuthorizedFaceMod, 1 do
        for j = 1, #Items, 1 do
            if (Items[j].Component.name == Config.AuthorizedFaceMod[i]) then
                FSItems[i] = Items[j]
                break
            end
        end
    end
    return
end

function CreateItemsTable(index, component, maxVal)
    local i = 1

    Items[index]            = {}
    Items[index].List       = {}
    Items[index].Component = component
    while (i <= maxVal) do
        table.insert(Items[index].List, tostring(i))
        i = i + 1
    end
    return
end

function LoadSkinData(components, maxVals)
    for i = 1, #components, 1 do
        for k, v in pairs(maxVals) do
            if (k == components[i].name) then
                CreateItemsTable(i, components[i], v)
                break
            end
        end
    end
    LoadFaceData()
    return
end

function test()
    Citizen.CreateThread(ShowFaceSelectionMenu)
end

TriggerEvent('skinchanger:getData', LoadSkinData)
AddEventHandler('arp_skin:OpenFaceSelection', test)