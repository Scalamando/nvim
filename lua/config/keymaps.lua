-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- remove lazyterm bindings
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<c-/>")

-- toggleterm (bottom)
vim.keymap.set("n", "<A-n>", function()
  vim.cmd.ToggleTerm('direction="horizontal"')
end, { desc = "Toogle Terminal" })
vim.keymap.set("t", "<A-n>", function()
  vim.cmd.ToggleTerm('direction="horizontal"')
end, { desc = "Toogle Terminal" })

-- toggleterm (floating)
vim.keymap.set("n", "<A-i>", function()
  vim.cmd.ToggleTerm('direction="float"')
end, { desc = "Toogle Terminal (floating)" })
vim.keymap.set("t", "<A-i>", function()
  vim.cmd.ToggleTerm('direction="float"')
end, { desc = "Toogle Terminal (floating)" })


-- center view after jumps
vim.keymap.set("n", "<C-d>", "<C-d>", { desc = "Jump half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>", { desc = "Jump half page up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result" })
