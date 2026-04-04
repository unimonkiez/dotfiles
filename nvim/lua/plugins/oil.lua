return {
  "stevearc/oil.nvim",
  dependencies = {
    { "echasnovski/mini.icons", lazy = false },
    { "nvim-tree/nvim-web-devicons" }
  },
  config = function()
    local oil = require("oil")
    oil.setup({
      -- Show dotfiles generally, but keep `.git` hidden while `.gitignore` stays visible.
      -- This makes it easy to browse things like `.github/` while still
      -- avoiding noisy VCS internals.
      view_options = {
        is_hidden_file = function(name, _bufnr)
          -- Hide the `.git` directory entirely (including its contents),
          -- but keep `.gitignore` visible.
          return name == ".git"
        end,
      },
    })
    vim.keymap.set("n", "-", oil.toggle_float, {})
  end,
  lazy = false,
}
