if vim.g.did_load_neotree_plugin then
  return
end
vim.g.did_load_neotree_plugin = true

-- keymaps
vim.keymap.set('n', '\\', '<CMD>Neotree reveal<CR>', { desc = 'Open NeoTree', })

local function on_move(data)
  Snacks.rename.on_rename_file(data.source, data.destination)
end

local events = require 'neo-tree.events'

require 'neo-tree'.setup {
  sources = { 'filesystem', 'buffers', 'git_status' },
  open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
  event_handlers = {
    { event = events.FILE_MOVED,   handler = on_move },
    { event = events.FILE_RENAMED, handler = on_move },
  },
  filesystem = {
    bind_to_cwd = false,
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
    filtered_items = {
      always_show_by_pattern = {
        '.env*',
      },
    },
  },
  window = {
    position = 'float',
    mappings = {
      ['\\'] = 'close_window',
      ['l'] = 'open',
      ['h'] = 'close_node',
      ['O'] = {
        function(state)
          vim.ui.open(state.tree:get_node().path)
        end,
        desc = 'Open with System Application',
      },
    },
  },
  default_component_configs = {
    indent = {
      with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
    git_status = {
      symbols = {
        unstaged = '󰄱',
        staged = '󰱒',
      },
    },
  }
}

vim.api.nvim_create_autocmd('TermClose', {
  pattern = '*lazygit',
  callback = function()
    if package.loaded['neo-tree.sources.git_status'] then
      require('neo-tree.sources.git_status').refresh()
    end
  end,
})
