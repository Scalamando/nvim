return {
  'catppuccin/nvim',
  name = 'catppuccin-nvim',
  lazy = false,
  priority = 1000,
  opts = {
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
      telescope = true,
    },
  },
  config = function(_, opts)
    require('catppuccin').setup(opts)
    vim.cmd.colorscheme 'catppuccin'
  end,
}
