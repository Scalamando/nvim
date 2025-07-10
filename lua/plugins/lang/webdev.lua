local util = require 'util'

return {
  { -- JSON Schema
    'b0o/SchemaStore.nvim',
  },

  { -- typescript lsp
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            }
          }
        },
        astro = {},
        -- Vue
        vue_ls = {
          init_options = {
            vue = {
              hybridMode = true,
            },
            typescript = {
              tsdk = vim.fs.dirname(vim.fn.exepath 'vtsls') .. '/../lib/vtsls-language-server/node_modules/typescript/lib',
            },
          },
          on_new_config = function(new_config, new_root_dir)
            local lib_path = vim.fs.find('node_modules/typescript/lib', { path = new_root_dir, upward = true })[1]
            if lib_path then
              new_config.init_options.typescript.tsdk = lib_path
            end
          end,
        },
        -- Tailwindcss
        tailwindcss = {
          settings = {
            tailwindCSS = {
              -- For Phoenix projects
              includeLanguages = {
                elixir = 'html-eex',
                eelixir = 'html-eex',
                heex = 'html-eex',
              },
            },
          },
        },
        -- Typescript (and needed for others)
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
              'gd',
              function()
                local params = vim.lsp.util.make_position_params()
                util.lsp.execute {
                  command = 'typescript.gotosourcedefinition',
                  arguments = { params.textdocument.uri, params.position },
                  open = true,
                }
              end,
              desc = 'goto source definition',
            },
            {
              'gr',
              function()
                util.lsp.execute {
                  command = 'typescript.findallfilereferences',
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                }
              end,
              desc = 'file references',
            },
            {
              '<leader>co',
              util.lsp.action['source.organizeimports'],
              desc = 'organize imports',
            },
            {
              '<leader>cm',
              util.lsp.action['source.addmissingimports.ts'],
              desc = 'add missing imports',
            },
            {
              '<leader>cu',
              util.lsp.action['source.removeunused.ts'],
              desc = 'remove unused imports',
            },
            {
              '<leader>cd',
              util.lsp.action['source.fixall.ts'],
              desc = 'fix all diagnostics',
            },
            {
              '<leader>cV',
              function()
                util.lsp.execute { command = 'typescript.selectTypeScriptVersion' }
              end,
              desc = 'Select TS workspace version',
            },
          },
        },
        emmet_language_server = {
          filetypes = {
            'astro',
            'css',
            'eruby',
            'html',
            'htmlangular',
            'htmldjango',
            'javascript.jsx',
            'javascriptreact',
            'less',
            'pug',
            'sass',
            'scss',
            'typescript.tsx',
            'typescriptreact',
            'vue',
          },
        },
        -- Linter
        eslint = {
          settings = {
            workingDirectories = { mode = 'auto' },
            format = false,
          },
        },
      },
      setup = {
        vtsls = function(_, opts)
          opts.settings.javascript = vim.tbl_deep_extend('force', {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },

  { -- Formatting
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        css = { 'prettier' },
        graphql = { 'prettier' },
        handlebars = { 'prettier' },
        html = { 'prettier' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        less = { 'prettier' },
        scss = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
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
