local M = {}

M.config = {
	key = "",
}

-- status
M.is_active = false

function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
end

--- activate alphabet mapping
function M.activate_alphabet_mapping()
	if M.is_active then
		vim.notify("Plugin already active.", vim.log.levels.INFO)
		return
	end

	local key_string = M.config.key
	if key_string == nil or key_string == "" then
		vim.notify("There is no 'key' in config, activation cancelled.", vim.log.levels.WARN)
		return
	end

	for i = 1, 26 do
		local alphabet_char = string.char(string.byte("a") + i - 1)
		local replacement_char = string.sub(key_string, i, i)

		if replacement_char and replacement_char ~= "" then
			vim.keymap.set("i", alphabet_char, function()
				if string.match(alphabet_char, "%u") then
					return replacement_char
				else
					return string.lower(replacement_char)
				end
			end, {
				expr = true,
				noremap = true,
				desc = "SecretMap: " .. alphabet_char .. " -> " .. replacement_char,
			})
		end
	end

	M.is_active = true
	vim.notify("Plugin Activated.", vim.log.levels.INFO)
end

--- Deactivate alphabet mapping
function M.deactivate_alphabet_mapping()
	if not M.is_active then
		vim.notify("Plugin already deactive.", vim.log.levels.INFO)
		return
	end

	for i = 1, 26 do
		local alphabet_char = string.char(string.byte("a") + i - 1)
		pcall(vim.keymap.del, "i", alphabet_char)
	end

	M.is_active = false
	vim.notify("Plugin Deactivated.", vim.log.levels.INFO)
end

--- Toggle status
function M.toggle_alphabet_mapping()
	if M.is_active then
		M.deactivate_alphabet_mapping()
	else
		M.activate_alphabet_mapping()
	end
end

return M
