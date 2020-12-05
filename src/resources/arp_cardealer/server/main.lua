--
-- ALTERA PROJECT, 2020
-- arp_cardealer
-- File description:
-- main server script
--

ENT = {}
Car = {}
Cat = {}

ARP = nil

TriggerEvent('arp_framework:FetchObject', function(Object)
	ARP = Object
end)

ARP.RegisterServerCallback('arp_cardealer:GetJobData', function(source, cb, entName)
    local Alter = ARP.GetPlayerById(source)

    if (Alter.job.GetEnterprise() ~= entName) then
        print('message to define')
        cb(false, nil, nil)
    else
        cb(true, Cat, ENT[entName].owned, ENT[entName].not_owned)
    end
end)

function AssignCarToEnterprises()
    local list  = nil
    local found = false

    for name, _ in pairs(ENT) do
        for __, vehicle in pairs(Car) do
            found = false
            if (vehicle.owned_by_default) then
                ENT[name].owned[vehicle.category][vehicle.model] = vehicle
            else
                for ___, ent in pairs(vehicle.owned_by) do
                    if (ent == name) then
                        ENT[name].owned[vehicle.category][vehicle.model] = vehicle
                        found = true
                        break
                    end
                end
                if (not found) then
                    ENT[name].not_owned[vehicle.category][vehicle.model] = vehicle
                end
            end
        end
    end
end

function AssignCategoriesToEnterprises()
    for name, _ in pairs(ENT) do
        ENT[name].owned     = {}
        ENT[name].not_owned = {}
        for cat, _ in pairs(Cat) do
            ENT[name].owned[cat]     = {}
            ENT[name].not_owned[cat] = {}
        end
    end
end

function PopulateCategoryTable(categories)
    print('ARP_cardealer> Populating tables for all categories.')
    for _, categorie in ipairs(categories) do
        Cat[categorie.name] = categorie
    end
    return
end

function PopulateCarTable(cars)
    print('ARP_cardealer> Populating tables for all cars.')
    for _, car in ipairs(cars) do
        Car[car.name] = car
        Car[car.name].owned_by = json.decode(Car[car.name].owned_by)
    end
    return
end

function PopulateEnterpriseTable(cardealers)
    print('ARP_Cardealer> Populating tables for all enterprises.')
    for _, cardealer in ipairs(cardealers) do
        ENT[cardealer.name] = {}
    end
    return
end

MySQL.ready(function()
	local cardealers    = MySQL.Sync.fetchAll('SELECT name from enterprises WHERE jobname = @job', {
        ['@job'] = 'cardealer'
    })
    local cars          = MySQL.Sync.fetchAll('SELECT * from cardealer_catalog', {})
    local categories    = MySQL.Sync.fetchAll('SELECT * from cardealer_category', {})

    PopulateEnterpriseTable(cardealers)
    PopulateCarTable(cars)
    PopulateCategoryTable(categories)
    AssignCategoriesToEnterprises()
    AssignCarToEnterprises()
end)