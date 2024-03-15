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
    opts = function(_, opts)
      local mason_registry = require("mason-registry")
      local has_volar, volar = pcall(mason_registry.get_package, "vue-language-server")
      local vue_ts_plugin_path = has_volar
        and volar:get_install_path() .. "/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"
      -- after volar 2.0.7
      -- local vue_ts_plugin_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/typescript-plugin'

      ---@type lspconfig.options.volar
      opts.servers.volar = {} -- make sure mason installs the server

      ---@type lspconfig.options.tsserver
      opts.servers.tsserver = {
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_ts_plugin_path, 
              languages = { "vue" },
            },
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          "vue",
        },
      }
    end,
  },
}
