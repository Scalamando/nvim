if vim.g.did_load_grugfar_plugin then
  return
end
vim.g.did_load_grugfar_plugin = true

vim.keymap.set(
  { 'n', 'v' },
  '<leader>sr',
  function()
    local grug = require 'grug-far'
    local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
    grug.open {
      transient = true,
      prefills = {
        filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
      },
    }
  end,
  { desc = 'Search and Replace' }
)

require('grug-far').setup {
  headerMaxWidth = 80
}
