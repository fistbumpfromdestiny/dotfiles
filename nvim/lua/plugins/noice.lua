return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      -- Increase timeout for LSP progress messages (like Volar initialization)
      progress = {
        throttle = 1000 / 30, -- 30fps
      },
    },
    -- Keep notifications visible longer
    routes = {
      -- Show LSP progress/initialization messages longer
      {
        filter = {
          event = "lsp",
          kind = "progress",
        },
        opts = { skip = false },
      },
    },
    -- Notification display settings
    notify = {
      enabled = true,
    },
  },
}
