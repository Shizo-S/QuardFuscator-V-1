--[[
	Crypto Module - Handles AES encryption with Base64 encoding
]]

local Crypto = {}

function Crypto.new(aes_impl, base64_impl)
	return {
		aes = aes_impl,
		base64 = base64_impl
	}
end

function Crypto.encrypt(self, code, key)
	-- Create AES state with key
	local state = self.aes(key)
	-- Encrypt the code
	local encrypted = state:cipher(code)
	-- Encode to Base64 for safe transmission
	local encoded = self.base64.Encode(encrypted)
	return encoded
end

function Crypto.decrypt(self, code, key)
	-- Create AES state with key
	local state = self.aes(key)
	-- Decode from Base64
	local decoded = self.base64.Decode(code)
	-- Decrypt
	local decrypted = state:cipher(decoded)
	return decrypted
end

return Crypto
