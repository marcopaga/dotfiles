return {
  "epwalsh/obsidian.nvim",
  version = "*", -- use latest release
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "marco",
        path = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Marco"),
      },
    },

    -- Store daily notes in a dedicated subfolder
    daily_notes = {
      folder = "Daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %-d, %Y",
      default_tags = { "daily" },
    },

    -- Completion: disable nvim-cmp source; LazyVim 14+ uses blink.cmp by default.
    -- obsidian.nvim registers its own blink.cmp source automatically.
    completion = {
      nvim_cmp = false,
      min_chars = 2,
    },

    -- Key mappings (buffer-local, only active inside vault markdown files)
    mappings = {
      -- Follow links with gf
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle checkboxes
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action: follow link or toggle checkbox
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },

    -- New notes go in the vault root by default
    new_notes_location = "current_dir",

    -- Open URLs in the default macOS browser
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,

    -- Use fzf-lua for search / quick-switch (LazyVim 14+ default picker)
    picker = {
      name = "fzf-lua",
    },

    -- Sort search results by last modified
    sort_by = "modified",
    sort_reversed = true,

    -- UI: concealing and extmarks (requires conceallevel >= 1)
    ui = {
      enable = true,
    },

    -- Images: paste into assets/imgs/
    attachments = {
      img_folder = "assets/imgs",
    },
  },
}
