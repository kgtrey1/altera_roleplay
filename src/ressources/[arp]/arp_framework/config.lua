Config = {}

Config.TimeAsSecond = function(ms)
    return (ms * 1000)
end

Config.PositionRefreshTimeout   = Config.TimeAsSecond(10)
Config.StartingCash             = 1000

Config.Weight                   = 10.0
Config.Stamina                  = 30
Config.Bag                      = 20.0

Config.Stats = {}

Config.Stats.levelUp    = {}
Config.Stats.levelUp[1] = 100
Config.Stats.levelUp[2] = 200
Config.Stats.levelUp[3] = 300
Config.Stats.levelUp[4] = 400
Config.Stats.levelUp[5] = 500

Config.Stats.MaxHealth      = {}
Config.Stats.MaxHealth[1]   = 70
Config.Stats.MaxHealth[2]   = 100
Config.Stats.MaxHealth[3]   = 115
Config.Stats.MaxHealth[4]   = 130
Config.Stats.MaxHealth[5]   = 10000

Config.Stats.HealthRegen    = {}
Config.Stats.HealthRegen[1] = 20
Config.Stats.HealthRegen[2] = 40
Config.Stats.HealthRegen[3] = 60
Config.Stats.HealthRegen[4] = 80
Config.Stats.HealthRegen[5] = 100

Config.Stats.Weight     = {}
Config.Stats.Weight[1]  = 12
Config.Stats.Weight[2]  = 14
Config.Stats.Weight[3]  = 15
Config.Stats.Weight[4]  = 16
Config.Stats.Weight[5]  = 17