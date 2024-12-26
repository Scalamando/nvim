return {
  'catppuccin/nvim',
  name = 'catppuccin-nvim',
  priority = 1000,
  opts = {
    flavour = 'macchiato',
    integrations = {
      fzf = true,
      gitsings = true,
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
  config = function()
    vim.cmd.colorscheme 'catppuccin'
  end,
}
