ARP = {}
ARP.Whitelist = {}
ARP.Banlist = {}

ServerIsLoaded = false

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