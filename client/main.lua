local MiningLocation = {}

--#region Functions

local function AddBlipForCoords(blipname, bliphash, coords)
	local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, coords)
	SetBlipSprite(blip, bliphash, true)
	SetBlipScale(blip, 0.2)
    if blipname then
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipname)
    end
end

local function IsWeaponLantern(weaponhash)
    return Citizen.InvokeNative(0x79407D33328286C6, weaponhash)
end

local function GetPedCurrentHeldWeapon(ped)
    return Citizen.InvokeNative(0x8425C5F057012DAB, ped)
end

local function OpenMenu(name)
    local options = {}
    local inputs = {}

    -- Check if Config.Peds[name].Items is not empty
    if next(Config.Peds[name].Items) then
        for item, _ in pairs(Config.Peds[name].Items) do
            if Config.CollectItems then
                local amount = exports['qbr-inventory']:GetItemAmount(item)
                if amount then
                    table.insert(options, {value = item..' : '..amount, text = string.upper(item)..' : '..amount..' (QTY)'})
                end
            else
                table.insert(options, {value = item, text = string.upper(item)..' (SELL)'})
            end
        end
    end

    -- Check if Config.Peds[name].BuyableItems is not empty
    if next(Config.Peds[name].BuyableItems) then
        for item, _ in pairs(Config.Peds[name].BuyableItems) do
            table.insert(options, {value = item, text = string.upper(item)..' (BUY)'})
        end
    end

    if #options == 0 then
        print("no options avaible for ped "..name) return
    end

    -- Create inputs based on the options generated
    if Config.CollectItems then
        if next(Config.Peds[name].Items) and next(Config.Peds[name].BuyableItems) or next(Config.Peds[name].BuyableItems) then
            inputs = {
                {
                    text = Lang:t('menu.select'),
                    name = "SellGoodsCol",
                    type = "select",
                    options = options
                },
                {
                    text = Lang:t('menu.amount'),
                    name = "ItemAmountCol",
                    type = "number",
                    isRequired = false
                }
            }
        else
            if next(Config.Peds[name].Items) then
                inputs = {
                    {
                        text = Lang:t('menu.select'),
                        name = "SellGoodsCol",
                        type = "select",
                        options = options
                    }
                }
            end
        end
    else
        inputs = {
            {
                text = Lang:t('menu.select'),
                name = "SellGoodsNc",
                type = "select",
                options = options
            },
            {
                text = Lang:t('menu.amount'),
                name = "ItemAmountNc",
                type = "number",
                isRequired = true
            }
        }
    end

    local dialog = exports['qbr-input']:ShowInput({
        header = name..'-Shop',
        submitText = "Submit",
        inputs = inputs,
    })

    if dialog == nil then return end
    local values = {}
    for _, object in pairs(dialog) do
        if object ~= "" then
            for value in string.gmatch(object, "[^:%s]+") do
                table.insert(values, value)
            end
        end
    end
    if next(values) == nil then return end
    local itemType, itemAmount = values[1], values[2]
    local buyPrice = Config.Peds[name].Items[itemType] or Config.Peds[name].BuyableItems[itemType]
    if itemAmount == nil then
        exports['qbr-core']:Notify(2, Lang:t('error.amount', {text = itemType}), 5000) return
    end
    if Config.Peds[name].BuyableItems[itemType] then
        TriggerServerEvent('qbr-mining:server:BuyItem', itemType, itemAmount, buyPrice)
    else
        TriggerServerEvent('qbr-mining:server:SellItem', itemType, itemAmount, buyPrice)
    end

end

local function StartMining(data)
    local MiningPoint = data
    if MiningLocation[MiningPoint] == nil or next(MiningLocation[MiningPoint]) == nil then
        MiningLocation[MiningPoint] = {IsMined = false}
    end
    if not MiningLocation[MiningPoint].IsMined then
        exports['qbr-core']:TriggerCallback('QBCore:HasItem', function(HasItem)
            if HasItem then
                local PedId = PlayerPedId()
                SetCurrentPedWeapon(PedId, `WEAPON_UNARMED`, true)
                TaskStartScenarioInPlace(PedId, GetHashKey('WORLD_HUMAN_PICKAXE_WALL'), -1, true, false, false, false)
                exports['qbr-core']:Progressbar("start_mining", Lang:t('mining.progress'), Config.MiningTimer, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                {
                    animDict = {},
                    anim = {},
                    flags = {},
                }, {}, {}, function() -- Done
                    Wait(1000)
                    ClearPedTasks(PedId)
                    SetCurrentPedWeapon(PedId, `WEAPON_UNARMED`, true)
                    MiningLocation[MiningPoint] = {IsMined = true}
                    TriggerServerEvent('qbr-mining:server:ReceivedItem')
                end, function() -- Cancel
                    Wait(1000)
                    ClearPedTasks(PedId)
                    SetCurrentPedWeapon(PedId, `WEAPON_UNARMED`, true)
                end)
            else
                exports['qbr-core']:Notify(3, Lang:t('error.pickaxe'), 5000)
            end
        end,  { ['pickaxe'] = 1 })
    else
        exports['qbr-core']:Notify(3, Lang:t('error.mined'), 5000)
    end
end

--#endregion

RegisterNetEvent('qbr-mining:client:Mining', function (location)
    StartMining(location)
end)

RegisterNetEvent('qbr-mining:client:OpenMenu', function (name)
    OpenMenu(name)
end)



--#region Threads

Citizen.CreateThread(function()
	while true do
		Wait(Config.RefreshTimer)
        MiningLocation = {}
	end
end)

Citizen.CreateThread(function ()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local hash = GetPedCurrentHeldWeapon(ped)
        if IsWeaponLantern(hash) then
            for _, v in ipairs(Config.MiningLocations) do
                local distance = #(pos - v.coords)
                if distance < 5.0 then
                    Citizen.InvokeNative(0x2A32FAA57B937173, 0x07DCE236, v.coords-0.9, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 99, 23, 23, 150, 0, 0, 2, 0, 0, 0, 0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function ()
    AddBlipForCoords(Lang:t('mining.entrance'), GetHashKey('blip_gold'), Config.MineCord)

    if next(Config.MiningLocations) then
        for k, v in pairs(Config.MiningLocations) do
            exports['qbr-core']:createPrompt('Zone_'..k, v.coords, Config.Keys.Action, Lang:t('mining.start') .. 'Zone_'..k, {
                type = 'client',
                event = 'qbr-mining:client:Mining',
                args = {k},
            })
            AddBlipForCoords(Lang:t('mining.zone'), GetHashKey('blip_deadeye_cross'), v.coords)
        end
    end
end)

--#endregion