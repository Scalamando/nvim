if vim.g.did_load_snacks_plugin then
  return
end
vim.g.did_load_snacks_plugin = true

vim.keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification History' })

vim.keymap.set('n', '<leader>un', function()
  Snacks.notifier.hide()
end, { desc = 'Dismiss All Notifications' })

-- Lazygit
vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'LazyGit' })

-- File picker
vim.keymap.set('n', '<leader><space>', function()
  Snacks.picker.files {
    finder = 'files',
    format = 'file',
    show_empty = true,
    hidden = true,
    supports_live = true,
  }
end, { desc = 'Find Files' })

-- File grep
vim.keymap.set('n', '<leader>/', function()
  Snacks.picker.grep {
    finder = 'grep',
    format = 'file',
    regex = true,
    hidden = true,
    live = true,
    supports_live = true,
    show_empty = true,
  }
end, { desc = 'Grep Files' })

-- Navigate buffers
vim.keymap.set('n', '<S-h>', function()
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
end, { desc = 'Find Buffers' })

require('snacks').setup {
  bigfile = { enabled = true },
  quickfile = { enabled = true },
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
          ['<Down>'] = { 'history_forward', mode = { 'i', 'n' } },
          ['<Up>'] = { 'history_back', mode = { 'i', 'n' } },
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
}
