local function UpdatePlayerPosition(pos)
    local _source = source

    PlayerData[_source].SetPosition(pos)
    return
end

RegisterNetEvent('arp_framework:UpdatePlayerPosition')
AddEventHandler('arp_framework:UpdatePlayerPosition', UpdatePlayerPosition)

function GetGrades()
    MySQL.Async.fetchAll('SELECT * from grades', {}, function(result)
        local grade     = 0
        local jobname   = ''

        for i = 1, #result, 1 do
            jobname = tostring(result[i].jobname)
            grade   = tonumber(result[i].grade)
            ARP.Jobs.List[jobname].grades[grade]        = {}
            ARP.Jobs.List[jobname].grades[grade].name   = result[i].name
            ARP.Jobs.List[jobname].grades[grade].label  = result[i].label
            ARP.Jobs.List[jobname].grades[grade].rank   = result[i].grade
            ARP.Jobs.List[jobname].grades[grade].salary = result[i].salary
            ARP.Jobs.List[jobname].grades[grade].skin_m = json.decode(result[i].skin_m)
            ARP.Jobs.List[jobname].grades[grade].skin_f = json.decode(result[i].skin_f)
        end
    end)
end

function InitJobs()
    MySQL.Async.fetchAll('SELECT * from jobs', {}, function(result)
        for i = 1, #result, 1 do
            ARP.Jobs.List[result[i].name]               = {}
            ARP.Jobs.List[result[i].name].name          = result[i].name
            ARP.Jobs.List[result[i].name].label         = result[i].label
            ARP.Jobs.List[result[i].name].whitelisted   = result[i].whitelisted
            ARP.Jobs.List[result[i].name].grades        = {}
        end
        GetGrades()
    end)
end

function InitItems()
    MySQL.Async.fetchAll('SELECT * from items', {}, function(result)
        for i = 1, #result, 1 do
            Items[result[i].name] = {}
            Items[result[i].name].label     = result[i].label
            Items[result[i].name].weight    = result[i].weight
            Items[result[i].name].volume    = result[i].volume
            Items[result[i].name].texture   = result[i].texture
            Items[result[i].name].usable    = result[i].usable
        end
    end)
end

MySQL.ready(function()
    Citizen.CreateThread(function()
        Citizen.Wait(3000)
        InitJobs()
        InitItems()
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
AddEventHandler('arp_framework:OnItemPickup', function(index)
    local _source = source

    if (Drops.List[index] ~= nil) then
        PlayerData[_source].inventory.AddItem(Drops.List[index].name, Drops.List[index].amount)
        Drops.List[index].name = nil
        TriggerClientEvent('arp_framework:OnDropListChange', -1, Drops.List, index, 'pickup')
    else
        print("Illegal call")
        return
    end
end)