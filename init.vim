call plug#begin('C:/Users/ashry/AppData/Local/nvim-data/plugged')
" Existing plugins
Plug 'https://github.com/junegunn/vim-easy-align.git'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug '~/my-prototype-plugin'
Plug 'tomasiser/vim-code-dark'
Plug 'jmbuhr/otter.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'quarto-dev/quarto-nvim'
Plug 'benlubas/molten-nvim'
Plug 'willothy/wezterm.nvim'

" Add LSP and autocomplete plugins
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Git integration
Plug 'TimUntersberger/neogit'
Plug 'sindrets/diffview.nvim'
Plug 'nvim-lua/plenary.nvim'  " Required by Neogit
Plug 'lewis6991/gitsigns.nvim'

" Add fugitive for git integration (needed for some FZF commands)
Plug 'tpope/vim-fugitive'

" Add UltiSnips for snippets support
Plug 'SirVer/ultisnips'

" Add Vim-Sneak
Plug 'justinmk/vim-sneak'

" Add EasyMotion
Plug 'easymotion/vim-easymotion'

" Add vim-visual-multi for multiple cursors
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Add vim-virtualenv for Python environment management
Plug 'jmcantrell/vim-virtualenv'

" Add NeoSolarized colorscheme
Plug 'Tsuzat/NeoSolarized.nvim', { 'branch': 'master' }

" Add Meatball Notebook
Plug 'meatballs/notebook.nvim'

call plug#end()

" Quatro Configuration
lua << EOF
local ok, quarto = pcall(require, "quarto")
if ok then
    quarto.setup{
        lspFeatures = {
            enabled = true,
            languages = { 'r', 'python', 'julia' },
            diagnostics = {
                enabled = true,
                triggers = { "BufWrite" }
            },
            completion = {
                enabled = true
            }
        }
    }
else
    print("Failed to load Quarto plugin")
end
EOF

lua << EOF
local function quarto_preview()
  -- Save the current buffer
  vim.cmd('w')
  
  -- Check if the current file is a Quarto document
  local file_path = vim.fn.expand('%:p')
  local file_ext = vim.fn.expand('%:e')
  if file_ext ~= 'qmd' and file_ext ~= 'rmd' then
    print("This doesn't appear to be a Quarto document. Current file extension: " .. file_ext)
    return
  end
  
  -- Construct the preview command
  local preview_command = 'quarto preview "' .. file_path .. '"'
  
  -- Create a temporary buffer for output
  local output_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(output_bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(output_bufnr, 'bufhidden', 'wipe')
  
  -- Open a new split with the temporary buffer
  vim.cmd('below split')
  vim.api.nvim_win_set_buf(0, output_bufnr)
  
  -- Run quarto preview
  local job_id = vim.fn.jobstart(preview_command, {
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, {"Quarto preview started successfully."})
      else
        vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, {"Quarto preview failed to start. Please check the output for errors."})
      end
    end
  })
  
  -- Optionally, resize the split (adjust the number as needed)
  vim.cmd('resize 15')
  
  -- Move focus back to the main window
  vim.cmd('wincmd p')
end

-- Set up a keymap to use this function
vim.api.nvim_set_keymap('n', '<leader>qp', ':lua quarto_preview()<CR>', { noremap = true, silent = true })
EOF

lua << EOF
local ok, quarto = pcall(require, "quarto")
if ok then
    vim.keymap.set('n', '<leader>qp', function() quarto.quartoPreview() end, { silent = true, noremap = true })
    vim.keymap.set('n', '<leader>qq', function() quarto.quartoClosePreview() end, { silent = true, noremap = true })
else
    print("Quarto plugin not found")
end
EOF

" Jupyter Notebook
lua << EOF
require('notebook').setup {
    -- Whether to insert a blank line at the top of the notebook
    insert_blank_line = true,
    -- Whether to display the index number of a cell
    show_index = true,
    -- Whether to display the type of a cell
    show_cell_type = true,
    -- Style for the virtual text at the top of a cell
    virtual_text_style = { fg = "lightblue", italic = true },
}
EOF

" Molten Configs
" Initialize settings for molten-nvim
let g:molten_auto_open_output = 0 " false
let g:molten_output_show_more = 1 " true
let g:molten_image_provider = 'wezterm'
let g:molten_output_virt_lines = 1 " true
let g:molten_split_direction = 'right' " options: "right", "left", "top", "bottom"
let g:molten_split_size = 40 " (0-100) % size of the screen dedicated to the output window
let g:molten_virt_text_output = 1 " true
let g:molten_use_border_highlights = 1 " true
let g:molten_virt_lines_off_by_1 = 1 " true
let g:molten_auto_image_popup = 0 " false

