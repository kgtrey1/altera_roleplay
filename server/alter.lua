function CreateAlter(source, steamid, license, registered, identity)
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

    self.GetIdentity            = function()
        return ({
            firstname   = self.identity.GetFirstname(),
            lastname    = self.identity.GetLastname(),
            height      = self.identity.GetHeight(),
            gender      = self.identity.GetGender(),
            birthdate   = self.identity.GetBirthdate()
        })
    end

    return (self)
end