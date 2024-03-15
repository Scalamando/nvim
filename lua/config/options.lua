-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Non-standard filtypes
vim.filetype.add({
  extension = {
    bru = "bruno",
  },
})

-- Options
vim.g.autoformat = false

vim.opt.expandtab = false
vim.opt.swapfile = false
