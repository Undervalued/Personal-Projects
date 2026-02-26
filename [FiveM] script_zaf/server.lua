-- json = nil
ESX = nil
TriggerEvent('esx:qetSharedObject', function(obj) ESX = obj end)

TableCK = {}


function get_steamid(playerid)
  for k,v in ipairs(GetPlayerIdentifiers(playerid)) do
    if string.match(v, 'steam:') then
      return v
    end
  end
end


RegisterCommand("zafiros", function(source, args, user)
    local _s = source
	_JsonFile = LoadResourceFile(GetCurrentResourceName(), "zaf.json")
	TableCK = json.decode(_JsonFile)
	steamid = get_steamid(_s)
	zafiros = TableCK[steamid]
if zafiros ~= nil then
	TableCK[steamid] = nil
	-- print(zafiros)

	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('zafiro', zafiros) 

end
	SaveResourceFile(GetCurrentResourceName(), "zaf.json", json.encode(TableCK), -1)
end, false)


