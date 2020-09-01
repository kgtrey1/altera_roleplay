function CreatePlayerObject(data)
    local self = {}

    self.identity   = data.identity

-- Getters for identity

    self.identity.GetFirstname  = function()
        return (self.identity.firstname)
    end

    self.identity.GetLastname   = function()
        return (self.identity.lastname)
    end

    self.identity.GetHeight     = function()
        return (self.identity.height)
    end

    self.identity.GetBirthdate  = function()
        return (self.identity.birthdate)
    end

    self.identity.GetGender     = function()
        return (self.identity.gender)
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

-- Getters for money

    self.money = {}

    self.money.cash     = data.money.cash
    self.money.bank     = data.money.bank
    self.money.dirty    = data.money.dirty
    self.money.bankname = data.money.bankname
    self.money.iban     = data.money.iban

    self.money.GetCash      = function()
        return (self.money.cash)
    end

    self.money.GetBank      = function()
        return (self.money.bank)
    end

    self.money.GetDirty     = function()
        return (self.money.dirty)
    end

    self.money.GetBankname  = function()
        return (self.money.bankname)
    end

    self.money.GetIban      = function()
        return (self.money.bankname)
    end

    self.GetMoney           = function() 
        return ({
            cash        = self.money.cash,
            bank        = self.money.bank,
            dirty       = self.money.dirty,
            bankname    = self.money.bankname,
            iban        = self.money.iban
        })
    end

    self.inventory = {}
    self.inventory.list     = data.inventory.list
    self.inventory.weight   = data.inventory.weight

    self.GetInventory = function()
        return (self.inventory.list)
    end

    self.job = data.job

    self.job.GetEnterprise = function()
        return (self.job.enterprise)
    end

    self.GetJob = function()
        return ({
            name        = self.job.name,
            label       = self.job.label,
            whitelisted = self.job.whitelisted,
            enterprise  = self.job.enterprise,
            grade       = self.job.grade,
            data        = self.job.data
        })
    end

    return (self)
end