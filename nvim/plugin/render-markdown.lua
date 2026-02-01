if vim.g.did_load_rendermarkdown_plugin then
  return
end
vim.g.did_load_rendermarkdown_plugin = true

require('render-markdown').setup()

vim.schedule(function()
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
end)
