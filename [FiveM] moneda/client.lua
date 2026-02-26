-- 3d vector (airport) <x,y,z>
local v1 = vector3(-1377.514282266, -2852.64941406, 13.9448)
-- 2d vector (airport) <x,y>
local v2 = vector2(-1299.757, -2846.576)
-- '4d' vector (airport) <x,y,z,w>
local v3 = vector4(-1377.514282266, -2852.64941406, 13.9448, 360)


local blip = AddBlipForCoord(v2.x, v2.y)

setBlipSprite(blip, 364)
setBlipDisplay(blip, 6)
SetBlipScale(blip, 0.9)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Do not enter")
EndTextCommandSetBlipName(blip)

RegisterCommand("tp" function(source, args)
    SetEntityCoords(PlayerPedId(), v3.x, v3.y, v3.z, true, true, true, false)
    SetEntityHeading(PlayerPedId(), v3.w)
end)


function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        print(Vdist2(GetEntityCoords(PlayerPedId(), false), v1))
        if Vdist2(GetEntityCoords(PlayerPedId(), false), v1) < 5000 then 
            Draw3DText(v1.x, v1.y, v1.z, "Cruz")
        end
    end
end)