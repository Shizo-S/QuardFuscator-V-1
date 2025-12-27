#!/usr/bin/env lua
--[[
	Modular Lua Bytecode Obfuscator - Main Entry Point
	Copyright (c) 2025 Reboy / M0dder / Shizo
]]

local obversion = "v1.3.1"
local climode = arg ~= nil and true or false

if game ~= nil and typeof ~= nil then
	print("This Obfuscator cannot be ran in Roblox. (but results can be ran in Roblox)")
	return
end

-- Add lib directory to package path
local path = arg[0]:match("(.*/)")
if not path or path == "" then path = "./" end
package.path = path .. "lib/?lua;" .. path .. "lib/?.lua;" .. package.path

-- Load modules
local Base64 = require("base64")
local AES = require("aes")
local Yueliang = require("yueliang")
local FiOne = require("fione")
local Utils = require("utils")
local Crypto = require("crypto")
local Defaults = require("defaults")
local CLI = require("cli")

-- Polyfill for table.find
if table.find == nil then
	table.find = function(tbl,value,pos)
		for i = pos or 1,#tbl do
			if tbl[i] == value then
				return i
			end
		end
	end
end

-- Parse CLI arguments
local realargs = nil
if climode then
	realargs = CLI.parse_args(arg, obversion)
	if not realargs then
		return
	end
end

local M = {}

