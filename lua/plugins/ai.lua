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
        chat = { adapter = 'anthropic' },
        inline = { adapter = 'anthropic' },
      },
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = os.getenv 'ANTHROPIC_API_KEY',
            },
          })
        end,
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = {
              api_key = os.getenv 'OPENAI_API_KEY',
            },
          })
        end,
      },
    },
  },
}
