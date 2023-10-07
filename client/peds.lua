local CreatedPed = {}

CreateThread(function()
    if next(Config.Peds) then
        for k, v in pairs(Config.Peds) do
            RequestModel(v.Hash)
            while (not HasModelLoaded(v.Hash)) do
                Wait(1)
            end
            AddBlipForCoords(v.Label, GetHashKey('blip_ambient_hitching_post'), vector3(v.Coords))
            exports['qbr-core']:createPrompt(k, vector3(v.Coords), Config.Keys.Interact, Lang:t('menu.open') .. v.Label, {
                type = 'client',
                event = 'qbr-mining:client:OpenMenu',
                args = {k},
            })
            k = CreatePed(v.Hash, v.Coords)
            SetBlockingOfNonTemporaryEvents(k, true)
            SetPedCanPlayAmbientAnims(k, true)
            SetPedCanRagdollFromPlayerImpact(k, false)
            SetPedOutfitPreset(k, true, false)
            Citizen.InvokeNative(0x283978A15512B2FE, k, true) -- SetRandomOutfitVariation
            SetEntityAsMissionEntity(k, true, false)
            RequestCollisionAtCoord(vector3(v.Coords))
            SetEntityInvincible(k, true)
            table.insert(CreatedPed, k)
        end
    end
end)

local function DeleteCreatedPeds()
    for _, ped in ipairs(CreatedPed) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
    CreatedPed = {}
end

local function DeletePrompt()
    for name, _ in ipairs(Config.Peds) do
        exports['qbr-core']:deletePrompt(name)
    end
    for id, _ in ipairs(Config.MiningLocations) do
        exports['qbr-core']:deletePrompt('Zone_'..id)
    end
end


AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteCreatedPeds()
        DeletePrompt()
    end
end)
