local nvim_lsp = require('lspconfig')
local cmp = require('cmp')

-- Function to get Python path
local function get_python_path()
    local venv = vim.fn.getenv('VIRTUAL_ENV')
    if venv ~= vim.NIL and venv ~= '' then
        return venv .. '\\Scripts\\python.exe'
    end
    
    local handle = io.popen('powershell -Command "& {(Get-Command python).Source}"')
    local result = handle:read("*a")
    handle:close()
    
    result = result:gsub("[\n\r]", "")
    if result ~= '' then
        return result
    end
   
    return 'python'
end

-- LSP setup
nvim_lsp.pyright.setup{
    on_attach = function(client, bufnr)
       -- Keybindings for LSP functions
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = { noremap=true, silent=true }

        -- Use leader key to avoid conflicts
        buf_set_keymap('n', '<leader>sd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', '<leader>sh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', '<leader>si', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<leader>ss', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<leader>sr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<leader>sn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<leader>sa', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', '<leader>sf', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        buf_set_keymap('n', '<leader>sp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', '<leader>sn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<leader>sl', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    end,
    before_init = function(_, config)
        config.settings.python.pythonPath = get_python_path()
    end,
}

-- nvim-cmp setup
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),  -- Use preset mappings for command line
    sources = {
        { name = 'buffer' },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- Command line completion setup for `:`
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
    }, {
        { name = 'cmdline' },
    })
})
