-- Better HTML/Vue template highlighting
-- Adds distinct colors for tags, attributes, delimiters, and strings

local function set_html_highlights()
	-- Get the current colorscheme's colors for consistency
	local function get_hl_fg(name)
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		return hl.fg
	end

	-- Use existing theme colors for consistency
	local cyan = get_hl_fg("Tag") or get_hl_fg("Character") -- Tags (div, h1)
	local blue = get_hl_fg("Identifier") or get_hl_fg("Directory") -- Attributes (class, id)
	local gray = get_hl_fg("Comment") -- Delimiters (<, >, />)
	local magenta = get_hl_fg("SpecialChar") -- Attribute values

	-- Set highlights for Vue/HTML (need .vue suffix since Vue parser is used)
	if cyan then
		vim.api.nvim_set_hl(0, "@tag", { fg = cyan })
		vim.api.nvim_set_hl(0, "@tag.vue", { fg = cyan })
	end

	if blue then
		vim.api.nvim_set_hl(0, "@tag.attribute", { fg = blue })
		vim.api.nvim_set_hl(0, "@tag.attribute.vue", { fg = blue })
	end

	if gray then
		vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = gray })
		vim.api.nvim_set_hl(0, "@tag.delimiter.vue", { fg = gray })
	end

	if magenta then
		vim.api.nvim_set_hl(0, "@string.vue", { fg = magenta })
	end
end

-- Apply on startup
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(set_html_highlights, 50)
	end,
})

-- Reapply after colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_html_highlights,
})

return {}