" Initialize the plugin
nnoremap <silent> <localleader>mi :MoltenInit<CR>

" Run operator selection
nnoremap <silent> <localleader>e :MoltenEvaluateOperator<CR>

" Evaluate line
nnoremap <silent> <localleader>rl :MoltenEvaluateLine<CR>

" Re-evaluate cell
nnoremap <silent> <localleader>rr :MoltenReevaluateCell<CR>

" Evaluate visual selection
vnoremap <silent> <localleader>r :<C-u>MoltenEvaluateVisual<CR>gv

" Molten delete cell
nnoremap <silent> <localleader>rd :MoltenDelete<CR>

" Hide output
nnoremap <silent> <localleader>oh :MoltenHideOutput<CR>

" Show/enter output
nnoremap <silent> <localleader>os :noautocmd MoltenEnterOutput<CR>

syntax enable
set background=dark
colorscheme NeoSolarized
set number

" EasyMotion configuration
" Disable default mappings
let g:EasyMotion_do_mapping = 0

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" NERDTree configuration
let g:NERDTreeAutoRefresh = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowHidden = 1

" Ensure correct search navigation
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Existing keybindings
vnoremap  <localleader>y "+y
nnoremap  <C-c> "+yy
nnoremap  <C-G> "+yG
nnoremap  <C-l> :tabn<CR>
nnoremap  <C-h> :tabp<CR> 
nnoremap  <C-n> :tabnew<CR>
let mapleader = " "
nnoremap <leader>v <C-V>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" FZF keybindings
nnoremap <leader>ff :Files<CR>
nnoremap <leader>gf :GFiles<CR>
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>cs :Colors<CR>
nnoremap <leader>ag :Ag<CR>
nnoremap <leader>rg :Rg<CR>
nnoremap <leader>RG :RG<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>bl :BLines<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>bt :BTags<CR>
nnoremap <leader>ch :Changes<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader>j :Jumps<CR>
nnoremap <leader>w :Windows<CR>
nnoremap <leader>lo :Locate 
nnoremap <leader>h :History<CR>
nnoremap <leader>h: :History:<CR>
nnoremap <leader>h/ :History/<CR>
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gbc :BCommits<CR>
nnoremap <leader>cm :Commands<CR>
nnoremap <leader>mp :Maps<CR>
nnoremap <leader>ht :Helptags<CR>
nnoremap <leader>ft :Filetypes<CR>

" EasyMotion mappings
" 'gs' for 'go search' - search with two characters
nmap gs <Plug>(easymotion-overwin-f2)

" 'gS' for 'go search line' - search for lines
nmap gS <Plug>(easymotion-overwin-line)

" 'gl' for 'go line' - move to a specific line (j/k motions)
nmap gl <Plug>(easymotion-bd-jk)

" 'gw' for 'go word' - move to a specific word
nmap gw <Plug>(easymotion-bd-w)

" vim-visual-multi configuration
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'  " start multiple cursors
let g:VM_maps['Find Subword Under'] = '<C-d>'  " select word under cursor
let g:VM_maps['Select All']         = '<C-a>'  " select all occurrences
let g:VM_maps['Select h']           = '<C-Left>'  " move left
let g:VM_maps['Select l']           = '<C-Right>'  " move right

" Python environment management
" Automatically activate virtual environment in the current directory
let g:virtualenv_auto_activate = 1

" Display current virtualenv in statusline
set statusline+=%{virtualenv#statusline()}

" Key mapping to manually switch virtualenv
nnoremap <leader>ve :VirtualEnvList<CR>

" Function to get the current Python path
function! GetPythonPath()
    " Try to get Python path from VIRTUAL_ENV first
    if !empty($VIRTUAL_ENV)
        return $VIRTUAL_ENV . '\Scripts\python.exe'
    endif

    " If VIRTUAL_ENV is not set, try to get it from the active Python
    let l:python_path = system('powershell -Command "& {(Get-Command python).Source}"')
    let l:python_path = substitute(l:python_path, '\n\+$', '', '')  " Remove newline

    if !empty(l:python_path)
        return l:python_path
    endif

    " Fallback to 'python' if all else fails
    return 'python'
endfunction

" Set Python host prog
let g:python3_host_prog = GetPythonPath()

" UltiSnips configuration
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Optional: Add these settings for better FZF experience
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4"

" If you want to use Rg for :Files command when available
if executable('rg')

  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

" Source Lua configuration
luafile ~/AppData/Local/nvim/lua/lsp_config.lua

" At the end of your init.vim, add:
lua require('config')