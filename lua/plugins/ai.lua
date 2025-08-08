return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'ravitemer/codecompanion-history.nvim',
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
      extensions = {
        history = {
          enabled = true,
          opts = {
            -- Memory system (requires VectorCode CLI)
            memory = {
              -- Automatically index summaries when they are generated
              auto_create_memories_on_summary_generation = true,
              -- Path to the VectorCode executable
              vectorcode_exe = 'vectorcode',
              -- Tool configuration
              tool_opts = {
                -- Default number of memories to retrieve
                default_num = 10,
              },
              -- Enable notifications for indexing progress
              notify = true,
              -- Index all existing memories on startup
              -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
              index_on_startup = false,
            },
          },
        },
      },
    },
  },
}
