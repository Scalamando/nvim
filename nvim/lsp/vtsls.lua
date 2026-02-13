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
            location = vim.fs.dirname(vim.fn.exepath 'vue-language-server') .. '/../lib/language-tools/packages/language-server',
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
  on_attach = function(client)
    local existing_capabilities = client.server_capabilities
    if vim.bo.filetype == 'vue' then
      existing_capabilities.semanticTokensProvider.full = false
    else
      existing_capabilities.semanticTokensProvider.full = true
    end

    local lsp = require 'config.lsp'
    Snacks.keymap.set('n', 'gD', function()
      local win = vim.api.nvim_get_current_win()
      local params = vim.lsp.util.make_position_params(win, client.offset_encoding or 'utf-8')
      lsp.execute {
        command = 'typescript.goToSourceDefinition',
        arguments = { params.textDocument.uri, params.position },
        open = true,
      }
    end, { desc = 'goto source definition', buffer = true })
    Snacks.keymap.set('n', 'gR', function()
      lsp.execute {
        command = 'typescript.findAllFileReferences',
        arguments = { vim.uri_from_bufnr(0) },
        open = true,
      }
    end, { desc = 'file references', buffer = true })
    Snacks.keymap.set('n', '<leader>co', lsp.action['source.organizeImports'], { desc = 'organize imports', buffer = true })
    Snacks.keymap.set('n', '<leader>cm', lsp.action['source.addMissingImports.ts'], { desc = 'add missing imports', buffer = true })
    Snacks.keymap.set('n', '<leader>cu', lsp.action['source.removeUnused.ts'], { desc = 'remove unused imports', buffer = true })
    Snacks.keymap.set('n', '<leader>ce', lsp.action['source.fixAll.ts'], { desc = 'fix all diagnostics', buffer = true })
    Snacks.keymap.set('n', '<leader>cV', function()
      lsp.execute { command = 'typescript.selectTypeScriptVersion' }
    end, { desc = 'Select TS workspace version', buffer = true })
  end,
}
