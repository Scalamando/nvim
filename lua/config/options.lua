vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = nixCats 'have_nerd_font'
vim.g.godot_executable = os.execute("which godot")

local opt = vim.opt

opt.breakindent = true -- Enable break indent
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Warn user before closing a buffer with unsaved changes
opt.cursorline = true -- Show which line your cursor is on
opt.expandtab = true -- Use spaces instead of tabs
opt.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.formatoptions = 'jcroqlnt'
opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.hlsearch = true -- Highlight search results
opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.inccommand = 'split' -- Preview substitutions live, as you type!
opt.list = true -- Sets how neovim will display certain whitespace characters in the editor.
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
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
opt.tabstop = 4 -- Number of spaces tabs count for
opt.timeoutlen = 300 -- Decrease mapped sequence wait time, displays which-key popup sooner
opt.undofile = true -- Save undo history
opt.updatetime = 250 -- Decrease update time
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.wrap = false -- Disable line wrap
opt.swapfile = false -- Disable swap files
