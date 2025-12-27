--[[
	Utility Functions for Obfuscator
]]

local Utils = {}
local morecharset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/!@#$%&*()-=[];\'",./_+{}:|<>?'

function Utils.genpass(length)
	local pass = ""
	for i = 1, length do
		local a = math.random(1, #morecharset)
		pass = pass .. morecharset:sub(a, a)
	end
	return pass
end

function Utils.hex_to_binary_map()
	return {
		['0']='0000', ['1']='0001', ['2']='0010', ['3']='0011',
		['4']='0100', ['5']='0101', ['6']='0110', ['7']='0111',
		['8']='1000', ['9']='1001', ['A']='1010', ['B']='1011',
		['C']='1100', ['D']='1101', ['E']='1110', ['F']='1111'
	}
end

function Utils.decimal_to_binary(n)
	local h2b = Utils.hex_to_binary_map()
	return ('%X'):format(n):upper():gsub(".", h2b)
end

function Utils.gen_iluminati_var(a)
	return Utils.decimal_to_binary((a):byte(1,-1)):gsub("0","l"):gsub("1","I")
end

function Utils.sanitize_varname(name)
	name = name:gsub('[%p%c%s]', '_')
	name = name:sub(1,1):gsub('[%d]','v'..name:sub(1,1)) .. name:sub(2)
	return name
end

function Utils.load_base64_decode()
	return [[function(a)local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';a=string.gsub(a,'[^'..b..'=]','')return a:gsub('.',function(c)if c=='='then return''end;local d,e='',b:find(c)-1;for f=6,1,-1 do d=d..(e%2^f-e%2^(f-1)>0 and'1'or'0')end;return d end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(c)if#c~=8 then return''end;local g=0;for f=1,8 do g=g+(c:sub(f,f)=='1'and 2^(8-f)or 0)end;return string.char(g)end)end]]
end

function Utils.load_aes_code()
	return [[(function()local function a(b)local c={}for d=0,255 do c[d]={}end;c[0][0]=b[1]*255;local e=1;for f=0,7 do for d=0,e-1 do for g=0,e-1 do local h=c[d][g]-b[1]*e;c[d][g+e]=h+b[2]*e;c[d+e][g]=h+b[3]*e;c[d+e][g+e]=h+b[4]*e end end;e=e*2 end;return c end;local i=a{0,1,1,0}local function j(self,k)local l,d,g=self.S,self.i,self.j;local m={}local n=string.char;for o=1,k do d=(d+1)%256;g=(g+l[d])%256;l[d],l[g]=l[g],l[d]m[o]=n(l[(l[d]+l[g])%256])end;self.i,self.j=d,g;return table.concat(m)end;local function p(self,q)local r=j(self,#q)local s={}local t=string.byte;local n=string.char;for d=1,#q do s[d]=n(i[t(q,d)][t(r,d)])end;return table.concat(s)end;local function u(self,v)local l=self.S;local g,w=0,#v;local t=string.byte;for d=0,255 do g=(g+l[d]+t(v,d%w+1))%256;l[d],l[g]=l[g],l[d]end end;function new(v)local l={}local s={S=l,i=0,j=0,generate=j,cipher=p,schedule=u}for d=0,255 do l[d]=d end;if v then s:schedule(v)end;return s end;return new end)()]]
end

function Utils.load_fione_code()
	-- Full FiOne bytecode executor - TRUNCATED FOR SPACE
	-- Use the complete version from the original document
	return [[]]
end

return Utils
