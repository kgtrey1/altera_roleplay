--
-- ALTERA PROJECT, 2020
-- ARP_Stylizer
-- File description:
-- Client side script.
--

ARP 	= nil
Action  = nil
Items 	= {}
Clothes = {}
Outfits = {}
Owned   = {}
Texture = {}    

TriggerEvent('arp_framework:FetchObject', function(object)
	ARP = object
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
    ARP.Player = playerData
    TriggerServerEvent('arp_stylizer:InitializePlayer')
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

function SynchronizeData()
    ARP.TriggerServerCallback('arp_stylizer:GetPlayerData', function(savedData)
        Outfits = savedData.saved
        Owned   = savedData.owned
        for k, v in pairs(savedData.owned) do
            for i = 1, #v, 1 do
                Items[k].ListF[tonumber(listR[v[i]])] = 'Possédé'
            end
        end
        LoadClothesData()
        if (Action == 'clothes') then
            DrawClothesMenu()
        end
    end)
end

function CreateRestrictedTable(component, maxVal, Restricted, texture)
    local i = 1 -- real offset
    local f = 1 -- fake offset
    local playerPed = PlayerPedId()

    Items[component.name]            = {}
    Items[component.name].ListF      = {}
    Items[component.name].ListR      = {}
    Items[component.name].prices     = Restricted
    Items[component.name].Component  = component
    Items[component.name].restricted = true
    if (texture ~= nil) then
        Items[component.name].textured         = true
        Items[component.name].Texture          = {}
        Items[component.name].Texture.list     = {}
        Items[component.name].Texture.name     = texture
        Items[component.name].Texture.iterator = 1
    else
        Items[component.name].textured     = false
    end
    while (i <= maxVal) do
        if (Restricted[i] ~= -1) then
            table.insert(Items[component.name].ListF, string.format("%d\t~h~~g~%d$~s~", f, Restricted[i]))
            table.insert(Items[component.name].ListR, tostring(i))
            if (Items[component.name].textured) then
                local textureList = CreateIndexList(GetNumberOfPedTextureVariations(playerPed, component.componentId, i))
                table.insert(Items[component.name].Texture.list, textureList)
            end
            f = f + 1
        end
        i = i + 1
    end
    return
end

function CreateTable(component, maxVal, texture)
    local i = 1
    local playerPed = PlayerPedId()

    Items[component.name]            = {}
    Items[component.name].List       = {}
    Items[component.name].Component  = component
    Items[component.name].restricted = false
    if (texture ~= nil) then
        Items[component.name].textured     = true
        Items[component.name].Texture      = {}
        Items[component.name].Texture.list = {}
        Items[component.name].Texture.name = texture
        Items[component.name].Texture.iterator = 1
    else
        Items[component.name].textured     = false
    end
    while (i <= maxVal) do
        table.insert(Items[component.name].List, tostring(i))
        if (Items[component.name].textured) then
            local textureList = CreateIndexList(GetNumberOfPedTextureVariations(playerPed, component.componentId, i))
            table.insert(Items[component.name].Texture.list, textureList)
        end
        i = i + 1
    end
    return
end

function CreateIndexList(size)
    local i    = 1
    local list = {}

    while (i <= size) do
        table.insert(list, i)
        i = i + 1
    end
    return (list)
end

function IsComponentTextured(componentName)
    for i = 1, #Config.Textured, 1 do
        if (Config.Textured[i].name == componentName) then
            return (Config.Textured[i].texture)
        end
    end
    return (nil)
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
    local texture    = IsComponentTextured(component.name)

    if (Restricted == nil) then
        CreateTable(component, maxVal, texture)
    else
        CreateRestrictedTable(component, maxVal, Restricted, texture)
    end
    return
end

function LoadSkinData(components, maxVals)
    for i = 1, #components, 1 do
        for k, v in pairs(maxVals) do
            if (k == components[i].name and components[i].textureof == nil) then
                CreateItemsTable(components[i], v)
                break
            end
        end
    end
    SynchronizeData()
    return
end