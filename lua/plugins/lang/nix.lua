return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        nixd = {},
      },
    },
  },
}
