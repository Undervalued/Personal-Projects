local TableCK = nil
local _JsonFile = nil
local _ZafirosFile = nil
local TableZafiros = nil
ESX = nil
TriggerEvent('esx:qetSharedObject', function(obj) ESX = obj end)


function IsStaff(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if source == 0 then return true end
    if not xPlayer or xPlayer.getGroup() ~= 'superadmin' then return false end
    return true
end

function webhook(source, steamid, text)
  if source == "steam:servidor" or source == 0 then
    usuario = "Consola"
    usuarioid = "0"
  else
    local xPlayer = ESX.GetPlayerFromId(source)
    usuario = tostring(xPlayer.getName())
    usuarioid = tostring(source)
  end
  PerformHttpRequest("https://discord.com/api/webhooks/./.", function(err, text, headers) end, 'POST', json.encode({username = "Pibo Logs", content = "```"..usuario.." ("..usuarioid..") | " .. text ..steamid.."  |```", avatar_url = "https://cdn.discordapp.com/avatars/768127705820430348/6f92a0c09d564160b77e173279b77974.png"}), { ['Content-Type'] = 'application/json' })
end

function AddCK(source, steamid)
  if source == nil then source = "steam:servidor" end
  PrintChatMsg(source, "'^7[^1Alerta^7]^2 El ck se aplicara despues del reincio ^1| ^3SteamID: ^7[" .. steamid .. ']')
  TableCK[steamid] = true
  GetZafiros(steamid)
  webhook(source,steamid,"usó el comando /ck ")
end

function RemoveCK(source, steamid)
  TableCK[steamid] = nil
  TableZafiros[steamid] = nil
  if source == nil then source = "steam:servidor" end
  PrintChatMsg(source, "'^7[^1Alerta^7]^2 El ck se ha eliminado de la lista ^1| ^3SteamID: ^7[" .. steamid .. ']')
  webhook(source,steamid,"usó el comando /unck ")
end

function ClaimZafiros(source, steamid)
  if _ZafirosFile == nil then
    _JsonFile = LoadResourceFile(GetCurrentResourceName(), "zafiros.json")
    TableZafiros = json.decode(_JsonFile)
  end

  if source == nil then source = "steam:servidor" end

  if TableZafiros[steamid] == nil then 
    PrintChatMsg(source, "'^7[^1Alerta^7]^2 No tienes Zafiros para reclamar.")
    return
  else
    PrintChatMsg(source, "'^7[^1Alerta^7]^2 Has reclamado ^1" .. TableZafiros[steamid] .. "^4 Zafiros")
    webhook(source,steamid,"usó el comando /claim para reclamar " .. TableZafiros[steamid] .. " Zafiros ")
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addAccountMoney('zafiro', TableZafiros[steamid])
    TableZafiros[steamid] = nil
  end
  SaveResourceFile(GetCurrentResourceName(), "zafiros.json", json.encode(TableZafiros), -1)
end

RegisterCommand("claim", function(source, args, user)
    local _s = source
    if #args then ClaimZafiros(_s, get_steamid(_s)) end
end, false)


function get_steamid(playerid)
  for k,v in ipairs(GetPlayerIdentifiers(playerid)) do
    if string.match(v, 'steam:') then
      return v
    end
  end
end

function RunCommand(source, steamid, func)
    if _JsonFile == nil then
        _JsonFile = LoadResourceFile(GetCurrentResourceName(), "data.json")
        TableCK = json.decode(_JsonFile)
    end

    if _ZafirosFile == nil then
      _JsonFile = LoadResourceFile(GetCurrentResourceName(), "zafiros.json")
      TableZafiros = json.decode(_JsonFile)
    end

    if tonumber(steamid) then steamid = get_steamid(steamid) end -- convertir id a steamid 
    if steamid == nil or string.find(steamid, "steam:") == nil then
      --Notificar, steamid erroneo
      PrintChatMsg(source, "^*^1 Introduce un steamid/id correcto.")
    elseif IsStaff(source) then
        if func ~= nil then func(source, steamid) end
        
        SaveResourceFile(GetCurrentResourceName(), "zafiros.json", json.encode(TableZafiros), -1)
        SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(TableCK), -1)
    else
        PrintChatMsg(source, "^*^1 No tienes acceso a este comando.")
    end
