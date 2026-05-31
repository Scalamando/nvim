if vim.g.did_load_terminal_plugin then
  return
end
vim.g.did_load_terminal_plugin = true

local terminal_opts = {
  auto_insert = false,
  win = {
    position = 'right',
    wo = { winbar = '' },
    width = 0.4,
  },
}

local pi_terminal_opts = {
  auto_insert = false,
  win = {
    border = 'rounded',
    height = 0.9,
    footer = ' pi ',
    footer_pos = 'center',
    wo = { winbar = '' },
    width = 0.9,
  },
}

vim.keymap.set({ 'n', 'i', 't' }, '<M-n>', function()
  Snacks.terminal.toggle(nil, terminal_opts)
end, { desc = 'Toggle Terminal' })

vim.keymap.set({ 'n', 'i' }, '<leader>ap', function()
  Snacks.terminal.toggle('pi', pi_terminal_opts)
end, { desc = 'Toggle Pi Terminal' })
