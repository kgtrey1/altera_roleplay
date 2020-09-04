--
-- ALTERA PROJECT, 2020
-- ARP_Stylizer
-- File description:
-- Client side script.
--

ARP 	= nil
Items 	= {}
Clothes = {}
Outfits = {}

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
    ARP.Player = playerData
    RegisterClothMenus()
end)

function LoadClothesData()
    for i = 1, #Config.List.Clothes, 1 do
        for k, v in pairs(Items) do
            if (k == Config.List.Clothes[i]) then
                Clothes[k] = v
                break
            end
        end
    end
    return
end

function SynchronizeData(type)
    ARP.TriggerServerCallback('arp_stylizer:GetPlayerData', function(savedData)
        Outfits = savedData.saved
        for (k, v in pairs savedData.owned) do
            for i = 1, #v.value, 1 do
                Items[v.name].ListF[v.value[i]] = 'Possédé'
            end
        end
        LoadClothesData()
        if (type == 'clothes') then
            DrawClothesMenu()
        end
    end)
end

function CreateRestrictedTable(component, maxVal, Restricted)
    local i = 1 -- real offset
    local f = 1 -- fake offset

    Items[component.name]            = {}
    Items[component.name].ListF      = {}
    Items[component.name].ListR      = {}
    Items[component.name].prices     = {}
    Items[component.name].Component  = component
    Items[component.name].restricted = true
    while (i <= maxVal) do
        if (Restricted[i] ~= -1) then
            table.insert(Items[component.name].ListF, string.format("%d\t~h~~g~%d$~s~", f, Restricted[i]))
            table.insert(Items[component.name].ListR, tostring(i))
            table.insert(Items[component.name].prices, Restricted[i])
            f = f + 1
        end
        i = i + 1
    end
    return
end

function CreateTable(component, maxVal)
    local i = 1

    Items[component.name]            = {}
    Items[component.name].List       = {}
    Items[component.name].Component  = component
    Items[component.name].restricted = false
    while (i <= maxVal) do
        table.insert(Items[component.name].List, tostring(i))
        i = i + 1
    end
    return
end

function IsTypeRestricted(componentName)
    for k, v in pairs(Config.Restricted) do
        if (v.name == componentName) then
            return (v.prices)
        end
    end
    return (nil)
end

function CreateItemsTable(component, maxVal)
    local Restricted = IsTypeRestricted(component.name)

    if (Restricted == nil) then
        CreateTable(component, maxVal)
    else
        CreateRestrictedTable(component, maxVal, Restricted)
    end
    return
end

function LoadSkinData(components, maxVals, type)
    for i = 1, #components, 1 do
        for k, v in pairs(maxVals) do
            if (k == components[i].name) then
                CreateItemsTable(components[i], v)
                break
            end
        end
    end
    SynchronizeData(type)
    return
end