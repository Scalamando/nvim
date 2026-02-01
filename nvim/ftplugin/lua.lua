vim.bo.comments = ':---,:--'

if not vim.g.did_load_lazydev_plugin then
  vim.g.did_load_lazydev_plugin = true
  require('lazydev').setup {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      { path = 'snacks.nvim',        words = { 'Snacks' } },
      { path = 'mini.statusline',    words = { 'MiniStatusline' } },
    },
  }
end
