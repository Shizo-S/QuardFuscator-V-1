--[[
	Base64 Encoder/Decoder
	Used for encoding/decoding obfuscated bytecode
]]

local Base64 = {}
local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function Base64.Encode(a)
	return(a:gsub('.',function(c)
		local d,b='',c:byte()
		for e=8,1,-1 do
			d=d..(b%2^e-b%2^(e-1)>0 and'1'or'0')
		end
		return d
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?',function(c)
		if#c<6 then return''end
		local f=0
		for e=1,6 do
			f=f+(c:sub(e,e)=='1'and 2^(6-e)or 0)
		end
		return charset:sub(f+1,f+1)
	end)..({'','==','='})[#a%3+1]
end

function Base64.Decode(a)
	a=string.gsub(a,'[^'..charset..'=]','')
	return a:gsub('.',function(c)
		if c=='='then return''end
		local d,e='',charset:find(c)-1
		for f=6,1,-1 do
			d=d..(e%2^f-e%2^(f-1)>0 and'1'or'0')
		end
		return d
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(c)
		if#c~=8 then return''end
		local g=0
		for f=1,8 do
			g=g+(c:sub(f,f)=='1'and 2^(8-f)or 0)
		end
		return string.char(g)
	end)
end

return Base64
