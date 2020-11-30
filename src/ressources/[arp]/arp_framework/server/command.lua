local function GetTarget(target, _source)
    if (target == "self") then
        return (_source)
    end
    return (tonumber(target))
end

local function GetCmdLength(args)
    local length = 0

    for i = 1, #args, 1 do
        length = length + 1
    end
    return (length)
end

RegisterCommand('self.spawnvehicle', function(source, args)
    local ac = GetCmdLength(args)

    if (ac == 1) then
        TriggerClientEvent('arp_framework:CmdSpawnVehicle', source, args[1])
    end
end, false)

RegisterCommand('player.removeitem', function(source, args)
    local _source = source
    local ac = GetCmdLength(args)

    if (ac ~= 3) then
        return
    end
    local target = GetTarget(args[1], _source)
    local item   = tostring(args[2])
    local amount = tonumber(args[3])

    if (item ~= nil and amount ~= nil and target ~= nil and amount > 0) then
        if (Items[item] == nil) then
            print('item doesnt exist')
        elseif (PlayerData[target] == nil) then
            print('player doesnt exist')
        else
            PlayerData[target].inventory.RemoveItem(item, amount)
        end
    else
        print('invalid call')
        return
    end
end, false)

RegisterCommand('player.giveitem', function(source, args)
    local _source = source
    local ac = GetCmdLength(args)

    if (ac ~= 3) then
        return
    end
    local target = GetTarget(args[1], _source)
    local item   = tostring(args[2])
    local amount = tonumber(args[3])

    if (item ~= nil and amount ~= nil and target ~= nil and amount > 0) then
        if (Items[item] == nil) then
            print('item doesnt exist')
        elseif (PlayerData[target] == nil) then
            print('player doesnt exist')
        else
            PlayerData[target].inventory.AddItem(item, amount)
        end
    else
        print('invalid call')
        return
    end
end, false)