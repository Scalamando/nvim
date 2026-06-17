if vim.g.did_load_typstpreview_plugin then
  return
end
vim.g.did_load_typstpreview_plugin = true

vim.keymap.set('n', '<leader>tp', '<cmd>TypstPreview<CR>', { desc = 'Start preview' })
vim.keymap.set('n', '<leader>tm', '<cmd>LspTinymistPinMain<CR>', {desc = 'Pin current file as main' })

require('typst-preview').setup {
  port = 8765,
  dependencies_bin = {
    ['tinymist'] = 'tinymist',
    ['websocat'] = 'websocat',
  },
}
