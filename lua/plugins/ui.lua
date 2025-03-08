return {
  { -- statusline
    'echasnovski/mini.statusline',
    opts = {
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local git = MiniStatusline.section_git { trunc_width = 40 }
          local diff = MiniStatusline.section_diff { trunc_width = 75 }
          local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
          local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
          local filename = MiniStatusline.section_filename { trunc_width = 140 }
          local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local location = MiniStatusline.section_location { trunc_width = 75 }
          local search = MiniStatusline.section_searchcount { trunc_width = 75 }

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { mode } },
            { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = mode_hl, strings = { search, location } },
          }
        end,
      },
    },
  },

  { -- icons
    'echasnovski/mini.icons',
    lazy = true,
    opts = {
      file = {
        ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
        ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
      },
      filetype = {
        dotenv = { glyph = '', hl = 'MiniIconsYellow' },
      },
      extension = {
        ['test.ts'] = { glyph = '' },
        ['test.js'] = { glyph = '' },
        ['spec.ts'] = { glyph = '' },
        ['spec.js'] = { glyph = '' },
      },
    },
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

  { -- Terminal
    'akinsho/toggleterm.nvim',
    ---@type ToggleTermConfig
    opts = {
      open_mapping = [[<M-n>]],
      direction = 'vertical',
      on_create = function(t)
        vim.api.nvim_buf_set_keymap(t.bufnr, 't', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
      end,
      size = function(term)
        if term.direction == 'horizontal' then
          return 15
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.4
        end
      end,
    },
  },

  { -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
        {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = {
            skip = true,
          },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == 'lazy' then
        vim.cmd [[messages clear]]
      end
      require('noice').setup(opts)
    end,
  },

  -- ui components
  { 'MunifTanjim/nui.nvim', lazy = true },

  {
    'folke/snacks.nvim',
    opts = {
      indent = { enabled = true },
      input = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = false }, -- we set this in options.lua
      words = { enabled = true },
      image = { enabled = true },
      notifier = {
        enabled = true,
        top_down = false,
      },
      lazygit = {
        enabled = true,
        theme = {
          selectedLineBgColor = { bg = 'CursorLine' },
        },
        win = {
          width = 0,
          height = 0,
        },
      },
      picker = {
        layout = { preset = 'ivy', cycle = false },
        matcher = { frecency = true },
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
              ['J'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['K'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['H'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
              ['L'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true,
            truncate = 80,
          },
        },
        previewers = {
          diff = {
            builtin = true,
            cmd = { 'delta' },
          },
        },
      },
    },
    keys = {
      {
        '<leader>n',
        function()
          Snacks.notifier.show_history()
        end,
        desc = 'Notification History',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
      -- Lazygit
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'LazyGit',
      },
      -- File picker
      {
        '<leader><space>',
        function()
          Snacks.picker.files {
            finder = 'files',
            format = 'file',
            show_empty = true,
            hidden = true,
            supports_live = true,
          }
        end,
        desc = 'Find Files',
      },
      -- File grep
      {
        '<leader>/',
        function()
          Snacks.picker.grep {
            finder = 'grep',
            format = 'file',
            regex = true,
            hidden = true,
            live = true,
            supports_live = true,
            show_empty = true,
          }
        end,
        desc = 'Grep Files',
      },
      -- Navigate buffers
      {
        '<S-h>',
        function()
          Snacks.picker.buffers {
            -- Always start buffers picker in normal mode
            on_show = function()
              vim.cmd.stopinsert()
            end,
            finder = 'buffers',
            format = 'buffer',
            hidden = false,
            unloaded = true,
            current = true,
            sort_lastused = true,
            win = {
              input = {
                keys = {
                  ['d'] = 'bufdelete',
                },
              },
              list = { keys = { ['d'] = 'bufdelete' } },
            },
            layout = 'ivy',
          }
        end,
        desc = 'Find Buffers',
      },
    },
  },
}
