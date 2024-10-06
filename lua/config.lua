local neogit = require('neogit')
local gitsigns = require('gitsigns')

neogit.setup {
    integrations = {
        diffview = true
    }
}

gitsigns.setup()

vim.api.nvim_set_keymap('n', '<leader>gg', ":Neogit<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gd', ":DiffviewOpen<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gc', ":Neogit commit<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gp', ":Neogit push<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>gl', ":Neogit pull<CR>", {noremap = true, silent = true})