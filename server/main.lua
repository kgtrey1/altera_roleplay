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
            Items[result[i].name].usable    = result[i].usable
            print(json.encode(Items[result[i].name]))
        end
    end)
end)