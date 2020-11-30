--
-- ALTERA PROJECT, 2020
-- ARP_Stylizer
-- File description:
-- Configuration file.
--

Config = {}

Config.Shops = {
	{ type = 'barbershop', coords = vector3(0, 0, 0), point = {} },
	{ type = 'clotheshop', coords = vector3(0, 0, 0), point = {} }
}

Config.List = {}

Config.Textured = {
	{ name = 'tshirt_1', 		texture = 'tshirt_2'	},
	{ name = 'torso_1',  		texture = 'torso_2'		},
	{ name = 'pants_1',			texture = 'pants_2'		},
	{ name = 'shoes_1', 		texture = 'shoes_2'		},
	{ name = 'mask_1',			texture = 'mask_2'		},
	{ name = 'bproof_1', 		texture = 'bproof_2'	},
	{ name = 'chain_1',			texture = 'chain_2'		},
	{ name = 'helmet_1',		texture = 'helmet_2'	},
	{ name = 'glasses_1',		texture = 'glasses_2'	},
	{ name = 'watches_1',		texture = 'watches_2'	},
	{ name = 'bracelets_1',		texture = 'bracelets_2'	},
	{ name = 'bags_1',			texture = 'bags_2'		},
	{ name = 'ears_1',			texture = 'ears_1'		}
}

Config.List.Clothes = {
	'tshirt_1', 'torso_1', 'arms', 'pants_1', 'shoes_1', 'chain_1', 'bracelets_1'
}

Config.Restricted = {
	{
		name = 'chain_1', 		prices = { 
			-1, -1, -1, -1, -1, -1, -1, -1, -1, 15, 8, 13, -1, -1, -1, -1, 35, 15, 13, -1,
			15, 8, 13, -1, -1, -1, -1, -1, -1, 40, 40, 10, -1, 36, 36, 5, 17, 15, 13, -1,
			-1, 85, 69, 46, 105, 92, 100, 125, 78, 59, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 60, 55, 67, 65, 69,
			74, 78, 66, 72, 80, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 75, 75, 119, 10, 30, 160, -1, 13, 8,
			71, 74, 77, 78, -1, 30, -1, -1, -1, -1, 55, 50, 52
		}
	},
	{
		name = 'bracelets_1', 	prices = {
			350, 80, 120, 570, 185, 30, 54
		}
	},
	{
		name = 'watches_1', 	prices = {
			250, -1, 30, 349, 265, 268, 110, 299, 69, 80, 133, 170, 90, 57, 62, 365, 89, 38,
			50, 41, 93, 126, 350, 80, 120, 570, 185, 30, 54
		}
	},
	{
		name = 'shoes_1',		prices = {
			38, 42, 60, 55, 15, 20, 40, 48, 53, 160, 230, 67, -1, 75, 196, 15, -1, 159, -1, 342,
			225, 30, 72, -1, -1, 43, -1, 80, -1, 99, 69, 73, -1, -1, 45, 125, 40, 35, -1, 145, -1,
			42, 56, 40, 35, 43, -1, 39, 39, 75, 57, 73, 86, 55, 245, 115, 64, -1, 53, 71, 56, 74, 52,
			-1, 109, 89, -1, -1, 57, 84, 57, 78, 52, 65, 59, 51, 38, -1, -1, -1, 84, 66, -1, -1, -1,
			-1, -1, 169, -1, -1
		}
	},
	{
		name = 'pants_1',		prices = {
			15, -1, 20, 25, 20, 13, 17, 18, 16, 33, -1, 14, 34, 10, 14, 12, 13, 11, 24, 28, -1, -1,
			32, 35, 27, 39, 18, 32, -1, -1, 24, -1, -1, -1, -1, -1, -1, 15, -1, -1, -1, 15, 16, -1,
			21, 30, 36, 39, 41, 34, -1, 37, -1, 16, 12, 11, -1, 17, -1,   21, 12, 18, -1, 15, 19, 24,
			29, -1, 24, -1, 13, -1, 15, -1, 15, 16, 59, 27, 25, 24, 22, 19, 16, -1, -1, 17, -1, 15, 28,
			31, 26, 20, -1, 28, -1, 17, -1, 21, 16, 18, 13, 22, 20, -1, 43, -1, -1, -1, -1, -1, -1, -1, -1, -1
		}
	},
	{
		name = 'tshirt_1',		prices = {
			9, -1, 159, 165, 11, -1, -1, -1, 17, -1, -1, -1, 45, -1, -1, 9, 10, -1, -1, -1, 49, -1, 14, -1, 158,
			160, 47, 65, 39, -1, 49, 47, -1, -1, -1, -1, -1, 9, -1, -1, 19, 14, 19, -1, -1, -1, 11, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 90, -1, -1, -1, 39, -1, -1, 27, -1, -1, -1, 10,
			-1, -1, -1, -1, 11, 17, -1, -1, -1, -1, -1, -1, -1, 69, 135, 115, -1, 73, 76, -1, -1, 21, -1, -1, 25,
			-1, -1, -1, -1, -1, -1, -1, 26, -1, -1, 16, -1, -1, 18, -1, 26, -1, -1, 23, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, 25, -1, -1, 29, -1, -1, 19, -1, -1, 23, -1, -1

		}
	},
	{
		name = 'torso_1',		prices = {
			-1, -1, 15, 50, 15, 35, 27, 19, 16, 90, 40, 49, 47, 31, -1, 13, -1, -1, 67, 149, 70, 16, 64, 69, 57, 53,
			79, 68, 95, 109, 92, 104, -1, 10, 70, -1, 29, 19, 13, 49, 34, -1, -1, 12, -1, -1, -1, -1, -1, 60, -1, -1,
			31, -1, -1, -1, -1, -1, 39, 42, 28, -1, -1, -1, 19, -1, -1, 38, 36, 270, -1, 179, 90, 70, 67, 125, 190, 35,
			-1, 17, 13, 18, 20, 25, -1, 31, 33, 35, 20, -1, -1, 39, 17, -1, -1, -1, 16, -1, 99, 101, 89, 92, -1, -1, -1,
			-1, 59, 209, -1, -1, 35, -1, 20, -1, -1, -1, 26, 23, 89, 79, 36, 30, 18, -1, -1, 29, 27, 14, -1, -1, -1, -1,
			-1, 37, 18, 43, 23, 67, -1, 110, 22, 56, 29, 21, 199, 19, 49, 52, -1, 24, 30, -1, 30, 26, -1, 30, 26, 24, 20,
			15, 27, 24, -1, 19, -1, 34, 55, 27, 37, 39, 26, 32, 35, 32, 30, -1, -1, 89, 21, 19, 29, 26, 69, 54, 34, -1,
			26, 39, 36, 23, 61, 46, 19, -1, -1, -1, -1, -1, -1, 39, -1, 33, 38, 26, 30, 37, 40, 29, 43, 41, 46, 56, -1, -1,
			30, 27, 25, 27, 32, 40, 42, 48, 39, 43, 20, -1, 35, -1, -1, -1, -1, 24, 26, 23, 19, -1, -1, 25, 29, 410, 19, -1,
			35, 27, 18, -1, -1, 34, 25, 27, 32, -1, 36, -1, 28, 47, 28, 50, 22, 47, 49, 32, 34, 29, 24, 22, 39, -1, 67, 40, 26,
			-1, 19, -1, -1, -1, -1, -1, 38, 39, -1, -1, -1, -1, -1, -1, -1, -1, -1
		}
	}
}