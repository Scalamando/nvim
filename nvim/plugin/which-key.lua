if vim.g.did_load_whichkey_plugin then
  return
end
vim.g.did_load_whichkey_plugin = true

require('which-key').setup {
  preset = 'helix',
  spec = {
    {
      mode = { 'n', 'v' },
      { '<leader>c', group = 'code' },
      { '<leader>f', group = 'file' },
      { '<leader>s', group = 'search' },
      { '<leader>g', group = 'git' },
      { '<leader>gh', group = 'hunks' },
      { '<leader>q', group = 'quit' },
      { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
      { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
      { '[', group = 'prev' },
      { ']', group = 'next' },
      { 'g', group = 'goto' },
      { 'gs', group = 'surround' },
      { 'z', group = 'fold' },
      {
        '<leader>b',
        group = 'buffer',
        expand = function()
          return require('which-key.extras').expand.buf()
        end,
      },
      {
        '<leader>w',
        group = 'windows',
        proxy = '<c-w>',
        expand = function()
          return require('which-key.extras').expand.win()
        end,
      },
      -- better descriptions
      { 'gx', desc = 'Open with system app' },
      { '\\', desc = 'Open NeoTree' },
      -- typst
      { '<leader>t', group = 'typst' },
    },
  },
}
