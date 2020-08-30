local function BuildJob(job)
    local jobObject   = {}
    local existingJob = ARP.Jobs.GetJob(job.jobname)

    jobObject.whitelisted = existingJob.whitelisted
    jobObject.name        = existingJob.name
    jobObject.label       = existingJob.label
    if (jobObject.whitelisted) then
        jobObject.enterprise  = job.enterprise
        jobObject.grade       = job.grade
    else
        jobObject.enterprise  = 'none'
        jobObject.grade       = 1
    end
    jobObject.data = ARP.Jobs.GetGradeData(jobObject.name, jobObject.grade)
    return (jobObject)
end

local function BuildDefaultJob()
    local unemployedJob = ARP.Jobs.GetJob('unemployed')
    local job           = {}

    job.whitelisted = unemployedJob.whitelisted
    job.name        = unemployedJob.name
    job.label       = unemployedJob.label
    job.enterprise  = 'none'
    job.grade       = 1
    job.data        = ARP.Jobs.GetGradeData('unemployed', 1)
    return (job)
end

local function GetPlayerJob(steamid)
    local result = MySQL.Sync.fetchAll("SELECT * FROM employee WHERE steamid = @identifier", {
		['@identifier'] = steamid
    })

    if (result[1] == nil) then
        return (BuildDefaultJob())
    end
    return (BuildJob(result[1]))
end

-- Inventory functions

local function BuildInventory(inventory)
    local list = {}

    for k, v in pairs(inventory) do
        list[k]             = {}
        list[k].name        = k
        list[k].label       = Items[k].label
        list[k].amount      = v
        list[k].weight      = Items[k].weight
        list[k].totalweight = list[k].weight * list[k].amount
        list[k].usable      = Items[k].usable
    end
    return (list)
end

local function GetPlayerInventory(steamid)
    local result = MySQL.Sync.fetchAll("SELECT * FROM inventory WHERE steamid = @identifier", {
		['@identifier'] = steamid
    })

    if (result[1] == nil) then
        return ({})
    end
    return (BuildInventory(json.decode(result[1].inventory)))
end

-- Money functions

local function LoadPersonnalMoney(money)
    return ({
        cash        = money.cash,
        bank        = money.bank,
        dirty       = money.dirty,
        bankname    = money.bankname,
        iban        = money.iban
    })
end

local function LoadDefaultMoney()
    return ({
        cash        = Config.StartingCash,
        bank        = 0,
        dirty       = 0,
        bankname    = "none",
        iban        = "none"
    })
end

local function GetPlayerMoney(steamid)
    local result = MySQL.Sync.fetchAll("SELECT * FROM money WHERE steamid = @identifier", {
		['@identifier'] = steamid
    })

    if (result[1] == nil) then
        return (LoadDefaultMoney())
    end
    return (LoadPersonnalMoney(result[1]))
end

-- Identity functions

local function LoadPersonnalIdentity(data)
    local skin = nil

    if (data.skin == "") then
        skin = ''
    else
        skin = json.decode(data.skin)
    end
    return ({
        firstname   = data.firstname,
        lastname    = data.lastname,
        birthdate   = data.birthdate,
        gender      = data.gender,
        height      = data.height,
        skin        = skin,
        position    = json.decode(data.position)
    })
end

local function LoadDefaultIdentity()
    return ({
        firstname   = "undefined",
        lastname    = "undefined",
        birthdate   = "undefined",
        gender      = "undefined",
        height      = "undefined",
        skin        = "",
        position    = { x = 0, y = 0, z = 0 }
    })
end

local function GetPlayerIdentity(steamid)
    local result        = MySQL.Sync.fetchAll("SELECT * FROM users WHERE steamid = @identifier", {
		['@identifier'] = steamid
    })

    if (result[1] == nil) then
        return (LoadDefaultIdentity())
    end
    return (LoadPersonnalIdentity(result[1]))
end

-- Event handler

local function LoadPlayer()
    local _source       = source
    local steamid       = ARP.GetSteamIdById(_source)
    local license       = ARP.GetLicenseById(_source)
    local identity      = GetPlayerIdentity(steamid)
    local money         = GetPlayerMoney(steamid)
    local inventory     = GetPlayerInventory(steamid)
    local job           = GetPlayerJob(steamid)

    if (identity.firstname ~= "undefined") then
        PlayerData[_source] = CreateAlter(_source, steamid, license, true, identity, money, inventory, job)
        TriggerClientEvent('arp_framework:PlayerLoaded', _source, ARP.BuildClientObject(_source))
    else
        PlayerData[_source] = CreateAlter(_source, steamid, license, false, identity, money, inventory, job)
        TriggerClientEvent('arp_register:OpenRegistrationForm', _source)
    end
    return
end

RegisterNetEvent('arp_framework:LoadPlayer')
AddEventHandler('arp_framework:LoadPlayer', LoadPlayer)