function M.crypt(source, options)
	options = options or {}
	local silent = options.silent or false
	
	if not silent and #source >= 2000000 then
		print("WARNING: Your script seems too big, the process may be crashed or the code may be corrupted.")
	end
	
	-- Merge with defaults
	for k,v in pairs(Defaults) do
		if options[k] == nil then
			options[k] = v
		end
	end
	
	options.variablename = Utils.sanitize_varname(options.variablename)
	local varname = options.variablename
	local varcomment = options.cryptvarcomment and "\\"..table.concat({options.variablecomment:byte(1,-1)},"\\") or options.variablecomment
	local comment = options.comment

	if not silent then print("Obfuscating | Code conversion...") end
	
	local succ, luac = pcall(function()
		return Yueliang.compile(source, "gg_y")
	end)
	
	if succ == false then
		print("Lua Error: " .. luac)
		return error(luac)
	end
	
	collectgarbage()
	
	if not silent then print("Obfuscating | Encrypting...") end
	
	local passkey = Utils.genpass(math.random(10,20))
	local crypto = Crypto.new(AES, Base64)
	local encsrc = crypto:encrypt(Base64.Encode(luac), passkey)
	local key64 = Base64.Encode(passkey)
	
	collectgarbage()
	
	if not silent then print("Obfuscating | Code Building...") end
	
	-- Generate variable names with IL obfuscation
	local genIl = Utils.gen_iluminati_var
	local r_key = "return(function()"
	local fv_z = ("local %s%s = \"%s\";"):format(varname, genIl("z"), varcomment)
	local f1_a = ("local %s%s"):format(varname, genIl("a"))
	local f2_b = ("local %s%s"):format(varname, genIl("b"))
	local f3_c = ("local %s%s"):format(varname, genIl("c"))
	local c1_d = ("local %s%s"):format(varname, genIl("d"))
	local f4_e = ("local %s%s"):format(varname, genIl("e"))
	local f5_f = ("local %s%s"):format(varname, genIl("f"))
	local f6_g = ("local %s%s"):format(varname, genIl("g"))
	
	-- Build fake variables
	local f4 = f4_e .. "=" .. ("'%s'"):format(Base64.Encode(Utils.genpass(math.random(10,20))))
	local f5 = f5_f .. "=" .. ("'%s'"):format(varcomment)
	local f6 = f6_g .. "=" .. ("'%s'"):format(Base64.Encode(Utils.genpass(math.random(10,20))))
	local c1 = c1_d .. "=" .. ("'%s'"):format("\\"..table.concat({key64:byte(1,-1)},"\\"))
	local fks = {f4,f5,f6,c1}
	
	-- Load embedded code
	local i_ = ("%s%s"):format(varname, genIl("i"))
	local c2_i_b64 = ("local %s"):format(i_) .. "=" .. Utils.load_base64_decode()
	
	local j_ = ("%s%s"):format(varname, genIl("j"))
	local c3_j_aes = ("local %s"):format(j_) .. "=" .. Utils.load_aes_code()
	
	local k_ = ("%s%s"):format(varname, genIl("k"))
	local c4_k_fne = ("local %s"):format(k_) .. "=" .. Utils.load_fione_code()
	
	local f7_h = [[function ]]..("%s%s"):format(varname, genIl("h"))..[[(a,b)local c=]]..i_..[[(a,b);local d=]]..f4_e:sub(7)..[[;return c,d end]]
	local m_ = ("%s%s"):format(varname, genIl("m"))
	
	local c4_m = ("local %s"):format(m_) .. "=" .. "function(a,b)" ..
		"local c="..j_.."("..i_.."(a))" ..
		"local d=c[\"\\99\\105\\112\\104\\101\\114\"](c,"..i_.."(b))" ..
		"return "..i_.."(d)" ..
		"end"
	
	-- Handle large source by chunking
	local n_ = ("%s%s"):format(varname, genIl("n"))
	local bytedsrc = nil
	
	if encsrc:len() > 255 then
		local chunkedbys = {}
		for i=1,#encsrc,255 do
			chunkedbys[#chunkedbys+1] = {encsrc:sub(i,i+254):byte(1,-1)}
		end
		bytedsrc = {}
		for i,v in pairs(chunkedbys) do
			for i1,v1 in pairs(v) do
				bytedsrc[#bytedsrc+1] = v1
			end
		end
	else
		bytedsrc = {encsrc:byte(1,-1)}
	end
	
	local c5res = "\\"..table.concat(bytedsrc,"\\")
	local c5_n = ("local %s"):format(n_) .. "="..("\"%s\""):format(c5res)
	
	local fenvhandle = "local fev=getfenv or function()return _ENV end"
	local f9_o = ("local %s%s"):format(varname, genIl("o")) .. "=" .. ("'%s%s%s'"):format(Base64.Encode(Utils.genpass(math.random(10,20))),Base64.Encode(Utils.genpass(math.random(10,20))),Base64.Encode(Utils.genpass(math.random(10,20))))
	
	local c_end = ("return %s(%s(%s,%s),getfenv(0))()end)()"):format(k_,m_,(c1_d):sub(7),n_)
	
	if not silent then print("Obfuscated!") end
	
	return "--" .. comment .. "\n\n" ..
		r_key ..
		fv_z ..
		fv_z ..
		fv_z ..
		f1_a .. "=" .. ("%d"):format(math.random(111,31415)/100) .. ";" ..
		f2_b .. "=" .. ("%d"):format(math.random(111,31415)/100) .. ";" ..
		f3_c .. "=" .. ("%d"):format(math.pi) .. ";" ..
		c2_i_b64 ..  ";" ..
		f2_b .. "=" .. ("%d"):format(math.random(111,31415)/100) .. ";" ..
		c3_j_aes ..  ";" ..
		fenvhandle .. ";" ..
		c4_k_fne .. ";" ..
		fks[math.random(1,#fks)] .. ";" ..
		c5_n .. ";" ..
		fks[math.random(1,#fks)] .. ";" ..
		fks[math.random(1,#fks)] .. ";" ..
		c4_m .. ";" ..
		fks[math.random(1,#fks)] .. ";" ..
		c1 .. ";" ..
		fks[math.random(1,#fks)] .. ";" ..
		f9_o .. ";" ..
		f7_h .. ";" ..
		c_end
end

if climode == true then
	if realargs.source == nil then
		print("Error: --source is required")
		return
	end
	
	local output_file = realargs.output or "output.lua"
	
	if not realargs.silent and not realargs.force then
		local existfile = io.open(output_file, "r")
		if existfile ~= nil then
			io.close(existfile)
			print("Output file exists: " .. output_file)
			io.write("Overwrite? (y/N): ")
			local answer = io.read()
			if answer:lower():sub(1,1) ~= "y" then
				print("Cancelled")
				return
			end
		end
	end
	
	local rsuccess, readdfile = pcall(function()
		return io.open(realargs.source, "rb")
	end)
	
	if not rsuccess or readdfile == nil then
		print("Error reading source file: " .. realargs.source)
		return
	end
	
	if not realargs.silent then
		print(("Reading from: %s"):format(realargs.source))
	end
	
	local clisettings = {
		comment = realargs.comment or Defaults.comment,
		variablecomment = realargs.varcomm or Defaults.variablecomment,
		cryptvarcomment = realargs.cryptvarcomm or false,
		variablename = realargs.varname or Defaults.variablename,
		silent = realargs.silent or false,
	}
	
	collectgarbage()
	local starttime = os.clock()
	
	if not realargs.silent then
		print("Starting obfuscation...")
	end
	
	local kb = M.crypt(readdfile:read("*a"), clisettings)
	
	if not realargs.silent then
		print(("Completed in %.2f seconds"):format(os.clock() - starttime))
	end
	
	readdfile:close()
	
	local wsuccess, wdfile = pcall(function()
		return io.open(output_file, "w")
	end)
	
	if not wsuccess or wdfile == nil then
		print("Error writing to: " .. output_file)
		return
	end
	
	wdfile:write(kb)
	wdfile:close()
	
	if not realargs.silent then
		print(("Written to: %s"):format(output_file))
		print("All done!")
	end
	
	if realargs.openfile then
		os.execute((package.config:sub(1,1) == "\\" and "" or (os.getenv("EDITOR") .. " "))..(output_file) .. " &")
	end
	
	return
end

return setmetatable(M, {
	__call = function(self, source, options)
		return self.crypt(source, options)
	end,
})
