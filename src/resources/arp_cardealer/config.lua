--
-- ALTERA PROJECT, 2020
-- arp_cardealer
-- File description:
-- Configuration file
--

Config = {}

Config.Enterprises = {
    {
        name = 'concess1',
        blip = {
            main = {
                pos     = vector3(1155.12, 2248.14, 49.1),
                color   = 0,
                sprite  = 326,
                text    = "Concession"
            },
            sale = {
                pos     = vector3(1155.12, 2248.14, 49.1),
                color   = 0,
                sprite  = 200,
                text    = "Concession à vendre"
            }
        },
        boss = vector3(1155.12, 2248.14, 49.1)
    },
    {
        name = 'concess2',
        blip = {
            main = {
                pos     = vector3(0, 0, 0),
                color   = 0,
                sprite  = 326,
                text    = "Concession"
            },
            sale = {
                pos     = vector3(0, 0, 0),
                color   = 0,
                sprite  = 200,
                text    = "Concession à vendre"
            }
        },
        boss = vector3(1155.12, 2248.14, 49.1)
    }
}