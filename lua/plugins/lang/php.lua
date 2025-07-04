return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        intelephense = {
          init_options = {
            licenceKey = os.getenv("INTELEPHENSE_KEY")
          }
        },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        php = { 'phpcs' },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        php = { 'php_cs_fixer' },
      },
    },
  },
}
