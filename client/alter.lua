function CreatePlayerObject(data)
    local self = {}

    self.money      = data.money
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
            firstname   = self.identity.GetFirstname(),
            lastname    = self.identity.GetLastname(),
            height      = self.identity.GetHeight(),
            gender      = self.identity.GetGender(),
            birthdate   = self.identity.GetBirthdate(),
            skin        = self.identity.GetSkin()
        })
    end

-- Getters for money

    self.money.GetCash        = function()
        return (self.money.cash)
    end

    self.money.GetBank        = function()
        return (self.money.bank)
    end

    self.money.GetDirty       = function()
        return (self.money.dirty)
    end

    self.money.GetBankname    = function()
        return (self.money.bankname)
    end

    self.GetMoney = function() 
        return ({
            cash        = self.GetCash(),
            bank        = self.GetBank(),
            dirty       = self.GetDirty(),
            bankname    = self.GetBankname()
        })
    end

    return (self)
end