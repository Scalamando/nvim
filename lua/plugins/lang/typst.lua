return {

  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        {
          mode = { 'n', 'v' },
          { '<leader>t', group = 'typst' },
        },
      },
    },
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = 'typstyle',
            exportPdf = 'onSave',
          },
        },
      },
    },
  },

  {
    'chomosuke/typst-preview.nvim',
    lazy = true,
    ft = 'typst',
    keys = {
      { '<leader>tp', '<cmd>TypstPreview<CR>', desc = 'Start preview', ft = 'typst' },
      {
        '<leader>tm',
        function()
          vim.lsp.buf.execute_command { command = 'tinymist.pinMain', arguments = { vim.api.nvim_buf_get_name(0) } }
        end,
        desc = 'Pin current file as main',
        ft = 'typst',
      },
    },
    opts = {
      port = 8765,
      dependencies_bin = {
        ['tinymist'] = 'tinymist',
        ['websocat'] = 'websocat',
      },
    },
  },
}
