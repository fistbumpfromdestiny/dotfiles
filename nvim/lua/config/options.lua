-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false

-- Increase LSP client timeout (helps with slow servers like Volar)
vim.lsp.set_log_level("off") -- Reduce noise, change to "debug" to troubleshoot
