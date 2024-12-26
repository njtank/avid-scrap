local QBCore = exports['qb-core']:GetCoreObject()

local ITEM_REWARDS = {
    "plastic",
    "electronics",
    "metalscrap",
    "rubber",
    "glass",
    "leather"
}

local COOLDOWN = 8 

RegisterNetEvent("salvage:giveItem", function()
    local src = source
    local reward = ITEM_REWARDS[math.random(#ITEM_REWARDS)]
    local amount = math.random(1, 3)

    
    local success = exports.ox_inventory:AddItem(src, reward, amount)

    if success then
        TriggerClientEvent('QBCore:Notify', src, "You received " .. amount .. "x " .. reward, "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Failed to add item to your inventory", "error")
    end
end)

