ARP = {}


ARP.RegisterServerCallback = function()

end



ARP.Whitelist = {}
ARP.Banlist = {}
ARP.PlayerData = {}

ServerIsLoaded = false

-- Player date storage
-- Loads the player at connection and save his data on disconnection.

function GetSteamIdById(id)
    local identifiers = GetPlayerIdentifiers(id)
    local steamid = nil

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamid = string.gsub(v, "steam:", "")
            steamid = tostring(tonumber(steamid, 16))
            return (steamid)
        end
    end
end

function SavePlayer(reason)
    local _source = source
    local position = {
        x = ARP.PlayerData[_source].position.x,
        y = ARP.PlayerData[_source].position.y,
        z = ARP.PlayerData[_source].position.z
    }

    position = json.encode(position)
    MySQL.Async.execute('UPDATE users SET `position` = @lastPosition WHERE steamid = @steamid', {
        ['@lastPosition'] = position,
        ['@steamid'] = ARP.PlayerData[_source].steamid
    }, function(rowsChanged) end)
    Citizen.Wait(1000)
end

function LoadPlayer()
    local _source = source

    ARP.PlayerData[_source] = {}
    ARP.PlayerData[_source].id = _source
    ARP.PlayerData[_source].steamid = GetSteamIdById(_source)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE steamid = @identifier", {
		['@identifier'] = ARP.PlayerData[_source].steamid
    }, function(result)
        if (result[1].steamid == nil) then
            print("user is not registered")
        else
            ARP.PlayerData[_source].position = json.decode(result[1].position)
            print("User is registered: ID:" .. _source)
        end
	end)
end

function UpdatePlayerPosition(coords)
    local _source = source

    print(coords)
    ARP.PlayerData[_source].position = coords
end

RegisterNetEvent('arp_framework:OnPlayerReady')
AddEventHandler('arp_framework:OnPlayerReady', LoadPlayer)
AddEventHandler('playerDropped', SavePlayer)


RegisterNetEvent('arp_framework:WarpPlayerToLatestPosition')
AddEventHandler('arp_framework:WarpPlayerToLatestPosition', function(ped)
    local _source = source

    print("ready")
    SetEntityCoords(ped, ARP.PlayerData[_source].position.x, ARP.PlayerData[_source].position.y, ARP.PlayerData[_source].position.z, false, false, false, true)
end)

RegisterNetEvent('arp_framework:UpdatePlayerPosition')
AddEventHandler('arp_framework:UpdatePlayerPosition', UpdatePlayerPosition)

-- Verification on the User
-- Used to prevent banned player to connect or enforce the whitelist

function UserIsBanned(steamid, ip, license, deferrals)
    for _, v in pairs(ARP.Banlist) do
        if (steamid == v.steamid or ip == v.ip or license == v.license) then
            v.date = tonumber(v.date)
            if (v.date >= os.time()) then
                deferrals.done(string.format("Vous avez été banni jusqu'au %s.\nRaison: %s", os.date('%d/%m/%Y à %H:%M:%S', v.date), v.reason))
                return (true)
            end
            break
        end
    end
    return (false)
end

function UserIsWhitelisted(steamid, deferrals)
    for _, v in pairs(ARP.Whitelist) do
        if (steamid == v.steamid) then
            return (true)
        end
    end
    deferrals.done("Vous devez être whitelisted pour vous connecter.")
    return (false)
end

local function VerifyAuthorization(name, setKickReason, deferrals)
    local _source = source
    local identifiers = GetPlayerIdentifiers(_source)
    local steamid = nil
    local license = nil
    local ip = nil

    deferrals.defer()
    Wait(0)
    deferrals.update("Le serveur est en cours de chargement...")
    while not ServerIsLoaded do
        Wait(1000)
    end
    deferrals.update(string.format("Hello %s, nous vérifions que tout est en ordre.", name))
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamid = string.gsub(v, "steam:", "")
            steamid = tostring(tonumber(steamid, 16))
        elseif string.find(v, "license") then
            license = string.gsub(v, "license:", "")
        elseif string.find(v, "ip") then
            ip = string.gsub(v, "ip:", "")
        end
    end
    if Config.UsingWhitelist == true and UserIsWhitelisted(steamid) and
    not UserIsBanned(steamid, ip, license, deferrals) then
        deferrals.done()
    end
    return
end

AddEventHandler("playerConnecting", VerifyAuthorization)

-- Refresh functions.
-- Used for synchronisation between web app and server.

function RefreshWhitelist()
    while true do
        ARP.Whitelist = MySQL.Sync.fetchAll('SELECT * FROM whitelist')
        print("arp_framework: Refreshing whitelist")
        Citizen.Wait(Config.RefreshTime)
    end
end

local function RefreshBanlist()
    while true do
        ARP.Banlist = MySQL.Sync.fetchAll('SELECT * FROM banlist')
        print("arp_framework: Refreshing banlist")
        Citizen.Wait(Config.RefreshTime)
    end
end

MySQL.ready(function()
    Citizen.CreateThread(RefreshWhitelist)
    Citizen.CreateThread(RefreshBanlist)
end)

-- Loading Timeout.

function LoadingClock()
    Citizen.Wait(Config.LoadTime)
    ServerIsLoaded = true
end

Citizen.CreateThread(LoadingClock)
