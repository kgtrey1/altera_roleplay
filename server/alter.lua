function CreateAlter(source, steamid, license, registered, identity, money, inventory)
    local self      = {}

    print(json.encode(money))
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
        return
    end

    self.inventory.GetWeight = function()
        local weight = 0

        print('called')
        for k, v in pairs(self.inventory.list) do
            weight = weight + v.totalweight
            print(v.name)
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

    self.inventory.OnInventoryChange = function()
        self.inventory.GetWeight()
        TriggerClientEvent('arp_framework:OnInventoryChange', self.source, self.inventory.list, self.inventory.weight)
    end

    self.GetInventory = function()
        return ({
            list   = self.inventory.list,
            weight = self.inventory.weight
        })
    end

    self.inventory.GetWeight()

    return (self)
end