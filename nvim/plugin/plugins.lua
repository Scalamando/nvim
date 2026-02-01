if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

require('smear_cursor').setup() -- cursor animations
