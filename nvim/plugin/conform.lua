-- Formatting

if vim.g.did_load_conform_plugin then
  return
end
vim.g.did_load_conform_plugin = true

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  require('conform').format { async = true }
end, { desc = 'Format Code' })
vim.keymap.set({ 'n', 'v' }, '<leader>cF', function()
  require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
end, { desc = 'Format Injected Langs' })

require('conform').setup {
  default_format_opts = {
    lsp_format = 'fallback',
    timeout_ms = 3000,
  },
  formatters_by_ft = {
    json = { 'oxfmt', 'prettier', stop_after_first = true },
    jsonc = { 'oxfmt', 'prettier', stop_after_first = true },
    yaml = { 'oxfmt', 'prettier', stop_after_first = true },
    just = { 'just' },
    -- webdev
    css = { 'oxfmt', 'prettier', stop_after_first = true },
    graphql = { 'oxfmt', 'prettier', stop_after_first = true },
    handlebars = { 'oxfmt', 'prettier', stop_after_first = true },
    html = { 'oxfmt', 'prettier', stop_after_first = true },
    javascript = { 'oxfmt', 'prettier', stop_after_first = true },
    javascriptreact = { 'oxfmt', 'prettier', stop_after_first = true },
    less = { 'oxfmt', 'prettier', stop_after_first = true },
    scss = { 'oxfmt', 'prettier', stop_after_first = true },
    typescript = { 'oxfmt', 'prettier', stop_after_first = true },
    typescriptreact = { 'oxfmt', 'prettier', stop_after_first = true },
    vue = { 'oxfmt', 'prettier', stop_after_first = true },
    -- golang
    go = { 'goimports', 'gofumpt' },
    -- lua
    lua = { 'stylua' },
    -- markdown
    markdown = { 'oxfmt', 'prettier', stop_after_first = true },
    ['markdown.mdx'] = { 'oxfmt', 'prettier', stop_after_first = true },
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
    oxfmt = {
      cwd = require('conform.util').root_file { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts' },
      require_cwd = true,
    },
  },
}
