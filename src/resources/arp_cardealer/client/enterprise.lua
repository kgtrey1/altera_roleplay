function BossThread()
    local distance = nil
    local playerCoords = nil

    while (ENT ~= nil) do
        playerCoords = GetEntityCoords(PlayerPedId())
        distance = #(playerCoords - ENT.boss)
        if (distance <= 50) then
            if (distance < 5) then
                ARP.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu boss.")
                if (IsControlJustReleased(1, 38)) then
                    TriggerEvent('arp_enterprise:OpenBossMenu', ENT.name)
                end
            end
            DrawMarker(1, ENT.boss, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 204, 204, 0, 100, false, true, 2, false, nil, nil, false)
            Citizen.Wait(0)
        else
            Citizen.Wait(5000)
        end
    end
end