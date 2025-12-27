--[[
	AES Encryption (RC4/ARCFOUR) Implementation
	Used for encrypting obfuscated bytecode with random key
]]

local AES = loadstring([===[
(function()
	local function a(b)
		local c={}
		for d=0,255 do c[d]={} end
		c[0][0]=b[1]*255
		local e=1
		for f=0,7 do
			for d=0,e-1 do
				for g=0,e-1 do
					local h=c[d][g]-b[1]*e
					c[d][g+e]=h+b[2]*e
					c[d+e][g]=h+b[3]*e
					c[d+e][g+e]=h+b[4]*e
				end
			end
			e=e*2
		end
		return c
	end
	
	local i=a{0,1,1,0}
	
	local function j(self,k)
		local l,d,g=self.S,self.i,self.j
		local m={}
		local n=string.char
		for o=1,k do
			d=(d+1)%256
			g=(g+l[d])%256
			l[d],l[g]=l[g],l[d]
			m[o]=n(l[(l[d]+l[g])%256])
		end
		self.i,self.j=d,g
		return table.concat(m)
	end
	
	local function p(self,q)
		local r=j(self,#q)
		local s={}
		local t=string.byte
		local n=string.char
		for d=1,#q do
			s[d]=n(i[t(q,d)][t(r,d)])
		end
		return table.concat(s)
	end
	
	local function u(self,v)
		local l=self.S
		local g,w=0,#v
		local t=string.byte
		for d=0,255 do
			g=(g+l[d]+t(v,d%w+1))%256
			l[d],l[g]=l[g],l[d]
		end
	end
	
	function new(v)
		local l={}
		local s={S=l,i=0,j=0,generate=j,cipher=p,schedule=u}
		for d=0,255 do l[d]=d end
		if v then s:schedule(v) end
		return s
	end
	
	return new
end)()
]===])()

return AES
