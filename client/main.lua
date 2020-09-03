--
-- ALTERA PROJECT, 2020
-- ARP_Stylizer
-- File description:
-- Client side script.
--

ARP 	= nil
Items 	= {}
Clothes = {}

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
	ARP.Player = playerData
end)

function LoadClothesData()
    for i = 1, #Config.List.Clothes, 1 do
        for j = 1, #Items, 1 do
            if (Items[j].Component.name == Config.List.Clothes[i]) then
                Clothes[i] = Items[j]
                break
            end
        end
    end
    return
end

function CreateRestrictedTable(index, component, maxVal, Restricted)
    local i = 1 -- real offset
    local f = 1 -- fake offset

    Items[index]            = {}
    Items[index].ListF      = {}
    Items[index].ListR      = {}
    Items[index].prices     = {}
    Items[index].Component  = component
    Items[index].restricted = true
    while (i <= maxVal) do
        if (Restricted[i] ~= -1) then
            table.insert(Items[index].ListF, string.format("%d\t~h~~g~%d$~s~"), f, Restricted[i])
            table.insert(Items[index].ListR, tostring(i))
            table.insert(Items[index].prices, Restricted[i])
            f = f + 1
        end
        i = i + 1
    end
    return
end

function CreateTable(index, component, maxVal)
    local i = 1

    Items[index]            = {}
    Items[index].List       = {}
    Items[index].Component  = component
    Items[index].restricted = false
    while (i <= maxVal) do
        table.insert(Items[index].List, tostring(i))
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

function CreateItemsTable(index, component, maxVal)
    local Restricted = IsTypeRestricted(component.name)

    if (Restricted == nil) then
        CreateTable(index, component, maxVal)
    else
        CreateRestrictedTable(index, component, maxVal, restricted)
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

TriggerEvent('skinchanger:getData', LoadSkinData)