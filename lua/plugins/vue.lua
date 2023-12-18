return {
  -- add vue to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "vue", "typescript", "javascript", "css" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.volar
        volar = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
        },
      },
    },
  },
}
