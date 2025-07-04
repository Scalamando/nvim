return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    opts = function()
      local diagnostic_icons = {
        ERROR = ' ',
        WARN = ' ',
        HINT = ' ',
        INFO = ' ',
      }

      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = 'if_many',
            prefix = function(diagnostic)
              for d, icon in pairs(diagnostic_icons) do
                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                  return icon
                end
              end
            end,
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
              [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
              [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
              [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
            },
          },
        },
        inlay_hints = {
          enabled = true,
          exclude = { 'vue' },
        },
        codelens = {
          enabled = false,
        },
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        servers = {},
        setup = {},
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('config_lsp_attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mapopts)
            vim.keymap.set('n', keys, func, vim.tbl_extend('force', { buffer = event.buf, desc = desc }, mapopts or {}))
          end

          map('<leader>cl', '<CMD>LspInfo<CR>', 'Lsp Info')
          map('gd', Snacks.picker.lsp_definitions, 'Goto Definition')
          map('gr', Snacks.picker.lsp_references, 'References', { nowait = true })
          map('gI', Snacks.picker.lsp_implementations, 'Goto Implementation')
          map('gy', Snacks.picker.lsp_type_definitions, 'Goto T[y]pe Definition')
          map('K', vim.lsp.buf.hover, 'Hover')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
          map('<leader>cA', function()
            return vim.lsp.buf.code_action { apply = true, context = { only = { 'source' }, diagnostics = {} } }
          end, 'Source Action')
          map('<leader>cr', vim.lsp.buf.rename, 'Rename')
          map('<leader>ccd', Snacks.picker.lsp_symbols, 'Document Symbols')
          map('<leader>ccw', Snacks.picker.lsp_workspace_symbols, 'Workspace Symbols')

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- inlay hints
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            Snacks.toggle.inlay_hints():map '<leader>uh'
          end
        end,
      })

      -- setup diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('blink.cmp').get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      for server_name, config in pairs(opts.servers) do
        local server_opts = vim.tbl_deep_extend('force', {
          capabilities = vim.deepcopy(capabilities),
        }, config or {})
        vim.lsp.config(server_name, server_opts)
        vim.lsp.enable(server_name)
      end
    end,
  },

  -- Import language specific configurations
  { import = 'plugins.lang' },

  { -- Completion with support for LSPs and external sources
    'saghen/blink.cmp',
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
      { 'L3MON4D3/LuaSnip', name = 'luasnip' },
      {
        'saghen/blink.compat',
        lazy = true, -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        opts = {},
      },
    },
    lazy = false,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<C-e>'] = { 'hide' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
      },
      signature = { enabled = true },
      snippets = {
        preset = 'luasnip',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'codecompanion' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
}
