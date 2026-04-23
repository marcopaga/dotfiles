-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Required by obsidian.nvim: enables concealing of markup characters and
-- link/checkbox rendering. LazyVim already defaults to 2, but keep it
-- explicit so the intent is clear.
vim.opt.conceallevel = 2

vim.opt.spelllang = { "en", "de" }
