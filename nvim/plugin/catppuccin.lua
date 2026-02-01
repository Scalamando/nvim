if vim.g.did_load_catppuccin_plugin then
  return
end
vim.g.did_load_catppuccin_plugin = true

require('catppuccin').setup {
  flavour = 'macchiato',
  transparent_background = true,
  integrations = {
    fzf = true,
    gitsigns = true,
    mini = true,
    neotree = true,
    noice = true,
    notify = true,
    snacks = true,
    treesitter = true,
    which_key = true,
  },
}

vim.cmd.colorscheme 'catppuccin'
