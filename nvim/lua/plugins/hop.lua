return {
  "smoka7/hop.nvim",
  version = "*",
  opts = {
    keys = "etovxqpdygfblzhckisuran",
  },
  keys = {
    {
      "<leader>hw",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_words({ direction = directions.AFTER_CURSOR })
      end,
      desc = "Hop to word",
      mode = { "n", "v" },
    },
    {
      "<leader>hW",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_words({ direction = directions.BEFORE_CURSOR })
      end,
      desc = "Hop to word (backward)",
      mode = { "n", "v" },
    },
    {
      "<leader>hl",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_lines({ direction = directions.AFTER_CURSOR })
      end,
      desc = "Hop to line",
      mode = { "n", "v" },
    },
    {
      "<leader>hL",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_lines({ direction = directions.BEFORE_CURSOR })
      end,
      desc = "Hop to line (backward)",
      mode = { "n", "v" },
    },
    {
      "<leader>hc",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_char1({ direction = directions.AFTER_CURSOR })
      end,
      desc = "Hop to character",
      mode = { "n", "v" },
    },
    {
      "<leader>hC",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_char1({ direction = directions.BEFORE_CURSOR })
      end,
      desc = "Hop to character (backward)",
      mode = { "n", "v" },
    },
    {
      "<leader>h2",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_char2({ direction = directions.AFTER_CURSOR })
      end,
      desc = "Hop to 2 characters",
      mode = { "n", "v" },
    },
    {
      "<leader>hp",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_patterns({ direction = directions.AFTER_CURSOR })
      end,
      desc = "Hop to pattern",
      mode = { "n", "v" },
    },
    {
      "s",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_char1({ direction = directions.AFTER_CURSOR })
      end,
      desc = "Hop to character",
      mode = { "n", "v" },
    },
    {
      "S",
      function()
        local directions = require("hop.hint").HintDirection
        require("hop").hint_char2({ direction = directions.AFTER_CURSOR })
      end,
      desc = "Hop to 2 characters",
      mode = { "n", "v" },
    },
  },
}
