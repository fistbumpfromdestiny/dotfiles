return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "laravel", "lsp", "path", "snippets", "buffer" },
        providers = {
          laravel = {
            name = "laravel",
            module = "laravel.blink_source",
            score_offset = 100,
          },
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
      },
      signature = {
        enabled = true,
      },
    },
  },
}
