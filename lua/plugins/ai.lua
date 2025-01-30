return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = false,
    keys = {
      {
        '<leader>A',
        '<cmd>CodeCompanionActions<cr>',
        mode = { 'n', 'v' },
        { noremap = true, silent = true },
      },
      {
        '<leader>a',
        '<cmd>CodeCompanionChat Toggle<cr>',
        mode = { 'n', 'v' },
        { noremap = true, silent = true },
      },
      {
        'ga',
        '<cmd>CodeCompanionChat Add<cr>',
        mode = 'v',
        { noremap = true, silent = true },
      },
    },
    opts = {
      strategies = {
        chat = { adapter = 'ollama' },
        inline = { adapter = 'ollama' },
      },
      opts = {
        log_level = 'DEBUG',
      },
    },
  },
}
