--
-- ALTERA PROJECT, 2020
-- ARP_Framework
-- File description:
-- Player object (data related to player).
--

PlayerData   = {}

function CreateAlter(source, steamid, license, registered, identity, money, inventory, job, stats, licenses)
    local self      = {}

    -- Game related data.
    self.source     = source
    self.steamid    = steamid
    self.license    = license

    self.GetSource              = function()
        return (self.source)
    end

    self.GetSteamid             = function()
        return (self.steamid)
    end

    self.GetLicense             = function()
        return (self.license)
    end

    -- Utils

    self.ShowNotification       = function(message)
        TriggerClientEvent('arp_framework:ShowNotification', self.source, message)
        return
    end

    -- Registration

    self.registered = registered

    self.SetRegistrationStatus  = function(status)
        self.registered = true
        return
    end

    self.GetRegistrationStatus  = function()
        return (self.registered)
    end

    -- Latest known position

    self.position = identity.position

    self.SetPosition    = function(pos)
        self.position = pos
        return
    end

    self.GetPosition    = function()
        return (self.position)
    end

    -- Identity related data.

    self.identity = {}

    self.identity.firstname = identity.firstname
    self.identity.lastname  = identity.lastname
    self.identity.height    = identity.height
    self.identity.birthdate = identity.birthdate
    self.identity.gender    = identity.gender
    self.identity.skin      = identity.skin

    self.identity.SetFirstname  = function(name)
        self.identity.firstname = name
        return
    end

    self.identity.GetFirstname  = function()
        return (self.identity.firstname)
    end

    self.identity.SetLastname   = function(lastname)
        self.identity.lastname = lastname
        return
    end

    self.identity.GetLastname   = function()
        return (self.identity.lastname)
    end

    self.identity.SetHeight     = function(height)
        self.identity.height = height
        return
    end

    self.identity.GetHeight     = function()
        return (self.identity.height)
    end

    self.identity.SetBirthdate  = function(birthdate)
        self.identity.birthdate = birthdate
        return
    end

    self.identity.GetBirthdate  = function()
        return (self.identity.birthdate)
    end

    self.identity.SetGender     = function(gender)
        self.identity.gender = gender
    end

    self.identity.GetGender     = function()
        return (self.identity.gender)
    end

    self.identity.SetSkin       = function(skin)
        self.identity.skin = skin
        return
    end

    self.identity.GetSkin       = function()
        return (self.identity.skin)
    end

    self.GetIdentity            = function()
        return ({
            firstname   = self.identity.firstname,
            lastname    = self.identity.lastname,
            height      = self.identity.height,
            gender      = self.identity.gender,
            birthdate   = self.identity.birthdate,
            skin        = self.identity.skin
        })
    end

    -- Money

    self.money = {}

    self.money.cash     = money.cash
    self.money.bank     = money.bank
    self.money.dirty    = money.dirty
    self.money.bankname = money.bankname
    self.money.iban     = money.iban

    self.money.GetCash          = function()
        return (self.money.cash)
    end

    self.money.AddCash          = function(amount)
        self.money.cash = self.money.cash + amount
        self.money.OnCashChange()
    end

    self.money.RemoveCash       = function(amount)
        self.money.cash = self.money.cash - amount
        self.money.OnCashChange()
        return
    end

    self.money.OnCashChange     = function()
        TriggerClientEvent('arp_framework:OnCashChange', self.source, self.money.cash)
        return
    end

    self.money.GetBank          = function()
        return (self.money.bank)
    end

    self.money.AddBank          = function(amount)
        self.money.bank = self.money.bank + amount
        self.money.OnBankChange()
        return
    end

    self.money.RemoveBank       = function(amount)
        self.money.bank = self.money.bank - amount
        self.money.OnBankChange()
        return
    end

    self.money.OnBankChange     = function()
        TriggerClientEvent('arp_framework:OnBankChange', self.source, self.money.bank)
        return
    end

    self.money.GetDirty         = function()
        return (self.money.dirty)
    end

    self.money.AddDirty         = function(amount)
        self.money.dirty = self.money.dirty + amount
        self.money.OnDirtyChange()
        return
    end

    self.money.RemoveDirty      = function(amount)
        self.money.dirty = self.money.dirty - amount
        self.money.OnDirtyChange()
        return
    end

    self.money.OnDirtyChange    = function()
        TriggerClientEvent('arp_framework:OnDirtyChange', self.source, self.money.dirty)
        return
    end

    self.money.GetBankname      = function()
        return (self.money.bankname)
    end

    self.money.SetBankname      = function(bankname)
        self.money.bankname = bankname
        TriggerClientEvent('arp_framework:OnBanknameChange', self.source, self.money.bankname)
        return
    end

    self.money.GetIban          = function()
        return (self.money.iban)
    end

    self.money.SetIban          = function(iban)
        self.money.iban = iban
        TriggerClientEvent('arp_framework:OnIbanChange', self.source, self.money.iban)
        return
    end

    self.GetMoney               = function()
        return ({
            cash        = self.money.cash,
            bank        = self.money.bank,
            dirty       = self.money.dirty,
            bankname    = self.money.bankname,
            iban        = self.money.iban
        })
    end

    -- Inventory

    self.inventory = {}

    self.inventory.list     = inventory
    self.inventory.weight   = 0

    self.inventory.CreateItem = function(name, amount)
        self.inventory.list[name] = {}
        self.inventory.list[name].name          = name
        self.inventory.list[name].label         = Items[name].label
        self.inventory.list[name].amount        = amount
        self.inventory.list[name].weight        = Items[name].weight
        self.inventory.list[name].totalweight   = Items[name].weight * amount
        self.inventory.list[name].usable        = Items[name].usable
        return
    end

    self.inventory.GetWeight = function()
        local weight = 0

        for k, v in pairs(self.inventory.list) do
            weight = weight + v.totalweight
        end
        self.inventory.weight = weight
    end

    self.inventory.AddItem = function(name, amount)
        if (Items[name] == nil or amount < 0) then
            print(string.format("ARP> Invalid call to AddItem. (User: %s, Obj: %s, Num: %d)", self.steamid, name, amount))
            return (false)
        end
        if (self.inventory.list[name] ~= nil) then
            self.inventory.list[name].amount = self.inventory.list[name].amount + amount
            self.inventory.list[name].totalweight = self.inventory.list[name].amount * self.inventory.list[name].weight
        else
            self.inventory.CreateItem(name, amount)
        end
        
        self.inventory.OnInventoryChange()
        return (true)
    end

    self.inventory.RemoveItem = function(name, amount)
        if (Items[name] == nil or amount < 0) then
            print(string.format("ARP> Invalid call to RemoveItem #1. (User: %s, Obj: %s, Num: %d)", self.steamid, name, amount))
            return
        elseif (self.inventory.list[name] == nil) then
            print(string.format("ARP> Invalid call to RemoveItem #2. (User: %s, Obj: %s, Num: %d)", self.steamid, name, amount))
            return
        elseif (self.inventory.list[name].amount < amount) then
            print(string.format("ARP> Invalid call to RemoveItem #3. (User: %s, Obj: %s, Num: %d)", self.steamid, name, amount))
            return
        end
        if (self.inventory.list[name].amount <= 0) then
            self.inventory.list[name] = nil
        else
            self.inventory.list[name].amount = self.inventory.list[name].amount - amount
            self.inventory.list[name].totalweight = self.inventory.list[name].amount * self.inventory.list[name].weight
        end
        self.inventory.OnInventoryChange()
        return
    end

    self.inventory.GetItemAmount = function(name)
        if (self.inventory.list[name] ~= nil) then
            return (self.inventory.list[name].amount)
        end
        return (0)
    end

    self.inventory.OnInventoryChange = function()
        self.inventory.GetWeight()
        TriggerClientEvent('arp_framework:OnInventoryChange', self.source, self.inventory.list, self.inventory.weight)
    end

    self.CanCarryItem = function(item, amount)
        local weight = 0

        if (Items[name] == nil or amount < 0) then
            print(string.format("ARP> Invalid call to CanCarryItem. (User: %s, Obj: %s, Num: %d)", self.steamid, name, amount))
            return
        end
        weight = Items[name].weight * amount
        if (weight + self.inventory.weight <= self.stats.attr.weight) then
            return (true)
        end
        return (false)
    end

    self.GetInventory = function()
        return ({
            list   = self.inventory.list,
            weight = self.inventory.weight
        })
    end

    self.inventory.GetWeight()

    -- Job

    self.job = job

    self.job.JobIsWhitelisted = function()
        return (self.job.whitelisted)
    end

    self.job.GetEnterprise = function()
        return (self.job.enterprise)
    end

    self.job.GetGrade = function()
        return (self.job.grade)
    end

    self.GetJob = function()
        return ({
            whitelisted = self.job.whitelisted,
            name        = self.job.name,
            label       = self.job.label,
            enterprise  = self.job.enterprise,
            grade       = self.job.grade,
            data        = self.job.data
        })
    end

    -- Stats

    self.stats = {}
    
    self.stats.list = stats
    self.stats.attr = {}

    self.stats.GetWeight = function()
        return (self.stats.attr.weight)
    end

    self.stats.OnStrengthLevelUp = function()
        self.stats.attr.maxhealth    = Config.Stats.MaxHealth[self.stats.list.strengthLevel]
        self.stats.attr.healthregen  = Config.Stats.HealthRegen[self.stats.list.strengthLevel]
        self.stats.attr.weight       = Config.Stats.Weight[self.stats.list.strengthLevel]
    end

    self.stats.OnStrengthLevelUp()


    self.GetStats = function()
        return ({
            list = self.stats.list,
            attr = self.stats.attr
        })
    end

    self.licenses = {}

    self.licenses.idCard    = licenses.idcard
    self.licenses.car       = licenses.car
    self.licenses.truck     = licenses.truck
    self.licenses.bike      = licenses.bike
    self.licenses.firearms  = licenses.firearms

    self.licenses.GetDrivingLicense = function()
        return ({
            car     = self.licenses.car,
            truck   = self.licenses.truck,
            bike    = self.licenses.bike
        })
    end

    self.licenses.GetFirearmsLicense = function()
        return (self.licenses.firearms)
    end

    self.licenses.GetIdCard = function()
        return (self.licenses.idcard)
    end

    self.licenses.SetDrivingLicense = function(type, value)
        if (type == 'car' or type == 'truck' or type == 'bike' and type(value) == 'boolean') then
            self.licenses[type] = value
            MySQL.Sync.execute('UPDATE licenses SET `' .. type .. '` = @value WHERE steamid = @steamid', {
                ['@value']   = value,
                ['@steamid'] = self.steamid
            })
        else
            print('ARP> Attempting to set driving licence with a non boolean value (SteamID:' .. self.steamid .. ').')
        end
        return
    end

    self.licenses.SetFirearmsLicense = function(value)
        if (type(value) == 'boolean') then
            self.licenses.firearms = value
            MySQL.Sync.execute('UPDATE licenses SET `firearms` = @value WHERE steamid = @steamid', {
                ['@value']   = value,
                ['@steamid'] = self.steamid
            })
        else
            print('ARP> Attempting to set firearms licence with a non boolean value (SteamID:' .. self.steamid .. ').')
        end
        return
    end

    self.licenses.SetIdCard = function(value)
        if (type(value) == 'boolean') then
            self.licenses.idcard = value
            MySQL.Sync.execute('UPDATE licenses SET `idcard` = @value WHERE steamid = @steamid', {
                ['@value']   = value,
                ['@steamid'] = self.steamid
            })
        else
            print('ARP> Attempting to set driving licence with a non boolean value (SteamID:' .. self.steamid .. ').')
        end
        return
    end

    return (self)
end