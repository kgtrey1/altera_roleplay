Config = {}

Config.TimeAsSecond = function(ms)
    return (ms * 1000)
end

Config.PositionRefreshTimeout   = Config.TimeAsSecond(10)
Config.StartingCash             = 1000

Config.Weight                   = 10.0
Config.Bag                      = 20.0