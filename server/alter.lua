function CreateAlter(source, steamid, license, registered, identity, money)
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

    self.identity = identity

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
            firstname   = self.identity.GetFirstname(),
            lastname    = self.identity.GetLastname(),
            height      = self.identity.GetHeight(),
            gender      = self.identity.GetGender(),
            birthdate   = self.identity.GetBirthdate(),
            skin        = self.identity.GetSkin()
        })
    end

    -- Money

    self.money                  = money

    self.money.GetCash          = function()
        return (self.money.cash)
    end

    self.money.SetCash          = function(ammount)
        self.money.cash = ammount
        return
    end

    self.money.GetBank          = function()
        return (self.money.bank)
    end

    self.money.SetBank          = function(ammount)
        self.money.bank = ammount
        return
    end

    self.money.GetDirty         = function()
        return (self.money.dirty)
    end

    self.money.SetDirty         = function(ammount)
        self.money.dirty = ammount
        return
    end

    self.money.GetBankname      = function()
        return (self.money.bankname)
    end

    self.money.SetBankname      = function(bankname)
        self.money.bankname = bankname
        return
    end

    self.GetMoney               = function()
        return ({
            cash        = self.money.GetCash(),
            bank        = self.money.GetBank(),
            dirty       = self.money.GetDirty(),
            bankname    = self.money.GetBankname()
        })
    end

    return (self)
end