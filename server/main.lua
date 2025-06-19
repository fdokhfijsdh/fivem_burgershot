local currentCustomer = {}

RegisterServerEvent('fdokhfijsdh_burgershot:addCustomer')
AddEventHandler('fdokhfijsdh_burgershot:addCustomer', function()
    local src = source
    local xCustomer = ESX.GetPlayerFromId(src)
    local allPlayers = GetPlayers()

    table.insert(currentCustomer, xCustomer.source)

    -- Update all relevant players
    for _, singlePlayer in ipairs(allPlayers) do
        local xPlayer = ESX.GetPlayerFromId(singlePlayer)

        for _, targetJob in pairs(Config_Burgershot.listOfJobsThatMarkCustomer) do
            if xPlayer.getJob().name == targetJob then
                TriggerClientEvent('fdokhfijsdh_burgershot:updateCustomerList', xPlayer.source, currentCustomer)
            end
        end
    end
end)

RegisterServerEvent('fdokhfijsdh_burgershot:removeCustomer')
AddEventHandler('fdokhfijsdh_burgershot:removeCustomer', function()
    local src = source
    local xCustomer = ESX.GetPlayerFromId(src)
    local allPlayers = GetPlayers()

    -- Remove the customer from the table
    for i, customerId in ipairs(currentCustomer) do
        if customerId == xCustomer.source then
            table.remove(currentCustomer, i)
            break
        end
    end

    -- Update all relevant players
    for _, singlePlayer in ipairs(allPlayers) do
        local xPlayer = ESX.GetPlayerFromId(singlePlayer)

        for _, targetJob in pairs(Config_Burgershot.listOfJobsThatMarkCustomer) do
            if xPlayer.getJob().name == targetJob then
                TriggerClientEvent('fdokhfijsdh_burgershot:updateCustomerList', xPlayer.source, currentCustomer)
            end
        end
    end
end)

ESX.RegisterServerCallback('fdokhfijsdh_burgershot:isNewCustomerAllreadyACustomer', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local isCustomer = false

    for _, customerId in ipairs(currentCustomer) do
        if customerId == xPlayer.source then
            isCustomer = true
            break
        end
    end

    cb(isCustomer)
end)