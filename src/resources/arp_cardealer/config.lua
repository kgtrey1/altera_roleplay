--
-- ALTERA PROJECT, 2020
-- arp_cardealer
-- File description:
-- Configuration file
--

Config = {}

Config.Blip = {
    color   = 0,
    sprite  = 0,
    text    = "Concessionnaire"
}

Config.Enterprises = {
    {
        name = 'concess1',
        shared = {
            sale = vector3(1155.12, 2248.14, 49.1),
            bpos = vector3(100, 100, 100)
        }
    },
    {
        name = 'concess2',
        shared = {
            sale = vector3(-100, -100, -100),
            bpos = vector3(100, 100, 100)
        }     
    }
}