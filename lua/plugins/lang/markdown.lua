return {
  {
    'folke/which-key.nvim',
    opts = {
      spec = {
        { '<leader>o', group = 'obsidian', mode = { 'v', 'n' }, icon = "" },
        { '<leader>m', group = 'markdown', mode = { 'v', 'n' }, icon = "" },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        marksman = {},
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        markdown = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
      },
    },
  },

  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>co', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = {
      auto_jump = true,
    },
  },

  {
    'epwalsh/obsidian.nvim',
    lazy = true,
    event = {
      'BufReadPre ' .. vim.fn.expand '~' .. '/notes/**/*.md',
      'BufNewFile ' .. vim.fn.expand '~' .. '/notes/**/*.md',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'folke/snacks.nvim',
      'MeanderingProgrammer/render-markdown.nvim',
    },
    keys = {
      {
        '<leader>ol',
        '<cmd>ObsidianLink<CR>',
        desc = 'Convert selection to link',
        mode = { 'v' },
        ft = 'markdown',
      },
      {
        '<leader>ou',
        '<cmd>ObsidianLinkNew<CR>',
        desc = 'Create and link note from selection',
        mode = { 'v' },
        ft = 'markdown',
      },
      {
        '<leader>od',
        '<cmd>ObsidianToday<CR>',
        desc = 'Open daily note',
      },
      {
        '<leader>os',
        '<cmd>ObsidianSearch<CR>',
        desc = 'Search for note',
      },
      {
        '<leader>ot',
        '<cmd>ObsidianTags<CR>',
        desc = 'Search for tags',
      },
      {
        '<leader>on',
        '<cmd>ObsidianNew<CR>',
        desc = 'Create new note',
      },
      {
        '<leader>ob',
        '<cmd>ObsidianBacklinks<CR>',
        desc = 'See backlinks for this note',
        ft = 'markdown',
      },
      {
        '<leader>oo',
        '<cmd>ObsidianOpen<CR>',
        desc = 'Open Obsidian Desktop',
      },
    },
    opts = {
      -- General
      workspaces = {
        {
          name = 'notes',
          path = '~/notes',
          overrides = {
            notes_subdir = '01_notes',
            daily_notes = {
              folder = '00_dailies',
              date_format = '%Y-%m-%d',
              default_tags = { 'daily-note' },
            },
          },
        },
      },
      completion = { blink = true },
      picker = { name = 'snacks.pick' },
      ui = { enable = false },
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within the vault.
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
      },
      -- Notes
      wiki_link_func = function(opts)
        return require('obsidian.util').wiki_link_id_prefix(opts)
      end,
      note_id_func = function(title)
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          return title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          local suffix = ''
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. '-' .. suffix
        end
      end,
      note_frontmatter_func = function(note)
        if note.title and note.title ~= note.id then
          note:add_alias(note.title)
        end

        local out = { id = note.id, aliases = note.aliases, tags = note.tags }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        -- Create or update creation and update dates
        local now = os.date '!%Y-%m-%dT%TZ'
        if out.date_created == nil then
          out.date_created = now
        end
        out.date_updated = now

        return out
      end,
    },
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'markdown.mdx', 'codecompanion' },
    opts = {},
    config = function(_, opts)
      require('render-markdown').setup(opts)
      Snacks.toggle({
        name = 'Render Markdown',
        get = function()
          return require('render-markdown.state').enabled
        end,
        set = function(enabled)
          local m = require 'render-markdown'
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map '<leader>um'
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    keys = {
      {
        '<leader>mp',
        '<cmd>MarkdownPreviewToggle<cr>',
        desc = 'Markdown Preview',
        ft = 'markdown',
      },
    },
    config = function()
      vim.cmd [[do FileType]]
    end,
  },
}
