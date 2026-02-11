return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      default_format_opts = {
        timeout_ms = 10000, -- 10 seconds instead of default 3
      },
      formatters_by_ft = {
        php = { "pint", "php_cs_fixer" },
        blade = { "blade-formatter" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        python = { "isort", "black" },
        elixir = { "mix" },
        heex = { "mix" },
        eex = { "mix" },
      },
    },
  },
}
