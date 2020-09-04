--
-- ALTERA PROJECT, 2020
-- ARP_Stylizer
-- File description:
-- Clothes script.
--

ClothMenuIsOpen = false
ClothMenu       = {
    main    = 'arp_stylizer:ClothMenu',
    buy     = 'arp_stylizer:ClothMenuBuy',
    save    = 'arp_stylizer:ClothMenuSave',
    outfit  = 'arp_stylizer:ClothMenuOutfit'
}

NewOutfit   = {}

function ItemIsOwned(compName, compOffset)
    for k, v in pairs(Owned) do
        if (k == compName) then
            for i = 1, #v, 1 do
                if (v[i] == compOffset) then
                    return (true)
                end
            end
            break
        end
    end
    return (false)
end

local function OnItemSelected(name, offset, price, fakeOffset)
    print(name)
    print(offset)
    print(price)
    print(fakeOffset)
    if (price == nil or ItemIsOwned(name, offset)) then
        NewOutfit[name] = offset
    else
        ARP.TriggerServerCallback('arp_stylizer:BuyItem', function(resp, data)
            if (resp == true) then
                Clothes[name].ListF[fakeOffset] = 'OWNED'
                NewOutfit[name] = offset
                Owned = data.owned
                print('its true')
            end
            
        end, name, offset, price) 
    end
end

local function DrawNonRestrictedList(v)
    ARP.Menu.Item.List(v.Component.label, v.List, 1, '', {}, true, {
        onListChange = function(index, item)
            v.Texture.iterator = index
            TriggerEvent('skinchanger:change', v.Component.name, index)
        end, onSelected = function(index, item)
            OnItemSelected(v.Component.name, index)
        end
    })
    if (v.textured) then
        ARP.Menu.Item.List(v.Texture.name, v.Texture.list[v.Texture.iterator], 1, '', {}, true, {
            onListChange = function(index, item)
                TriggerEvent('skinchanger:change', v.Texture.name, index - 1)
            end, onSelected = function(index, item)
                OnItemSelected(v.Texture.name, index - 1)
            end
        })
    end
end

local function DrawRestrictedList(v)
    ARP.Menu.Item.List(v.Component.label, v.ListF, 1, '', {}, true, {
        onListChange = function(index, item)
            v.Texture.iterator = index
            TriggerEvent('skinchanger:change', v.Component.name, tonumber(v.ListR[index]))
        end, onSelected = function(index, item)
            OnItemSelected(v.Component.name, tonumber(v.ListR[index]), v.prices[tonumber(v.ListR[index])], index)
        end
    })
    if (v.textured) then
        ARP.Menu.Item.List(v.Texture.name, v.Texture.list[v.Texture.iterator], 1, '', {}, true, {
            onListChange = function(index, item)
                TriggerEvent('skinchanger:change', v.Texture.name, index - 1)
            end, onSelected = function(index, item)
                OnItemSelected(v.Texture.name, index - 1)
            end
        })
    end
end


local function DrawBuyMenu()
    for k, v in pairs(Clothes) do
        if (v.restricted) then
            DrawRestrictedList(v)
        else
            DrawNonRestrictedList(v)
        end
    end
end

function DrawClothesMenu()
    if (ClothMenuIsOpen) then
        return
    end
    ARP.Menu.CloseAll()
    ARP.Menu.Visible(ClothMenu.buy, false)
    ClothMenuIsOpen = true
    while (ClothMenuIsOpen) do
        Citizen.Wait(0)
        ARP.Menu.IsVisible(ClothMenu.buy, function()
            for k, v in pairs(Clothes) do
                if (v.restricted) then
                    DrawRestrictedList(v)
                else
                    DrawNonRestrictedList(v)
                end
            end
        end, function() end, false)
        if (not ARP.Menu.GetVisibility(ClothMenu.buy, false)) then
            ClothMenuIsOpen = false
        end
    end
end

function RegisterClothMenus()
    ARP.Menu.RegisterMenu(ClothMenu.buy, 'Vetements', "MENU D'INTERACTION")
end

Citizen.CreateThread(function()
	while (true) do
		Citizen.Wait(0)
        if (IsControlJustPressed(1, 170)) then
            Action = 'clothes'
			TriggerEvent('skinchanger:getData', LoadSkinData)
		end
	end
end)