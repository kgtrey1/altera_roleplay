--
-- ALTERA PROJECT, 2020
-- ARP_Framework
-- File description:
-- Functions which save player on drop.
--

local function SavePlayerInventory(source)
    local list      = {}
    local inventory = PlayerData[source].GetInventory()

    for k, v in pairs(inventory.list) do
        if (v.amount > 0) then
            list[v.name] = v.amount
        end
    end
    MySQL.Sync.execute('UPDATE inventory SET `inventory` = @inventory WHERE steamid = @steamid', {
        ['@inventory']  = json.encode(list),
        ['@steamid']    = PlayerData[source].GetSteamid()
    })
end

local function SavePlayerMoney(source)
    MySQL.Sync.execute('UPDATE money \
    SET `cash` = @cash, `bank` = @bank, `dirty` = @dirty, `bankname` = @bankname, `iban` = @iban \
    WHERE steamid = @steamid', {
        ['@cash']       = PlayerData[source].money.GetCash(),
        ['@bank']       = PlayerData[source].money.GetBank(),
        ['@dirty']      = PlayerData[source].money.GetDirty(),
        ['@bankname']   = PlayerData[source].money.GetBankname(),
        ['@iban']       = PlayerData[source].money.GetIban(),
        ['@steamid']    = PlayerData[source].GetSteamid()
    })
end

local function SavePlayerIdentity(source)
    local position = PlayerData[source].GetPosition()

    position = json.encode({x = position.x, y = position.y, z = position.z})
    MySQL.Sync.execute('UPDATE users \
    SET `position` = @position, `firstname` = @firstname, `lastname` = @lastname, `height` = @height, `birthdate` = @birthdate \
    WHERE steamid = @steamid', {
        ['@position']   = position,
        ['@firstname']  = PlayerData[source].identity.GetFirstname(),
        ['@lastname']   = PlayerData[source].identity.GetLastname(),
        ['@height']     = PlayerData[source].identity.GetHeight(),
        ['@birthdate']  = PlayerData[source].identity.GetBirthdate(),
        ['@steamid']    = PlayerData[source].GetSteamid()
    })
    return
end

local function SavePlayer(reason)
    local _source = source

    if (PlayerData[_source].GetRegistrationStatus() == true) then
        SavePlayerIdentity(_source)
        SavePlayerMoney(_source)
        SavePlayerInventory(_source)
    end
    if (reason ~= 'global_save') then
        if (PlayerData[_source].GetRegistrationStatus() == true) then
            print(string.format('ARP> Saving %s. Reason: %s', PlayerData[_source].GetSteamid(), reason))
        end
        PlayerData[_source] = nil
    end
    return
end

AddEventHandler('playerDropped', SavePlayer)