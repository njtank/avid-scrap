local QBCore = exports['qb-core']:GetCoreObject()
local scrappingCooldown = false
local activeSalvage = false

local PED_MODEL = "s_m_m_dockwork_01"
local PED_COORDS = vec3(2369.87, 3156.74, 48.21) 
local PED_HEADING = 41.79

local SALVAGE_LOCATIONS = {
    {coords = vec3(2405.42, 3118.98, 49.41), radius = 2.0},
    {coords = vec3(2409.79, 3115.95, 49.3), radius = 2.0},
    {coords = vec3(2412.51, 3118.41, 49.7), radius = 2.0},
    {coords = vec3(2410.71, 3122.52, 49.63), radius = 2.0},
    {coords = vec3(2416.01, 3125.31, 49.4), radius = 2.0},
    {coords = vec3(2417.12, 3122.92, 48.6), radius = 2.0},
    {coords = vec3(2416.13, 3120.36, 48.68), radius = 2.0},
    {coords = vec3(2416.69, 3117.87, 48.51), radius = 2.0},
    {coords = vec3(2416.0, 3115.38, 49.87), radius = 2.0},
    {coords = vec3(2399.28, 3139.09, 49.56), radius = 2.0},
    {coords = vec3(2397.63, 3142.29, 48.39), radius = 2.0},
    {coords = vec3(2402.59, 3144.59, 49.6), radius = 2.0},
    {coords = vec3(2409.08, 3145.74, 49.59), radius = 2.0},
    {coords = vec3(2411.34, 3148.44, 49.44), radius = 2.0},
    {coords = vec3(2414.47, 3150.54, 49.34), radius = 2.0},
    {coords = vec3(2406.82, 3152.77, 49.7), radius = 2.0},
    {coords = vec3(2401.84, 3150.94, 48.56), radius = 2.0},
    {coords = vec3(2403.02, 3153.53, 49.68), radius = 2.0},
}


CreateThread(function()
    RequestModel(PED_MODEL)
    while not HasModelLoaded(PED_MODEL) do
        Wait(0)
    end

    local ped = CreatePed(4, PED_MODEL, PED_COORDS.x, PED_COORDS.y, PED_COORDS.z - 1, PED_HEADING, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

    exports.ox_target:addLocalEntity(ped, {
        {
            name = "start_scrapping",
            icon = "fa-solid fa-wrench",
            label = "Start Scrapping",
            onSelect = function()
                activeSalvage = true
                QBCore.Functions.Notify("You can now scrap vehicles!")
            end
        }
    })
end)


CreateThread(function()
    for _, location in pairs(SALVAGE_LOCATIONS) do
        exports.ox_target:addSphereZone({
            coords = location.coords,
            radius = location.radius,
            options = {
                {
                    name = "scrap_vehicle",
                    icon = "fa-solid fa-screwdriver",
                    label = "Scrap",
                    canInteract = function()
                        return activeSalvage and not scrappingCooldown
                    end,
                    onSelect = function()
                        scrapVehicle(location.coords)
                    end
                }
            }
        })
    end
end)

function scrapVehicle(coords)
    scrappingCooldown = true

    local playerPed = PlayerPedId()
    local animDict = "mini@repair"
    local animName = "fixing_a_ped"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end

    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 13000, 1, 0, false, false, false)

    QBCore.Functions.Progressbar("scrap_vehicle", "Scrapping vehicle...", 13000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Success
        ClearPedTasks(playerPed)
        TriggerServerEvent("salvage:giveItem")
    end, function() -- Cancel
        ClearPedTasks(playerPed)
    end)

    Wait(8000) -- Cooldown
    scrappingCooldown = false
end

