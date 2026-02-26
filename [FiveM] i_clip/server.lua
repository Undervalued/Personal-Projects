ESX = nil
TriggerEvent('esx:qetSharedObject', function(obj) ESX = obj end)
local steams = {
'steam:1100001120b715a',
'steam:11000010c152924',
'steam:1100001143486d2',
'steam:110000134f53a37',
'steam:110000146c74e86',
'steam:110000141c417be',
'steam:11000013d61918c',
'steam:11000013d1429ac',
'steam:110000113336e36',
}

function get_steamid(playerid)
  for k,v in ipairs(GetPlayerIdentifiers(playerid)) do
        if string.match(v, 'steam:') then return v end
    end
end

function check_1(steamid)
    -- return true -- Activo pa todos los users
    for _, v in pairs(steams) do
        if (1 == 1) then -- v == steamid
            return true
        end
	Wait(0)
    end
    return false
end

function IsStaff(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'superadmin' then
        return false
    end
    return true
end

RegisterCommand("guardarclip", function(source)
    local _s = source
    if IsStaff(_s) or check_1(get_steamid(source)) then TriggerClientEvent('stop_save_record', source, _source) end
end, false)

RegisterCommand("descartarclip", function(source)
    local _s = source
    if IsStaff(_s) or check_1(get_steamid(source)) then TriggerClientEvent('stop_discard_record', source, _source) end
end, false)

RegisterCommand("grabarreplay", function(source)
    local _s = source
    if IsStaff(_s) or check_1(get_steamid(source)) then TriggerClientEvent('start_record_replay', source, _source) end
end, false)

RegisterCommand("grabarclip", function(source)
    local _s = source
    if IsStaff(_s) or check_1(get_steamid(source)) then TriggerClientEvent('start_record', source, _source) end
end, false)