end

RegisterCommand("ck", function(source, args, user)  
    local _s = source
    if #args then RunCommand(_s, args[1], AddCK) end
end, false)

RegisterCommand("unck", function(source, args, user)
    local _s = source
    if #args then RunCommand(_s, args[1], RemoveCK) end
end, false)


function PrintChatMsg(source, msg) 
  if source ~= 0 then
    TriggerClientEvent('chatMessage', source, msg, {24, 0, 0})
  else
    print("[CK]" .. msg)
  end
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


function GetZafiros(steamid)
  local zafiros = 0
  local result2 = MySQL.Sync.fetchAll('SELECT * from es_extended.allhousing WHERE owner = @steamid AND buy_mode = 1', {
    ['@steamid'] = steamid
  })
  for j=1, #result2, 1 do
      zafiros = zafiros + result2[j].price
  end
  zafiros = zafiros - (20*zafiros/100)
  TableZafiros[steamid] = math.floor(zafiros)
  -- SaveResourceFile(GetCurrentResourceName(), "zafiros.json", json.encode(TableZafiros), -1)
end

Citizen.CreateThread(function()
  Citizen.Wait(1000) -- esperar a que cargue mysql
  -- RunCommand() -- Cargar el archivo json (TableCK)
  RunCommand(0,'steam:servidor',nil)
  for steamid,v in pairs(TableCK) do
    -- Aplicar el CK al steamid
    MySQL.Sync.execute(
      'DELETE from es_extended.addon_account_data WHERE owner = @steamid;' ..
      'DELETE from es_extended.addon_inventory_items WHERE owner = @steamid;' ..
      'DELETE from es_extended.billing WHERE identifier = @steamid;' ..
      'DELETE from es_extended.datastore_data WHERE owner = @steamid;' ..
      'DELETE from es_extended.dpkeybinds WHERE id = @steamid;' ..
      'DELETE from es_extended.eneko_miembros WHERE identifier = @steamid;' ..
      'DELETE from es_extended.phone_users_contacts WHERE identifier = @steamid;' ..
      'DELETE from es_extended.tm1_exp WHERE identifier = @steamid;' ..
      'DELETE from es_extended.users WHERE identifier = @steamid;' ..
      'DELETE from es_extended.user_licenses WHERE owner = @steamid;' ..
      'DELETE from es_extended.user_licenses WHERE owner = @steamid;' ..
      'DELETE from es_extended.eneko_negocios_members WHERE identifier = @steamid;' ..
      'DELETE from es_extended.owned_properties WHERE owner = @steamid;' ..
      'DELETE from es_extended.lsrp_motels WHERE ident = @steamid;' ..
      'DELETE from es_extended.communityservice WHERE identifier = @steamid;' ..
      'UPDATE es_extended.allhousing SET ownername = "" WHERE owner = @steamid;',
    {['@steamid'] = steamid})

    --Borrar vehiculos y lo que tienen en el maletero
    local result2 = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @steamid', {
      ['@steamid'] = steamid
    })
    for j=1, #result2, 1 do
      local carPlate  = result2[j].plate
      MySQL.Async.execute('DELETE FROM es_extended.inventario_coches WHERE plate = @plate', {['@plate'] = carPlate}) -- inventario_coches
    end
    MySQL.Async.execute('DELETE from es_extended.owned_vehicles WHERE owner = @steamid AND zafiro != @zafiro', {
      ['@steamid'] = steamid,
      ['@zafiro'] = '1'
    })
    -- --END vehicles
    TableCK[steamid] = nil -- Eliminar el steamid del json
    webhook("steam:servidor", steamid, "Se ha aplicado el ck a ")
    -- TableCK[steamid] = nil
  end
  SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(TableCK), -1) -- Actualizar el json / guardar los ck eliminados
end)


AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
  SaveResourceFile(GetCurrentResourceName(), "data.json", json.encode(TableCK), -1)
  SaveResourceFile(GetCurrentResourceName(), "zafiros.json", json.encode(TableZafiros), -1)
end)



