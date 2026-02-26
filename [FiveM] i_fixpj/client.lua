
local ancla = true
RegisterCommand('ancla', function(source, args, xdddd, xds)
	local lped = PlayerPedId()
	if IsPedInAnyVehicle(lped) then
		local vehicle = GetVehiclePedIsIn(lped)
		if DoesEntityExist(vehicle) then
		    if IsThisModelABoat(GetEntityModel(vehicle)) and IsEntityInWater(vehicle) or ancla == false then
				FreezeEntityPosition(vehicle, ancla)
				ancla = not ancla
		    end
		end
	end
end)
neverGrab = {
  GetHashKey('playerhouse_hotel'),
  GetHashKey('playerhouse_tier1'),
  GetHashKey('playerhouse_tier1_full'),
  GetHashKey('v_49_MotelMP_Curtains'),
  GetHashKey('V_16_DT'),

  GetHashKey('shell_v16low'),
  GetHashKey('shell_lester'),
  GetHashKey('shell_ranch'),
  GetHashKey('shell_trailer'),
  GetHashKey('shell_v16mid'),
  GetHashKey('shell_highend'),
  GetHashKey('shell_highendv2'),
  GetHashKey('shell_michael'),

  GetHashKey('shell_office1'),
  GetHashKey('shell_office2'),
  GetHashKey('shell_officebig'),
  
  GetHashKey('shell_store1'), 
  GetHashKey('shell_store2'),
  GetHashKey('shell_store3'),
  GetHashKey('shell_gunstore'),
  GetHashKey('shell_barber'),

  GetHashKey('shell_warehouse1'),
  GetHashKey('shell_warehouse2'),
  GetHashKey('shell_warehouse3'),

  GetHashKey('interior_009'),
  GetHashKey('interior_010'),
  GetHashKey('interior_011'),
  GetHashKey('interior_012'),
}

antiGrab = {}
for k,v in pairs(neverGrab) do 
  antiGrab[v] = v;
  antiGrab[v%0x100000000] = v%0x100000000; 
end

RegisterCommand('fixpj', function(source, args)
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    while true do
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < 5.0 and not antiGrab[GetEntityModel(ped)] then
	        if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
                DetachEntity(ped, false, false)
                DeleteEntity(ped)
            end
        end
        success, ped = FindNextObject(handle)
        if not success then break end
    end
    sucess = nil
    EndFindObject(handle)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        SetPedModelIsSuppressed(GetHashKey("a_c_seagull"), true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        if IsPedInAnyVehicle(PlayerPedId()) then
            local coch = GetHashKey(GetEntityModel(GetVehiclePedIsIn(PlayerPedId()))) 
            if coch == 2059740011 or coch == 937679890 then
                ResetPlayerStamina(PlayerId())
            end
        end
    end
end)