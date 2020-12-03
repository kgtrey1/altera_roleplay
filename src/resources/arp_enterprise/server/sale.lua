--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- Server side sale script
--

ARP.RegisterServerCallback('arp_enterprise:GetEnterpriseSaleStatus', function(source, cb, name)
	cb(ENT[name].for_sale)
end)

function BuyEnterprise(entName)
    local _source   = source
    local Alter     = ARP.GetPlayerById(_source)

    if (Alter.job.GetJobName() ~= "unemployed") then
        Alter.ShowNotification("Vous ne pouvez pas acheter cette entreprise car vous avez déjà un travail.")
    elseif (Alter.money.GetCash() < ENT[entName].sell_price) then
        Alter.ShowNotification("Vous n'avez pas assez d'argent pour acheter cette entreprise.")
    else
        Alter.job.SetJob(ENT[entName].jobname, entName, ARP.Jobs.GetBossGrade(ENT[entName].jobname))
        MySQL.Sync.execute('UPDATE enterprises SET `for_sale` = @status WHERE name = @name', {
            ['@status']     = false,
            ['@name']       = entName
        })
        ENT[entName].for_sale = false
        for _, playerId in ipairs(GetPlayers()) do
            TriggerClientEvent('arp_enterprise:SetEnterpriseStatus', playerId, entName, false)
        end
    end
end

RegisterNetEvent('arp_enterprise:BuyEnterprise')
AddEventHandler('arp_enterprise:BuyEnterprise', BuyEnterprise)