return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
              doc = {
                privateName = { '^_' },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = 'Disable',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
              },
              -- Ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = {
                globals = { 'nixCats', 'vim' },
              },
            },
          },
        },
      },
    },
  },
}
