vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

opt.breakindent = true -- Enable break indent
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Warn user before closing a buffer with unsaved changes
opt.cursorline = true -- Show which line your cursor is on
opt.expandtab = true -- Use spaces instead of tabs
opt.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.foldenable = true
opt.formatoptions = 'jcroqlnt'
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.hlsearch = true -- Highlight search results
opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.inccommand = 'split' -- Preview substitutions live, as you type!
opt.list = true -- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example!
opt.number = true -- Make line numbers default
opt.relativenumber = true -- Use relative line numbers
opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.showmode = false -- Don't show the mode, since it's already in the status line
opt.signcolumn = 'yes' -- Keep signcolumn on by default
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.swapfile = false -- Disable swap files
opt.tabstop = 4 -- Number of spaces tabs count for
opt.timeoutlen = 300 -- Decrease mapped sequence wait time, displays which-key popup sooner
opt.undofile = true -- Save undo history
opt.updatetime = 250 -- Decrease update time
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.wrap = false -- Disable line wrap
opt.clipboard = 'unnamedplus'

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end

local icons = require('config.icons').diagnostics
vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic(icons.ERROR, diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic(icons.WARN, diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic(icons.INFO, diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic(icons.HINT, diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  signs = {
    text = {
      -- Requires Nerd fonts
      [vim.diagnostic.severity.ERROR] = icons.ERROR,
      [vim.diagnostic.severity.WARN] = icons.WARN,
      [vim.diagnostic.severity.INFO] = icons.INFO,
      [vim.diagnostic.severity.HINT] = icons.HINT,
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

-- Native plugins
cmd.filetype('plugin', 'indent', 'on')

-- Filetypes
vim.filetype.add {
  -- Detect and assign filetype based on the extension of the filename
  extension = {
    mdx = 'mdx',
    log = 'log',
    conf = 'conf',
    env = 'dotenv',
  },
  -- Detect and apply filetypes based on the entire filename
  filename = {
    ['.env'] = 'dotenv',
    ['env'] = 'dotenv',
    ['tsconfig.json'] = 'jsonc',
  },
  -- Detect and apply filetypes based on certain patterns of the filenames
  pattern = {
    -- Match filenames like - ".env.example", ".env.local" and so on
    ['%.env%.[%w_.-]+'] = 'dotenv',
    -- Match filenames like - "tsconfig.app.json", "tsconfig.node.json" and so on
    ['tsconfig%.[%w_.-]+%.json'] = 'jsonc',
  },
}

-- Load configured LSPs
local lsp_configs = {
  'astro',
  'basedpyright',
  'docker_compose_language_service',
  'dockerls',
  'emmet_language_server',
  'gopls',
  'intelephense',
  'jsonls',
  'lua_ls',
  'marksman',
  'nixd',
  'ruff',
  'sqruff',
  'tailwindcss',
  'tinymist',
  'vtsls',
  'vue_ls',
}
vim.lsp.enable(lsp_configs)
