local util = require 'util'

return {
  { -- typescript lsp
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        volar = {
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
        },
        vtsls = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
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
                    location = vim.fs.dirname(vim.fn.exepath 'vue-language-server') .. '/../lib/node_modules/@vue/language-server',
                    languages = { 'vue' },
                    configNamespace = 'typescript',
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
            },
            typescript = {
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
          keys = {
            {
              'gD',
              function()
                local params = vim.lsp.util.make_position_params()
                util.lsp.execute {
                  command = 'typescript.goToSourceDefinition',
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                }
              end,
              desc = 'Goto Source Definition',
            },
            {
              'gR',
              function()
                util.lsp.execute {
                  command = 'typescript.findAllFileReferences',
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                }
              end,
              desc = 'File References',
            },
            {
              '<leader>co',
              util.lsp.action['source.organizeImports'],
              desc = 'Organize Imports',
            },
            {
              '<leader>cM',
              util.lsp.action['source.addMissingImports.ts'],
              desc = 'Add missing imports',
            },
            {
              '<leader>cu',
              util.lsp.action['source.removeUnused.ts'],
              desc = 'Remove unused imports',
            },
            {
              '<leader>cD',
              util.lsp.action['source.fixAll.ts'],
              desc = 'Fix all diagnostics',
            },
            {
              '<leader>cV',
              function()
                util.lsp.execute { command = 'typescript.selectTypeScriptVersion' }
              end,
              desc = 'Select TS workspace version',
            },
          },
          setup = {
            vtsls = function(_, opts)
              opts.settings.javascript = vim.tbl_deep_extend('force', {}, opts.settings.typescript, opts.settings.javascript or {})
            end,
          },
        },
      },
    },
  },

  { -- Filetype icons
    'echasnovski/mini.icons',
    opts = {
      file = {
        ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
        ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
        ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
      },
    },
  },
}
