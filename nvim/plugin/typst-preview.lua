if vim.g.did_load_typstpreview_plugin then
  return
end
vim.g.did_load_typstpreview_plugin = true

vim.keymap.set('n', '<leader>tp', '<cmd>TypstPreview<CR>', { desc = 'Start preview' })
vim.keymap.set('n', '<leader>tm', function()
  vim.lsp.client:exec_cmd { title = 'Pin Main', command = 'tinymist.pinMain', arguments = { vim.api.nvim_buf_get_name(0) } }
end, {
  desc = 'Pin current file as main',
})

require('typst-preview').setup {
  port = 8765,
  dependencies_bin = {
    ['tinymist'] = 'tinymist',
    ['websocat'] = 'websocat',
  },
}
