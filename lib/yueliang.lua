--[[
	Yueliang - Lua 5.1 Bytecode Compiler
	Converts source code to bytecode
]]

local Yueliang = {}

function Yueliang.compile(src, name)
	local bytecode = string.dump(assert(loadstring(src, name or "gg_y")))
	return bytecode
end

return Yueliang
