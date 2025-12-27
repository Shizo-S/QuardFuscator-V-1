--[[
	CLI Module - Command Line Interface Handler
]]

local CLI = {}

function CLI.parse_args(arg, version)
	if #arg <= 1 and (arg[1] == "--help" or arg[1] == "-h" or arg[1] == nil) then
		CLI.print_help(version)
		return nil
	end

	local realargs = {}
	local nextvargs = {"source","output","comment","varcomm","varname"}
	local longargs = {
		s="source",
		o="output",
		c="comment",
		vc="varcomm",
		vn="varname",
		C="cryptvarcomm",
		f="force",
		S="silent",
		of="openfile"
	}
	local skipdexes = {}

	for i,v in pairs(arg) do
		if (not table.find(skipdexes,i)) or (i > 0) then
			if v:sub(1,2) == "--" then
				local argname = v:sub(3)
				if table.find(nextvargs, argname) then
					realargs[argname] = arg[i+1]
					table.insert(skipdexes, (i+1))
				else
					realargs[argname] = true
				end
			elseif v:sub(1,1) == "-" then
				local shortarg = longargs[v:sub(2)]
				if shortarg and table.find(nextvargs, shortarg) then
					realargs[shortarg] = arg[i+1]
					table.insert(skipdexes, (i+1))
				elseif shortarg then
					realargs[shortarg] = true
				end
			end
		end
	end

	return realargs
end

function CLI.print_help(version)
	print("ByteLuaObfuscator " .. version)
	print("Copyright (c) 2023 Reboy / M0dder\n")
	print("Usage:")
	print("  lua main.lua --source \"<FILE>\" --output \"<FILE>\" [OPTIONS]\n")
	print("Arguments:")
	print("  --help, -h           Show this help message")
	print("  --source, -s <FILE>  Source Lua file to obfuscate")
	print("  --output, -o <FILE>  Output file path (default: output.lua)")
	print("  --comment, -c <STR>  Comment to add to output")
	print("  --varcomm, -vc <STR> Variable comment")
	print("  --varname, -vn <STR> Variable name")
	print("  --cryptvarcomm, -C   Encrypt variable comment")
	print("  --force, -f          Skip overwrite warnings")
	print("  --silent, -S         Suppress output")
	print("  --openfile, -of      Open file after obfuscation\n")
	print("Examples:")
	print("  lua main.lua -s \"script.lua\" -o \"obfuscated.lua\"")
	print("  lua main.lua -s \"code.lua\" -o \"out.lua\" -c \"Protected code\" -f")
	print("  lua main.lua -s \"file.lua\" -o \"result.lua\" -vn \"MyVar\" -S\n")
end

return CLI
