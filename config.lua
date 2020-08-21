Config = {}

Config.TimeAsSecond = function(ms)
    return (ms * 1000)
end

Config.PositionRefreshTimeout   = Config.TimeAsSecond(10)