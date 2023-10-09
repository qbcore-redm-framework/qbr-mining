local sharedItems = exports['qbr-core']:GetItems()

local function GenerateRandomItem()
    local itemTypes = {}
    for item, _ in pairs(Config.SmeltingItems) do
        table.insert(itemTypes, item)
    end

    -- Choose a random item type
    local randomItemType = itemTypes[math.random(1, #itemTypes)]

    -- Get the minimum and maximum values for the chosen item
    local min = Config.SmeltingItems[randomItemType].Min
    local max = Config.SmeltingItems[randomItemType].Max

    -- Generate a random number within the specified range
    local randomAmount = math.random(min, max)

    -- Return the random item and amount
    return randomItemType, randomAmount
end

RegisterServerEvent('qbr-mining:server:ReceivedItem', function ()
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
    if not Player then TriggerClientEvent('QBCore:Notify', src, 3, Lang:t('error.general'), 5000) return end
    local itemType, itemAmount = GenerateRandomItem()
    if Player.Functions.AddItem(itemType, itemAmount) then
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[itemType], "add")
	    TriggerClientEvent('QBCore:Notify', src, 2, Lang:t('mining.success', {text = itemType}), 5000)
    else
        TriggerClientEvent('QBCore:Notify', src, 3, Lang:t('error.add_item'), 5000)
    end

end)

RegisterServerEvent('qbr-mining:server:SellItem', function (itemType, itemAmount, buyPrice)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
    if not Player then TriggerClientEvent('QBCore:Notify', src, 3, Lang:t('error.general'), 5000) return end
    if Player.Functions.RemoveItem(itemType, itemAmount) then
        Player.Functions.AddMoney('cash', tonumber(itemAmount * buyPrice))
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[itemType], "remove")
        TriggerClientEvent('QBCore:Notify', src, 2, Lang:t('mining.selling', {amount = itemAmount, item = itemType}), 5000)
    else
        TriggerClientEvent('QBCore:Notify', src, 3, Lang:t('error.remove_item'), 5000)
    end
end)

RegisterServerEvent('qbr-mining:server:BuyItem', function (itemType, itemAmount, buyPrice)
    local src = source
    local Player = exports['qbr-core']:GetPlayer(src)
    if not Player then TriggerClientEvent('QBCore:Notify', src, 3, Lang:t('error.general'), 5000) return end
    if Player.Functions.RemoveMoney('cash', tonumber(itemAmount * buyPrice)) then
        Player.Functions.AddItem(itemType, itemAmount)
        TriggerClientEvent('inventory:client:ItemBox', src, sharedItems[itemType], "add")
        TriggerClientEvent('QBCore:Notify', src, 2, Lang:t('mining.bought', {amount = itemAmount, item = itemType}), 5000)
    else
        TriggerClientEvent('QBCore:Notify', src, 3, Lang:t('error.money'), 5000)
    end
end)