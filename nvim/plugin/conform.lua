-- Formatting

if vim.g.did_load_conform_plugin then
  return
end
vim.g.did_load_conform_plugin = true

vim.keymap.set(
  { 'n', 'v' },
  '<leader>cf',
  function()
    require('conform').format { async = true }
  end,
  { desc = 'Format Code', }
)
vim.keymap.set(
  { 'n', 'v' },
  '<leader>cF',
  function()
    require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
  end,
  { desc = 'Format Injected Langs', }
)

require('conform').setup {
  default_format_opts = {
    lsp_format = 'fallback',
    timeout_ms = 3000,
  },
  formatters_by_ft = {
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    just = { 'just' },
    -- webdev
    css = { 'prettier' },
    graphql = { 'prettier' },
    handlebars = { 'prettier' },
    html = { 'prettier' },
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    less = { 'prettier' },
    scss = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    vue = { 'prettier' },
    -- golang
    go = { 'goimports', 'gofumpt' },
    -- lua
    lua = { 'stylua' },
    -- markdown
    markdown = { 'prettier' },
    ['markdown.mdx'] = { 'prettier' },
    -- nix
    nix = { 'alejandra' },
    -- php
    php = { 'php_cs_fixer' },
    -- python
    python = { 'ruff', 'injected' },
    -- sql
    sql = { 'sqruff' },
    -- ruby
    ruby = { 'rubyfmt' },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
  },
}
