return {
  { -- Formatting
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = 'fallback', -- not recommended to change
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'alejandra' },
        css = { 'prettier' },
        graphql = { 'prettier' },
        handlebars = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        less = { 'prettier' },
        markdown = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
        scss = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        yaml = { 'prettier' },
        just = { 'just' },
        ruby = { 'rubyfmt' },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
}
