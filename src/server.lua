local socket = require('socket')

-- utils
function split(s, sep)
    local fields = {}

    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)

    return fields
end

t = split("192.168.0.1",".")
for i,j in pairs(t) do
    print(i,j)
end

function map(a, fcn)
	local b={}
	for i,v in ipairs(a) do
		table.insert(b, fcn(v))
	end
	return b
end
-- end split
function getDomain(url)
    startHttp, endHttp = string.find(url,'http://')
    startHttps, endHttps = string.find(url,'https://')

    startDomain = 1
    protocol = nil
    if startHttps then
        -- print("entrou 1")
        startDomain = endHttps + 1
        protocol = "https"
    elseif startHttp then
        -- print("entrou 2")
        startDomain = endHttp + 1
        protocol = "http"
    else
        -- print("entrou 3")
        -- TODO: bad request
    end

    -- print("startDomain")
    -- print(startDomain)

    beforeSlash = string.find(url, '/', startDomain) - 1

    if not beforeSlash then
        -- print("entrou 4")
        beforeSlash = string.len(s)
    end

    -- print("firstSlash")
    -- print(firstSlash)

    domain = string.sub(url, startDomain, beforeSlash)
    path = string.sub(url, beforeSlash + 2)
    
    -- luaConvertDword(ip)

    return { protocol, domain, path }
end

function getDword(ipString)
    octates = split(ipString,".")
    number_octates = map(octates,function(octate)
        return tonumber((octate))
    end)

    dword = (((((number_octates[1] * 256) + number_octates[2]) * 256) + number_octates[3]) * 256) + number_octates[4]

    return dword
end

-- function luaConvertDword(word)

-- end
result = getDomain("https://google.com/obuscure.html")
protocol = result[1]
domain = result[2]
path = result[3]

print(tostring(domain))
print(path)
ip, err = socket.dns.toip(domain)
print(ip)
print(err)
dword = getDword(ip)
print(dword)