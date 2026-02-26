local ListaRopa = {
    ["Los Guantes Blancos"] = {
        buildOptions = nil,
        clothes = {
            {
                label = "Chaleco",
                male = { 8, 131, 0 },
                female = { 8, 148, 0 },
            }
        }
    },
    ["The Bloods"] = {
        buildOptions = nil,
        clothes = {
            {
                label = "Chaleco",
                male = { 8, 131, 0 },
                female = { 8, 148, 0 },
            }
        }
    },
}

local table_insert = table.insert

-- Pre generamos las opciones para evitar estar generandolas cada vez que un miembro abre el menu...
CreateThread(function()
    for gang, tabla in pairs(ListaRopa) do
        local Builded = {}
        for _, clothe in pairs(tabla.clothes) do
            table_insert(Builded, clothe)
        end
        ListaRopa[gang].buildOptions = Builded
    end
end)

RegisterServerEvent("ropamenu:get", function()
    TriggerEvent("enekom:getentitygang", source, function(gangName)
        -- print(gangName)
        if gangName == nil then
            TriggerClientEvent("ropamenu:msg", source, 2)
            return
        end
        if ListaRopa[gangName] == nil or ListaRopa[gangName].buildOptions == nil then
            TriggerClientEvent("ropamenu:msg", source, 1)
            return
        end

        TriggerClientEvent("ropamenu:rec", source, ListaRopa[gangName].buildOptions)
    end)
end)
RegisterNetEvent("esx:onPlayerDeath", function(data)
	if data.killedByPlayer then
		victima = source
		asesino = data.killerServerId
	    TriggerEvent("enekom:getentitynames", victima, asesino, function(victim,killer)
	        if victim == nil then -- Si es nil, es un jugador que no es policia, armada o de un grupo o tiene los tag desactivados
	            victim = GetPlayerName(victima)
	        elseif victim == "police" then
	            victim = "un ~b~policía~o~"
	        elseif victim == "armada" then
	            victim = "un ~b~militar~o~"
	        end
	        if killer == nil then -- Si es nil, es un jugador que no es policia, armada o de un grupo o tiene los tag desactivados
	            killer = GetPlayerName(asesino)
	        elseif killer == "police" then
	            killer = "Un ~b~policía~o~"
	        elseif killer == "armada" then
	            killer = "Un ~b~militar~o~"
	        end
	        -- print(killer .. " ha matado a " .. victim)
	        TriggerClientEvent('killf:mess', -1, "~o~" .. killer .. '~s~ ha matado a ' .. victim)

	    end)
	end
end)