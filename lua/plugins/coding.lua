return {
  { 'tpope/vim-sleuth' },

  -- auto pairs
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { 'string' },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },

  {
    'echasnovski/mini.surround',
    opts = {
      mappings = {
        add = 'gsa',
        delete = 'gsd',
        find = 'gsf',
        find_left = 'gsF',
        highlight = 'gsh',
        replace = 'gsr',
        update_n_lines = 'gsn',
      },
    },
  },

  -- comments
  {
    'folke/ts-comments.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  { -- Better text-objects
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require 'mini.ai'
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter { -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
          c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
          d = { '%f[%d]%d+' }, -- digits
          e = { -- Word with case
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          g = function(ai_type) -- taken from MiniExtra.gen_ai_spec.buffer
            local start_line, end_line = 1, vim.fn.line '$'
            if ai_type == 'i' then
              -- Skip first and last blank lines for `i` textobject
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
              -- Do nothing for buffer with all blanks
              if first_nonblank == 0 or last_nonblank == 0 then
                return { from = { line = start_line, col = 1 } }
              end
              start_line, end_line = first_nonblank, last_nonblank
            end

            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = '[%w_]' }, -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
      require('util').on_load('which-key.nvim', function()
        vim.schedule(function()
          -- register all text objects with which-key
          local objects = {
            { ' ', desc = 'whitespace' },
            { '"', desc = '" string' },
            { "'", desc = "' string" },
            { '(', desc = '() block' },
            { ')', desc = '() block with ws' },
            { '<', desc = '<> block' },
            { '>', desc = '<> block with ws' },
            { '?', desc = 'user prompt' },
            { 'U', desc = 'use/call without dot' },
            { '[', desc = '[] block' },
            { ']', desc = '[] block with ws' },
            { '_', desc = 'underscore' },
            { '`', desc = '` string' },
            { 'a', desc = 'argument' },
            { 'b', desc = ')]} block' },
            { 'c', desc = 'class' },
            { 'd', desc = 'digit(s)' },
            { 'e', desc = 'CamelCase / snake_case' },
            { 'f', desc = 'function' },
            { 'g', desc = 'entire file' },
            { 'i', desc = 'indent' },
            { 'o', desc = 'block, conditional, loop' },
            { 'q', desc = 'quote `"\'' },
            { 't', desc = 'tag' },
            { 'u', desc = 'use/call' },
            { '{', desc = '{} block' },
            { '}', desc = '{} with ws' },
          }

          ---@type wk.Spec[]
          local ret = { mode = { 'o', 'x' } }
          ---@type table<string, string>
          local mappings = vim.tbl_extend('force', {}, {
            around = 'a',
            inside = 'i',
            around_next = 'an',
            inside_next = 'in',
            around_last = 'al',
            inside_last = 'il',
          }, opts.mappings or {})
          mappings.goto_left = nil
          mappings.goto_right = nil

          for name, prefix in pairs(mappings) do
            name = name:gsub('^around_', ''):gsub('^inside_', '')
            ret[#ret + 1] = { prefix, group = name }
            for _, obj in ipairs(objects) do
              local desc = obj.desc
              if prefix:sub(1, 1) == 'i' then
                desc = desc:gsub(' with ws', '')
              end
              ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
            end
          end
          require('which-key').add(ret, { notify = false })
        end)
      end)
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = 'mini.statusline', words = { 'MiniStatusline' } },
        { path = 'lazy.nvim', words = { 'LazyVim' } },
        { path = (require('nixCats').nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
      },
    },
  },
}
