return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ruff = {
          init_options = {
            settings = {
              logLevel = 'error',
            },
          },
        },
        basedpyright = {},
        sqruff = {},
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        sql = { 'sqruff' },
        python = { 'ruff', 'injected' },
      },
    },
  },
}
