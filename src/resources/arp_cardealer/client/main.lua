--
-- ALTERA PROJECT, 2020
-- arp_cardealer
-- File description:
-- main client side script
--

ARP = nil
ENT = nil
Menus = {}
Menus.Main = 'arp_cardealer:MainMenu'

TriggerEvent('arp_framework:FetchObject', function(Obj)
	ARP = Obj
end)

AddEventHandler('arp_framework:PlayerReady', function(playerData)
    ARP.Player = playerData

    for _, enterprise in pairs(Config.Enterprises) do -- Register enterprise, either for sale or for blip.
        if (enterprise.name == ARP.Player.job.GetEnterprise()) then
            ENT = enterprise
            Citizen.CreateThread(Cardealer)
            -- All thread starts here if player connect and has the job
            if (ARP.Player.job.GetGradeName() == 'boss') then
                Citizen.CreateThread(BossThread)
            end
        end
        TriggerEvent('arp_enterprise:RegisterEnterpriseStatus', {name = enterprise.name, config = enterprise.blip})
    end
    ARP.Menu.RegisterMenu(Menus.Main, 'Concession', 'MENU CONCESSIONNAIRE')
end)

function OnSetJob()
    ENT = nil -- we destroy current ENT
    ARP.Menu.CloseAll() -- we close all menu
    Citizen.Wait(500) -- we wait till all thread are closed
    local entName = ARP.Player.job.GetEnterprise()

    for _, enterprise in pairs(Config.Enterprises) do -- We verify if the new enterprise correspond to one of this job type
        if (entName == enterprise.name) then
            ENT = enterprise
            if (ARP.Player.job.GetGradeName() == 'boss') then -- If he's boss, it start boss threads
                Citizen.CreateThread(BossThread)
            end
        end
    end
end
AddEventHandler('arp_framework:OnSetJob', OnSetJob)