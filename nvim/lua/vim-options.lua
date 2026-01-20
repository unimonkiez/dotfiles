vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.swapfile = false
vim.opt.showtabline = 2 -- Always show tabline
vim.wo.number = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Using 'nowait' and 'silent' to override plugin defaults
vim.keymap.set('n', '<leader>n', function() vim.cmd('tabnew') Snacks.dashboard() end, { silent = true, nowait = true })
vim.keymap.set('n', '<leader>w', ':q<CR>', { silent = true, nowait = true })

for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, i .. 'gt', { silent = true, nowait = true })
end

vim.keymap.set('n', '<leader>l', ':tabnext<CR>', { silent = true, nowait = true })
vim.keymap.set('n', '<leader>h', ':tabprevious<CR>', { silent = true, nowait = true })
