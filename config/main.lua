Config_Burgershot = {
    NotifyEvent = 'planethope_core:sendNotifyToPlayer',
    listOfJobsThatMarkCustomer = { 'burgershot' },

    Markers = {
        ['order_positions'] = {
            type = 29,
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 0, g = 128, b = 255 },
            rotate = true,
            upDown = false,
        },

        ['mark_customer'] = {
            type = 2,
            scale = { x = 0.35, y = 0.35, z = 0.35 },
            color = { r = 0, g = 128, b = 255 },
            rotate = false,
            upDown = true,
        },
    },

    Order_Positions = {
        vector3(-1190.0096, -895.5197, 13.9878),
        vector3(-1191.2399, -893.8860, 13.9878),
        vector3(-1193.8628, -891.6618, 13.9878),
    },

    Messages = {
        successAbortOrder = {
            title = "Burger Shot",
            text = "Du hast die Bestellanfrage abgebrochen.",
            type = 'error',
            time = 5000,
        },

        successRequestOrder = {
            title = "Burger Shot",
            text = "Du hast dich erfolgreich fürs Bestellen gemeldet.",
            type = 'success',
            time = 5000,
        },

        helpNotify = "Drücke E, um dich fürs Bestellen zu melden.",
    },
}