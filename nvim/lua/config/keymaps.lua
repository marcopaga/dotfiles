-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- neue Datei im Verzeichnis des aktuellen Puffers
vim.keymap.set("n", "<leader>fn", function()
  local dir = vim.fn.expand("%:p:h")
  local name = vim.fn.input("Neue Datei: ", dir .. "/")
  if name ~= "" then
    vim.cmd("e " .. name)
  end
end, { desc = "Neue Datei erstellen" })
