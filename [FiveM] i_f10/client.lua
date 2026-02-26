-- TriggerClientEvent("ropamenu:msg", msgIndex)
local mensajes = { 
    [1] = "~r~Tu grupo no posee ninguna ropa.",
    [2] = "~r~No perteneces a ningún grupo."
}

local feed = true

local ESX = nil
local open = false

Citizen.CreateThread(function()
	while true do 
    Citizen.Wait(0)
        local ply = PlayerPedId()

        if IsPedArmed(ply, 6) then
			DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
	end
end
end)
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:qetSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterCommand("feed", function()
    feed = not feed
    mesg = "inactiva"
    if feed == true then mesg = "activa" end
    ESX.ShowNotification("Killfeed " .. mesg)
end)

function OpenMenu(clotheData)
    local playerPed = PlayerPedId()
    TriggerEvent('skinchanger:getSkin', function(skin)
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "menu_ropa_Exclusiva", { title = "Ropa Exclusiva", align = "right", elements = clotheData }, function(data, menu)
            local clothe = (skin.sex == 0) and data.current.male or data.current.female
            SetPedComponentVariation(playerPed, clothe[1], clothe[2], clothe[3], 2)
            TriggerEvent('skinchanger:getSkin', function(skin)
              TriggerServerEvent('esx_skin:save', skin)
            end)
        end, function(data, menu)
            menu.close()
            open = false
        end)
    end)
end

RegisterNetEvent("ropamenu:rec")
AddEventHandler("ropamenu:rec", function(menuData)
    open = true
    OpenMenu(menuData)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 57) then
            if not open then
                TriggerServerEvent("ropamenu:get")
                Wait(100)
            end
        end
    end
end)

RegisterNetEvent("ropamenu:msg", function(id)
    local msg = mensajes[id]
    if msg ~= nil then
        ESX.ShowNotification(msg)
    end
end)

RegisterNetEvent('killf:mess')
AddEventHandler('killf:mess', function(text)
if feed then 
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(0, 1)
end
end)
