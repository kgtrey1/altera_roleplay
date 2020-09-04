Data = {}
ARP  = nil

TriggerEvent('arp_framework:FetchObject', function(Object)
    ARP = Object
end)

OwnedCloth = {}

OwnedCloth[1] = {
    {name = 'shoes_1', value = {1, 2, 4}}
}

ARP.RegisterServerCallback('arp_stylizer:GetOwnedCloth', function(source, cb)
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
            ['@owned']      = json.encode(ownedClothes)
            ['@saved']      = json.encode(savedOutfit)
    })
    Data[_source] = {}
    Data[_source].owned = owned
    Data[_source].saved = saved
end

function GetPlayerData()
    local _source = source
    local Alter = ARP.GetPlayerById(_source)
    local result = MySQL.Sync.fetchAll("SELECT * FROM stats WHERE steamid = @identifier", {
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

RegisterNetEvent('arp_stylizer:GetPlayerData')
AddEventHandler('arp_stylizer:GetPlayerData', GetPlayerData)