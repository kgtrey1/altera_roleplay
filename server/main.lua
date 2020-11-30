Data = {}
ARP  = nil

TriggerEvent('arp_framework:FetchObject', function(Object)
    ARP = Object
end)

ARP.RegisterServerCallback('arp_stylizer:BuyItem', function(source, cb, comp, offset, price)
    local Alter = ARP.GetPlayerById(source)

    if (Alter.money.GetCash() >= price) then
        Alter.money.RemoveCash(price)
        if (Data[source].owned[comp] == nil) then
            Data[source].owned[comp] = {}
        end
        table.insert(Data[source].owned[comp], offset)
        cb(true, Data[source])
    end
end)

ARP.RegisterServerCallback('arp_stylizer:GetPlayerData', function(source, cb)
    cb(Data[source])
end)

function CreatePlayerEntry(Alter, source)
    local owned = {}
    local saved = {
        {skin = {}, set = 'none'},
        {skin = {}, set = 'none'},
        {skin = {}, set = 'none'}
    }
    MySQL.Sync.execute('INSERT INTO clothes (steamid, owned, saved) VALUES (@steamid, @owned, @saved)', {
            ['@steamid']    = Alter.GetSteamid(),
            ['@owned']      = json.encode(owned),    
            ['@saved']      = json.encode(saved)
    })
    Data[source] = {}
    Data[source].owned = owned
    Data[source].saved = saved
end

function InitializePlayer()
    local _source = source
    local Alter = ARP.GetPlayerById(_source)
    local result = MySQL.Sync.fetchAll("SELECT * FROM clothes WHERE steamid = @identifier", {
		['@identifier'] = Alter.GetSteamid()
    })

    if (result[1] == nil) then
        CreatePlayerEntry(Alter, _source)
    else
        Data[_source] = {}
        Data[_source].owned = json.decode(result[1].owned)
        Data[_source].saved = json.decode(result[1].saved)
    end
    return
end

RegisterNetEvent('arp_stylizer:InitializePlayer')
AddEventHandler('arp_stylizer:InitializePlayer', InitializePlayer)