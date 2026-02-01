return {
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
  },
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vim.fs.dirname(vim.fn.exepath 'vue-language-server') ..
                '/../lib/language-tools/packages/language-server',
            languages = { 'vue' },
            configNamespace = 'typescript',
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
    typescript = {
      tsserver = { maxTsServerMemory = 8192 },
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
  on_attach = function()
    local lsp = require('config.lsp')
    vim.keymap.set(
      'n',
      'gd',
      function()
        local params = vim.lsp.util.make_position_params()
        lsp.execute {
          command = 'typescript.gotosourcedefinition',
          arguments = { params.textdocument.uri, params.position },
          open = true,
        }
      end,
      { desc = 'goto source definition', buffer = true }
    )
    vim.keymap.set(
      'n',
      'gr',
      function()
        lsp.execute {
          command = 'typescript.findallfilereferences',
          arguments = { vim.uri_from_bufnr(0) },
          open = true,
        }
      end,
      { desc = 'file references', buffer = true }
    )
    vim.keymap.set(
      'n',
      '<leader>co',
      lsp.action['source.organizeimports'],
      { desc = 'organize imports', buffer = true }
    )
    vim.keymap.set(
      'n',
      '<leader>cm',
      lsp.action['source.addmissingimports.ts'],
      { desc = 'add missing imports', buffer = true }
    )
    vim.keymap.set(
      'n',
      '<leader>cu',
      lsp.action['source.removeunused.ts'],
      { desc = 'remove unused imports', buffer = true }
    )
    vim.keymap.set(
      'n',
      '<leader>cd',
      lsp.action['source.fixall.ts'],
      { desc = 'fix all diagnostics', buffer = true }
    )
    vim.keymap.set('n', '<leader>cV',
      function()
        lsp.execute { command = 'typescript.selectTypeScriptVersion' }
      end,
      { desc = 'Select TS workspace version', buffer = true }
    )
  end
}
