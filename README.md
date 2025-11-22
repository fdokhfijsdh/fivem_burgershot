# BurgerShot (ESX) — Customer Queue + NUI Tablet

Lightweight BurgerShot job helper for ESX:
- Customers can “queue” at the counter by pressing E at configured locations.
- Staff see live customer markers and can open a tablet UI (F6) to view a menu and build orders (local-only).

## Features
- Configurable counter locations and marker styles via [`Config_Burgershot`](config/main.lua).
- Customer self-service queue: press E to join/leave.
- Staff-only NUI tablet toggle (command + keybind).
- Live client markers for queued customers.

## Requirements
- ESX (es_extended)
- oxmysql (declared; not directly used in current version)
- rpemotes-reborn (optional, used for the “tablet” emote and cancel)

## Installation
1. Place the resource folder in your server resources.
2. Ensure dependencies load before this resource.
3. In server.cfg:
   ```
   ensure es_extended
   ensure oxmysql
   ensure rpemotes-reborn
   ensure fivem_burgershot
   ```
4. Verify fxmanifest: [fxmanifest.lua](fxmanifest.lua)

## Usage
- Customer:
  - Go to a counter marker (blue) and press E to toggle your queue status.
  - Moving > 15m away auto-removes you from the queue.
- Staff (job in `listOfJobsThatMarkCustomer`):
  - Toggle tablet: F6 or command `/burgershot`.
  - Tablet has categories; add items to a local “order” list; close with “Schließen”.

## Configuration
All options in [config/main.lua](config/main.lua) under [`Config_Burgershot`](config/main.lua):
- Notifications: `NotifyEvent` (client event used to show messages).
- Staff jobs: `listOfJobsThatMarkCustomer`.
- Markers: `Markers.order_positions` and `Markers.mark_customer` (type, scale, color, rotate, upDown).
- Counter locations: `Order_Positions` (vector3 list).
- Messages: success/help texts shown to players.

## NUI (Web UI)
- Files: [html/index.html](html/index.html), [html/styles.css](html/styles.css), [html/script.js](html/script.js)
- Visibility:
  - Client toggles focus and sends postMessage `{ type: "ui", status: boolean }`.
  - Web listens in [`window.message`](html/script.js).
- Exit:
  - Button posts NUI callback `exit-button`, handled in client: [`RegisterNUICallback('exit-button', ...)`](client/main.lua)

## Commands & Keybinds
- Command: [`burgershot`](client/main.lua)
- Default key: F6 (mapped via [`RegisterKeyMapping`](client/main.lua))

## Events & Callbacks
Server ([server/main.lua](server/main.lua)):
- Event add: [`fdokhfijsdh_burgershot:addCustomer`](server/main.lua)
- Event remove: [`fdokhfijsdh_burgershot:removeCustomer`](server/main.lua)
- ESX callback (check queued): [`fdokhfijsdh_burgershot:isNewCustomerAllreadyACustomer`](server/main.lua)

Client ([client/main.lua](client/main.lua)):
- Update list: [`fdokhfijsdh_burgershot:updateCustomerList`](client/main.lua)

Data
- Current queue (server): [`currentCustomer`](server/main.lua)

## How it works (flow)
1. Customer presses E at a counter:
   - Client asks server via ESX callback if already queued.
   - Server adds/removes from [`currentCustomer`](server/main.lua) and broadcasts [`updateCustomerList`](client/main.lua) to staff.
2. Staff with allowed job render a marker above each queued customer.
3. Leaving the counter area auto-removes the customer and updates staff.

## Notes
- MySQL is not required in current functionality despite being listed.
- The tablet “order” is currently local-only (no server submission).

## Development
- Client loop/startup: [client/main.lua](client/main.lua)
- Server queue logic: [server/main.lua](server/main.lua)
- UI: [html/*](html/index.html)

## Troubleshooting
- No markers for staff: ensure your ESX job is in [`Config_Burgershot.listOfJobsThatMarkCustomer`](config/main.lua).
- E key does nothing: confirm you are within 0.5 units of an `Order_Positions` location.
- Tablet not opening: confirm command [`burgershot`](client/main.lua) and keybind registration, and that you have a valid staff job.
- Emote not playing/canceling: install/enable rpemotes-reborn or adjust the emote calls in [`setDisplay`](client/main.lua).

## License
MIT — see [LICENCE.md](LICENCE.md).