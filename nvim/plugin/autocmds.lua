if vim.g.did_load_autocmds_plugin then
  return
end
vim.g.did_load_autocmds_plugin = true

local function augroup(name)
  return vim.api.nvim_create_augroup('config_' .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = augroup 'highlight_yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'git',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'json_conceal',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('config_lsp_attach', { clear = true }),
  callback = function(event)
    local map = function(mode, keys, func, desc, mapopts)
      vim.keymap.set(mode, keys, func, vim.tbl_extend('force', { buffer = event.buf, desc = desc }, mapopts or {}))
    end

    map('n', '<leader>cl', '<CMD>LspInfo<CR>', 'Lsp Info')
    map('n', 'gd', Snacks.picker.lsp_definitions, 'Goto Definition')
    map('n', 'gr', Snacks.picker.lsp_references, 'References', { nowait = true })
    map('n', 'gI', Snacks.picker.lsp_implementations, 'Goto Implementation')
    map('n', 'gy', Snacks.picker.lsp_type_definitions, 'Goto T[y]pe Definition')
    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map({ 'n', 'v' }, '<leader>cA', function()
      return vim.lsp.buf.code_action { apply = true, context = { only = { 'source' }, diagnostics = {} } }
    end, 'Source Action')
    map('n', '<leader>cr', vim.lsp.buf.rename, 'Rename')
    map('n', '<leader>ccd', Snacks.picker.lsp_symbols, 'Document Symbols')
    map('n', '<leader>ccw', Snacks.picker.lsp_workspace_symbols, 'Workspace Symbols')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- inlay hints
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      Snacks.toggle.inlay_hints():map '<leader>uh'
    end
  end,
})
