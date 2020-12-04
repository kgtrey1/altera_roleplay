--
-- ALTERA PROJECT, 2020
-- ARP_Enterprise
-- File description:
-- Server side script selling and buying an enterprise
--

ARP.RegisterServerCallback('arp_enterprise:GetEnterpriseSaleStatus', function(source, cb, entName)
	cb(ENT[entName].for_sale, ENT[entName].sell_price)
end)

function SellEnterprise(entName)
    local _source   = source
    local Alter     = ARP.GetPlayerById(_source)

    if (Alter.job.GetJobName() ~= ENT[entName].jobname or Alter.job.GetEnterprise() ~= entName or Alter.job.GetGradeName() ~= 'boss') then
        print('msg à definir')
    else
        Alter.ShowNotification("Vous avez vendu votre entreprise.")
        Alter.job.SetJob('unemployed', 'none', 1)
        MySQL.Sync.execute('UPDATE enterprises SET `for_sale` = @status WHERE name = @name', {
            ['@status']     = true,
            ['@name']       = entName
        })
        ENT[entName].for_sale = true
        for _, playerId in ipairs(GetPlayers()) do
            TriggerClientEvent('arp_enterprise:SetEnterpriseStatus', playerId, entName, true)
        end
    end
end
RegisterNetEvent('arp_enterprise:SellEnterprise')
AddEventHandler('arp_enterprise:SellEnterprise', SellEnterprise)

function BuyEnterprise(entName)
    local _source   = source
    local Alter     = ARP.GetPlayerById(_source)

    if (Alter.job.GetJobName() ~= "unemployed") then
        Alter.ShowNotification("Vous ne pouvez pas acheter cette entreprise car vous avez déjà un travail.")
    elseif (Alter.money.GetCash() < ENT[entName].sell_price) then
        Alter.ShowNotification("Vous n'avez pas assez d'argent pour acheter cette entreprise.")
    else
        Alter.ShowNotification("Vous avez acheté une entreprise.")
        Alter.money.RemoveCash(ENT[entName].sell_price)
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