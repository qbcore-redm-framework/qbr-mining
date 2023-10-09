Config = {}

Config.Keys = {
    Action = 0xCEFD9220, -- E
    Interact = 0xF3830D8E -- J
}

Config.MiningTimer = 20 * 1000 -- 20 second timer
Config.RefreshTimer = 30 * 6000 -- 30 minute timer, after this all mined position will be resetted for work again.

Config.MineCord = vector3(2789.1987, 1340.2327, 71.3155)

Config.SmeltingItems = { -- Min and Max are value to generate random item amount when mining will end, you can add more items.
    ['iron'] = {Min = 1, Max = 10},
    ['copper'] = {Min = 1, Max = 10},
    ['gold'] = {Min = 1, Max = 10},
    ['coal'] = {Min = 1, Max = 10},
}

Config.MiningLocations = {
    {coords = vector3(2747.63, 1388.7, 69.01)},
	{coords = vector3(2746.66, 1379.09, 68.55)},
    {coords = vector3(2724.04, 1388.7, 68.82)},
    {coords = vector3(2727.67, 1385.56, 69.22)},
    {coords = vector3(2723.16, 1375.39, 68.89)},
    {coords = vector3(2743.93, 1385.92, 68.7)},
    {coords = vector3(2760.84, 1402.35, 68.74)},
    {coords = vector3(2760.91, 1395.98, 68.7)},
    {coords = vector3(2771.02, 1382.77, 67.98)},
    {coords = vector3(2763.33, 1376.24, 67.83)},
    {coords = vector3(2754.61, 1358.63, 68.17)},
    {coords = vector3(2752.92, 1368.36, 67.8)},
    {coords = vector3(2758.53, 1379.4, 68.24)},
    {coords = vector3(2757.53, 1382.55, 68.2)},
    {coords = vector3(2747.99, 1382.55, 68.61)},
    {coords = vector3(2747.38, 1391.84, 68.76)},
    {coords = vector3(2761.37, 1390.62, 68.71)},
    {coords = vector3(2759.16, 1408.6, 68.5)},
    {coords = vector3(2728.11, 1329.45, 69.62)},
    {coords = vector3(2731.87, 1332.42, 69.64)},
    {coords = vector3(2716.82, 1308.1, 69.78)},
    {coords = vector3(2712.96, 1308.03, 69.77)},
    {coords = vector3(2716.45, 1313.86, 69.73)},
    {coords = vector3(2746.23, 1366.28, 68.42)},
}

Config.CollectItems = true -- if true then if you have items in your inventory that match with list Config.Peds.Items, then you will be able to sell
-- all in one time.
Config.Peds = {
    Miners = {Label = 'Miners', Hash = 1543787725, Coords = vector4(2789.31, 1336.87, 71.35, 9.15),
        Items = {['iron'] = 100, ['copper'] = 150, ['gold'] = 200, ['coal'] = 250}, -- items with their price that this ped will buy from players, can be empty
        BuyableItems = {['pickaxe'] = 100} -- items with their price that this ped will sell to players, can be empty
    },
}


