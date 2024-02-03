local neoconf_defaults = {
	volar = {
		enable = false,
	}
}

local function is_volar_enabled()
  return require("neoconf").get("volar", neoconf_defaults).enable
end

return {
  -- add vue to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if not is_volar_enabled() then
        return
      end

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
      setup = {
        volar = function()
          if not is_volar_enabled() then
            return true
          end
        end,
        tsserver = function()
          if is_volar_enabled() then
            return true
          end
        end,
      },
    },
  },
}
