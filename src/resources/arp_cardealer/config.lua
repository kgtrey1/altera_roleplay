--
-- ALTERA PROJECT, 2020
-- arp_cardealer
-- File description:
-- Configuration file
--

Config = {}

Config.DrawDistance = 50

Config.Enterprises = {
    {
        name = 'concess1',
        blip = {
            main = {
                pos     = vector3(1155.12, 2248.14, 49.1),
                color   = 0,
                sprite  = 326,
                text    = "Concession ma bite"
            },
            sale = {
                pos     = vector3(1155.12, 2248.14, 49.1),
                color   = 0,
                sprite  = 200,
                text    = "Euro Motorsport Deluxe à vendre"
            }
        },
        point = {
            {
                name = "menu",
                pos = vector3(1142.60, 2274.03, 48.50)
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
        point = {
            {
                name = "menu",
                pos = vector3(0, 0, 0)
            }
        },
        boss = vector3(1155.12, 2248.14, 49.1)
    }
}