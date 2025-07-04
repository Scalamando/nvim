return {
  { -- Formatting
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true }
        end,
        mode = { 'n', 'v' },
        desc = 'Format Code',
      },
      {
        '<leader>cF',
        function()
          require('conform').format { formatters = { 'injected' }, timeout_ms = 3000 }
        end,
        mode = { 'n', 'v' },
        desc = 'Format Injected Langs',
      },
    },
    opts = {
      default_format_opts = {
        lsp_format = 'fallback',
        timeout_ms = 3000,
      },
      formatters_by_ft = {
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        just = { 'just' },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
}
