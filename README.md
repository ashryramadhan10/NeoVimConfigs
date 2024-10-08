# NeoVimConfigs

## Notes for Molten-VIM

If molten.lua still doesn't exist, it suggests that the plugin might not be installed correctly or its structure is different from what we expect. Here are some steps to resolve this issue:

1. Reinstall the plugin:
   First, let's try to reinstall the plugin. In your init.vim, make sure you have:

   ```vim
   Plug 'benlubas/molten-nvim', { 'do': 'pip install pynvim' }
   ```

   Then, in Neovim, run:
   ```
   :PlugClean
   :PlugInstall
   ```

2. Check for dependencies:
   Molten-nvim requires some dependencies. Make sure you have them installed:
   
   ```
   :checkhealth
   ```
   
   Look for any issues related to Python or Jupyter.

3. Manual installation:
   If the above doesn't work, try manual installation:

   ```
   cd ~/.local/share/nvim/site/pack/plugins/start
   git clone https://github.com/benlubas/molten-nvim.git
   cd molten-nvim
   pip install pynvim jupyter_client
   ```

4. Create a minimal molten.lua:
   If the file still doesn't exist, we can create a minimal version:

   ```vim
   lua << EOF
   local plugin_dir = vim.fn.stdpath('data') .. '/plugged/molten-nvim/lua'
   local molten_file = plugin_dir .. '/molten.lua'
   if vim.fn.filereadable(molten_file) == 0 then
     local f = io.open(molten_file, "w")
     if f then
       f:write([[
   local M = {}
   
   M.setup = function(opts)
     print("Molten setup called with options:", vim.inspect(opts))
   end
   
   return M
   ]])
       f:close()
       print("Created minimal molten.lua at " .. molten_file)
     else
       print("Failed to create molten.lua")
     end
   end
   EOF
   ```

   or

   ```vim
    lua << EOF
    local plugin_dir = vim.fn.stdpath('data') .. '/plugged/molten-nvim/lua'
    local molten_file = plugin_dir .. '/molten.lua'
    if vim.fn.filereadable(molten_file) == 0 then
    local f = io.open(molten_file, "w")
    if f then
        f:write([[
    local M = {}

    M.setup = function(opts)
    print("Molten setup called with options:", vim.inspect(opts))
    end

    M.kernels = function()
    print("Molten kernels function called")
    end

    M.all_kernels = function()
    print("Molten all_kernels function called")
    end

    return M
    ]])
        f:close()
        print("Created minimal molten.lua at " .. molten_file)
    else
        print("Failed to create molten.lua")
    end
    end
    EOF
   ```

5. Check plugin structure:
   It's possible the plugin's main file is not molten.lua. Let's check the structure:

   ```vim
   lua << EOF
   local plugin_dir = vim.fn.stdpath('data') .. '/plugged/molten-nvim'
   local files = vim.fn.globpath(plugin_dir, '**/*.lua', 0, 1)
   print("Lua files in molten-nvim:")
   for _, file in ipairs(files) do
     print(file)
   end
   EOF
   ```

After trying these steps, restart Neovim and check if the plugin loads correctly. If you're still having issues, please provide:

1. The output of `:checkhealth`
2. The list of Lua files in the molten-nvim directory
3. Any error messages you see when trying to load or use the plugin

With this information, we can further diagnose the issue and find a solution.

### Final `init.vim` for Molten-VIM

```vim
call plug#begin('~AppData/Local/nvim-data/plugged')
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

" Add NeoSolarized colorscheme
Plug 'Tsuzat/NeoSolarized.nvim', { 'branch': 'master' }

" Add molten-nvim
Plug 'benlubas/molten-nvim'

call plug#end()

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

lua << EOF
local ok, molten = pcall(require, "molten")
if ok then
  print("Molten loaded successfully")
  
  -- Set up the plugin
  if type(molten.setup) == "function" then
    molten.setup()
    print("Molten setup completed")
  end

  -- Create commands
  vim.api.nvim_create_user_command("MoltenInit", function()
    if type(molten.setup) == "function" then
      molten.setup()
      print("Molten initialized")
    else
      print("Molten setup function not available")
    end
  end, {})

  vim.api.nvim_create_user_command("MoltenEvaluateLine", function()
    if type(molten.kernels) == "function" then
      molten.kernels()
    else
      print("Molten kernels function not available")
    end
  end, {})

  vim.api.nvim_create_user_command("MoltenAllKernels", function()
    if type(molten.all_kernels) == "function" then
      molten.all_kernels()
    else
      print("Molten all_kernels function not available")
    end
  end, {})

  -- Set up keybindings
  vim.api.nvim_set_keymap('n', '<LocalLeader>mi', ':MoltenInit<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<LocalLeader>me', ':MoltenEvaluateLine<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<LocalLeader>mk', ':MoltenAllKernels<CR>', {noremap = true, silent = true})

else
  print("Failed to load molten:", molten)
end
EOF
```