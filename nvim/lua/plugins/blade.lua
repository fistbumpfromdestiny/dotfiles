return {
  {
    "EmranMR/tree-sitter-blade",
    ft = { "blade" },
    submodules = false, -- Disable automatic submodule fetching (we handle it manually)
    build = function()
      -- Use git config to redirect SSH to HTTPS without modifying .gitmodules
      local plugin_dir = vim.fn.stdpath("data") .. "/lazy/tree-sitter-blade"
      vim.fn.system(string.format("cd %s && git config --local url.'https://github.com/'.insteadOf 'git@github.com:'", plugin_dir))
      vim.fn.system(string.format("cd %s && git submodule update --init --recursive", plugin_dir))
    end,
  },
}
