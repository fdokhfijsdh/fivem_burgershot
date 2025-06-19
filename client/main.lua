local listOfCustomers = {}
local isThreadRunning, isMarkerVisible = false, false

local nuiState = {
    isVisible = false,
    lastToggle = 0,
    cooldown = 1000 -- 1 second cooldown between toggles
}

local function setDisplay(bool)
    local currentTime = GetGameTimer()

    -- Check cooldown
    if currentTime - nuiState.lastToggle < nuiState.cooldown then
        return
    end

    -- Update state
    nuiState.isVisible = bool
    nuiState.lastToggle = currentTime

    -- Set NUI focus and send message
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })

    if bool then
        ExecuteCommand('e tablet2')
    else
        exports['rpemotes-reborn']:EmoteCancel()
    end
end

local function startThread()
    while true do
        for _, location in pairs(Config_Burgershot.Order_Positions) do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - location)

            if distance < 10.0 then
                DrawMarker(
                    Config_Burgershot.Markers['order_positions'].type, location.x, location.y, location.z,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    Config_Burgershot.Markers['order_positions'].scale.x, Config_Burgershot.Markers['order_positions'].scale.y, Config_Burgershot.Markers['order_positions'].scale.z,
                    Config_Burgershot.Markers['order_positions'].color.r, Config_Burgershot.Markers['order_positions'].color.g, Config_Burgershot.Markers['order_positions'].color.b,
                    100, Config_Burgershot.Markers['order_positions'].upDown, true, 2, Config_Burgershot.Markers['order_positions'].rotate, nil, nil, false
                )
            end

            if distance < 0.5 then
                ESX.ShowHelpNotification(Config_Burgershot.Messages.helpNotify)
                if IsControlJustReleased(1, 38) then -- E key
                    ESX.TriggerServerCallback('fdokhfijsdh_burgershot:isNewCustomerAllreadyACustomer', function(isCustomer)
                        if isCustomer then
                            TriggerEvent(Config_Burgershot.NotifyEvent, {
                                title = Config_Burgershot.Messages.successAbortOrder.title,
                                text = Config_Burgershot.Messages.successAbortOrder.text,
                                type = Config_Burgershot.Messages.successAbortOrder.type,
                                time = Config_Burgershot.Messages.successAbortOrder.time
                            })
                            TriggerServerEvent('fdokhfijsdh_burgershot:removeCustomer')
                            isMarkerVisible = false
                        else
                            TriggerEvent(Config_Burgershot.NotifyEvent, {
                                title = Config_Burgershot.Messages.successRequestOrder.title,
                                text = Config_Burgershot.Messages.successRequestOrder.text,
                                type = Config_Burgershot.Messages.successRequestOrder.type,
                                time = Config_Burgershot.Messages.successRequestOrder.time
                            })
                            TriggerServerEvent('fdokhfijsdh_burgershot:addCustomer')
                            isMarkerVisible = true
                        end
                    end)
                end
            end
        end

        -- Check if we're a customer and need to be removed
        if isMarkerVisible then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            -- Check all order positions
            local shouldRemove = true
            for _, location in pairs(Config_Burgershot.Order_Positions) do
                local distance = #(playerCoords - location)
                if distance <= 15.0 then
                    shouldRemove = false
                    break
                end
            end

            if shouldRemove then
                TriggerEvent(Config_Burgershot.NotifyEvent, {
                    title = Config_Burgershot.Messages.successAbortOrder.title,
                    text = Config_Burgershot.Messages.successAbortOrder.text,
                    type = Config_Burgershot.Messages.successAbortOrder.type,
                    time = Config_Burgershot.Messages.successAbortOrder.time
                })
                TriggerServerEvent('fdokhfijsdh_burgershot:removeCustomer')
                isMarkerVisible = false
            end
        end

        -- Draw markers for staff members
        for _, targetJob in pairs(Config_Burgershot.listOfJobsThatMarkCustomer) do
            if ESX.PlayerData.job.name == targetJob then
                if listOfCustomers then
                    for _, customer in pairs(listOfCustomers) do
                        local customerCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(customer)))

                        DrawMarker(
                            Config_Burgershot.Markers['mark_customer'].type, customerCoords.x, customerCoords.y, customerCoords.z + 1.3,
                            0.0, 0.0, 0.0, 0.0, 180.0, 0.0,
                            Config_Burgershot.Markers['mark_customer'].scale.x, Config_Burgershot.Markers['mark_customer'].scale.y, Config_Burgershot.Markers['mark_customer'].scale.z,
                            Config_Burgershot.Markers['mark_customer'].color.r, Config_Burgershot.Markers['mark_customer'].color.g, Config_Burgershot.Markers['mark_customer'].color.b,
                            100, Config_Burgershot.Markers['mark_customer'].upDown, true, 2, Config_Burgershot.Markers['mark_customer'].rotate, nil, nil, false
                        )
                    end
                end
            end
        end

        Citizen.Wait(0)
    end
end

AddEventHandler('esx:playerLoaded', function()
    if not isThreadRunning then
        Citizen.CreateThread(startThread)
        isThreadRunning = true
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    if not isThreadRunning then
        Citizen.CreateThread(startThread)
        isThreadRunning = true
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    -- Clean up NUI state
    if nuiState.isVisible then
        setDisplay(false)
    end
end)

RegisterNetEvent('fdokhfijsdh_burgershot:updateCustomerList')
AddEventHandler('fdokhfijsdh_burgershot:updateCustomerList', function(newCustomerList)
    listOfCustomers = newCustomerList
end)

RegisterCommand('burgershot', function()
    for _, job in pairs(Config_Burgershot.listOfJobsThatMarkCustomer) do
        if ESX.PlayerData.job.name == job then
            setDisplay(not nuiState.isVisible)
            return
        end
    end
end, false)
RegisterKeyMapping('burgershot', "BurgerShot Tablet öffnen", 'keyboard', 'F6')

RegisterNUICallback('exit-button', function(data, cb)
    setDisplay(false)
    cb('ok')
end)