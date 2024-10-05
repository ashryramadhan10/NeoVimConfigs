call plug#begin()
" Existing plugins
Plug 'https://github.com/junegunn/vim-easy-align.git'
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug '~/my-prototype-plugin'
Plug 'tomasiser/vim-code-dark'

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

call plug#end()

syntax enable
set background=dark
colorscheme codedark
set number
set wildmenu

" EasyMotion configuration
" Disable default mappings
let g:EasyMotion_do_mapping = 0

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" NERDTree configuration
let g:NERDTreeAutoRefresh = 1
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowHidden = 1

" Function to refresh NERDTree
function! NERDTreeRefresh()
    if &filetype == "nerdtree"
        silent exe substitute(mapcheck("R"), "<CR>", "", "")
    endif
endfunction

" Auto refresh NERDTree
autocmd BufEnter * call NERDTreeRefresh()

" Ensure correct search navigation
nnoremap <expr> n  'Nn'[v:searchforward]
nnoremap <expr> N  'nN'[v:searchforward]

" Existing keybindings
nnoremap  <C-l> :tabn<CR>
nnoremap  <C-h> :tabp<CR> 
nnoremap  <C-n> :tabnew<CR>
let mapleader = " "
nnoremap <leader>v <C-V>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <leader><tab>r :NERDTreeRefreshRoot<CR>

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
