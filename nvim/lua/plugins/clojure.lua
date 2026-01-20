return {
  -- Conjure: Interactive REPL for Clojure
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "janet" },
    config = function()
      -- Disable diagnostics in Conjure HUD
      vim.g["conjure#log#hud#enabled"] = true
      vim.g["conjure#log#hud#width"] = 0.5
      vim.g["conjure#log#hud#height"] = 0.4
      vim.g["conjure#log#hud#anchor"] = "SE"
      vim.g["conjure#log#botright"] = true

      -- Eval on save
      vim.g["conjure#eval#auto_require"] = false
      vim.g["conjure#eval#result_register"] = "*"

      -- Mappings prefix (default is localleader which is usually \)
      -- You can customize this if needed
      vim.g["conjure#mapping#doc_word"] = "K"
    end,
  },

  -- Parinfer: Structural editing for Lisp
  {
    "gpanders/nvim-parinfer",
    ft = { "clojure", "fennel", "janet", "scheme", "lisp" },
  },

  -- Optional: Additional Clojure utilities
  {
    "clojure-vim/vim-jack-in",
    ft = { "clojure" },
    dependencies = {
      "tpope/vim-dispatch",
      "radenling/vim-dispatch-neovim",
    },
  },
}
