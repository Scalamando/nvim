return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {},
        neocmake = {},
      },
    },
  },

  { -- Formatting
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        c = { 'clang-format' },
        cpp = { 'clang-format' },
      },
    },
  },
}
