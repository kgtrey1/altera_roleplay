local function UpdatePlayerPosition(pos)
    local _source = source

    PlayerData[_source].SetPosition(pos)
    return
end

RegisterNetEvent('arp_framework:UpdatePlayerPosition')
AddEventHandler('arp_framework:UpdatePlayerPosition', UpdatePlayerPosition)

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * from items', {}, function(result)
        for i = 1, #result, 1 do
            Items[result[i].name] = {}
            Items[result[i].name].label     = result[i].label
            Items[result[i].name].weight    = result[i].weight
            Items[result[i].name].volume    = result[i].volume
            Items[result[i].name].texture   = result[i].texture
            Items[result[i].name].usable    = result[i].usable
            print(json.encode(Items[result[i].name]))
        end
    end)
end)

RegisterNetEvent('arp_framework:OnItemDrop')
AddEventHandler('arp_framework:OnItemDrop', function(name, amount, coords)
    local _source = source

    if (Items[name] ~= nil and amount > 0) then
        if (PlayerData[_source].inventory.GetItemAmount(name) >= amount) then
            PlayerData[_source].inventory.RemoveItem(name, amount)
            Drops.List[Drops.Ticket]         = {}
            Drops.List[Drops.Ticket].name    = name
            Drops.List[Drops.Ticket].label   = Items[name].label
            Drops.List[Drops.Ticket].amount  = amount
            Drops.List[Drops.Ticket].coords  = coords
            Drops.List[Drops.Ticket].texture = Items[name].texture
            Drops.Ticket = Drops.Ticket + 1
            TriggerClientEvent('arp_framework:OnDropListChange', -1, Drops.List, Drops.Ticket - 1, 'drop')
        else
            print('illegal call')
            return
        end
    else
        print("bad call")
        return
    end
end)

RegisterNetEvent('arp_framework:OnItemPickup')
AddEventHandler('arp_framework:OnItemPickup', function(index, coords)
    local _source = source

    if (Drops[index] ~= nil) then
        PlayerData[_source].inventory.AddItem(Drops[index].name, Drops[index].amount)
        Drops[index] = nil
        TriggerClientEvent('arp_framework:OnDropListChange', -1, Drops.List, index, 'pickup')
    else
        print("Illegal call")
        return
    end
end)