return {
  {
    'milanglacier/minuet-ai.nvim',
    name = 'minuet-ai-nvim',
    event = 'LazyFile',
    config = function()
      require('minuet').setup {
        n_completions = 1,
        context_window = 512,
        provider = 'openai_fim_compatible',
        request_timeout = 5,
        provider_options = {
          openai_fim_compatible = {
            model = 'qwen2.5-coder:3b',
            end_point = 'http://localhost:11434/v1/completions',
            name = 'Ollama',
            stream = true,
            api_key = 'TERM',
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { 'typescript', 'javascript', 'python', 'lua', 'go' },
          keymap = {
            -- accept whole completion
            accept = '<A-A>',
            -- accept one line
            accept_line = '<A-a>',
            -- accept n lines (prompts for number)
            accept_n_lines = '<A-z>',
            -- Cycle to prev completion item, or manually invoke completion
            prev = '<A-[>',
            -- Cycle to next completion item, or manually invoke completion
            next = '<A-]>',
            dismiss = '<A-e>',
          },
        },
      }
    end,
  },
}
