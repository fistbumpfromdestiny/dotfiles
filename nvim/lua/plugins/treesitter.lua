return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "php",
        "phpdoc",
        "blade",
        "javascript",
        "typescript",
        "vue",
        "html",
        "css",
        "scss",
        "json",
        "yaml",
        "lua",
        "vim",
        "vimdoc",
        "bash",
      },
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    },
  },
}
