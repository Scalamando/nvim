return {
  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        { '<BS>', desc = 'Decrement Selection', mode = 'x' },
        { '<c-space>', desc = 'Increment Selection', mode = { 'x', 'n' } },
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'LazyFile', 'VeryLazy' },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment Selection' },
      { '<bs>', desc = 'Decrement Selection', mode = 'x' },
    },
    opts_extend = { 'ensure_installed' },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require('nvim-treesitter.install').prefer_git = true
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    enabled = true,
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      if require('util').is_loaded 'nvim-treesitter' then
        local opts = require('util').opts 'nvim-treesitter'
        require('nvim-treesitter.configs').setup { textobjects = opts.textobjects }
      end

      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require 'nvim-treesitter.textobjects.move' ---@type table<string,fun(...)>
      local configs = require 'nvim-treesitter.configs'
      for name, fn in pairs(move) do
        if name:find 'goto' == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module('textobjects.move')[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find '[%]%[][cC]' then
                  vim.cmd('normal! ' .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    'windwp/nvim-ts-autotag',
    event = 'LazyFile',
    opts = {},
  },
}