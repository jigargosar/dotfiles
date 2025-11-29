" CORE
let mapleader = " "
let g:nvim_dir = stdpath('config')
" cd ~

" OPTIONS

" line numbers
set number
set relativenumber

" search
set ignorecase
set smartcase

" indentation
set expandtab
set shiftwidth=4
set tabstop=4

" ui
set background=dark
set termguicolors
set signcolumn=yes
set scrolloff=8
set cursorline

" system clipboard
set clipboard=unnamedplus

" KEYMAPS
" edit
nnoremap <leader>ec <Cmd>execute 'edit' g:nvim_dir .. '/init.vim'<CR>
nnoremap <leader>es <Cmd>execute 'edit' g:nvim_dir .. '/settings.vim'<CR>
" source
nnoremap <leader>ss <Cmd>execute 'source' g:nvim_dir .. '/settings.vim'<CR>
nnoremap <leader>sc <Cmd>source %<CR>
nnoremap <leader>sl <Cmd>.source<CR>

" AUTOCMDS
" cursorline only in active window
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd WinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

" COMMANDS
command! -nargs=1 Capture new | setlocal buftype=nofile | file [<args>] | put =execute('<args>')
