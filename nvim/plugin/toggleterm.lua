if vim.g.did_load_toggleterm_plugin then
  return
end
vim.g.did_load_toggleterm_plugin = true

local toggleterm_config = require 'toggleterm.config'
local toggleterm_terminal = require 'toggleterm.terminal'

local follow_output = true

local set_follow_output = function(enabled)
  follow_output = enabled
  toggleterm_config.set { auto_scroll = enabled }

  for _, term in ipairs(toggleterm_terminal.get_all(true)) do
    term.auto_scroll = enabled
  end
end

require('toggleterm').setup {
  open_mapping = [[<M-n>]],
  direction = 'vertical',
  auto_scroll = follow_output,
  -- Keep output callbacks installed even when follow_output is off, so the
  -- setting can be toggled for already-running terminals.
  on_stdout = function() end,
  on_stderr = function() end,
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
}

vim.api.nvim_create_user_command('ToggleTermFollowOutput', function()
  set_follow_output(not follow_output)
  vim.notify(('ToggleTerm follow output: %s'):format(follow_output and 'on' or 'off'))
end, { desc = 'Toggle ToggleTerm auto-scroll/follow output' })

vim.schedule(function()
  Snacks.toggle({
    name = 'ToggleTerm Follow Output',
    get = function()
      return follow_output
    end,
    set = set_follow_output,
  }):map '<leader>ut'
end)
