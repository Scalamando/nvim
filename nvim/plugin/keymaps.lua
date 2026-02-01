if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- General QoL
map('n', '<leader>qq', '<CMD>qa<CR>', { desc = 'Quit All' })
map({ 'n', 'i', 'x', 's' }, '<C-s>', '<CMD>w<CR><ESC>', { desc = 'Save file' })
-- Clear search highlight
map('n', '<Esc>', '<CMD>nohlsearch<CR>')
-- Add undo break-points
map('i', ',', ',<C-g>u')
map('i', '.', '.<C-g>u')
map('i', ';', ';<C-g>u')

-- Better navigation
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Moves Line Down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Moves Line Up' })
-- Center viewport after navigation
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll Down' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll Up' })
-- Sane search https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = 'Next Search Result' })
map({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zzzv'", { expr = true, desc = 'Prev Search Result' })
map({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
-- Handle word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('v', '<', '<gv', { expr = true, silent = true })
map('v', '>', '>gv', { expr = true, silent = true })

-- Windows
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Go to Left Window', remap = true })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Go to Right Window', remap = true })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Go to Upper Window', remap = true })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Go to Lower Window', remap = true })
-- Resize
map('n', '<C-Left>', '<CMD>vertical resize -2<CR>', { desc = 'Decrease Window Width' })
map('n', '<C-Right>', '<CMD>vertical resize +2<CR>', { desc = 'Increase Window Width' })
map('n', '<C-Up>', '<CMD>resize +2<CR>', { desc = 'Increase Window Height' })
map('n', '<C-Down>', '<CMD>resize -2<CR>', { desc = 'Decrease Window Height' })

-- Select all
map({ 'n', 'v', 'x' }, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })

-- Better Clipboard
map('i', '<C-p>', '<C-r><C-p>+', { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })
map('x', '<leader>P', '"_dP', { noremap = true, silent = true, desc = 'Paste over selection without erasing unnamed register' })

-- diagnostic
local diagnostic_goto = function(count, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump { count = count, severity = severity, float = true }
  end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(1), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(-1), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(1, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(-1, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(1, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(-1, 'WARN'), { desc = 'Prev Warning' })
