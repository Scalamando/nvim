return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        gdscript = {},
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        gdscript = { 'gdformat' },
      },
    },
  },
}
