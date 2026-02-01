if vim.g.did_load_toggleterm_plugin then
  return
end
vim.g.did_load_toggleterm_plugin = true

require('toggleterm').setup {
  open_mapping = [[<M-n>]],
  direction = 'vertical',
  on_create = function(t)
    vim.api.nvim_buf_set_keymap(t.bufnr, 't', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  end,
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.4
    end
  end,
}
