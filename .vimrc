" Also worth checking out:
" https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
" Many settings were gathered from here though:
" https://dougblack.io/words/a-good-vimrc.html
" The t_Co below is indeed too heavy-handed. Make sure your $TERM is
" set properly and let vim figure this out. Neovim generally ignores this
" value
"set t_Co=256        " 256 color terminal (probably too heavy-handed)
set encoding=utf-8  " termux on android needed this but nothing else?
" true color support in neovim
if has("termguicolors") && has("nvim")
  set termguicolors
endif
let g:molokai_transparent_bg=1
colorscheme molokai " molokai colors pleasing to me
let mapleader=","   " change leader to ',' from default '\'
" Add shortcut to put it back in case we're on an ugly terminal
" The ctermbg will mess with comment colors in a bad way, so we'll restore
" by just setting colorscheme. This works due to the use of VimEnter above
nnoremap <silent> <leader>o :let g:molokai_transparent_bg=0<CR>:colorscheme molokai<CR>
" The shortcut to put it back wouldn't be complete without another to put
" transparent background back in!
nnoremap <silent> <leader>t :let g:molokai_transparent_bg=1<CR>:colorscheme molokai<CR>
" Leader s to save the file
nnoremap <silent> <leader>s :update<CR>
inoremap <leader>s <C-O>:update<CR>
vnoremap <leader>s <C-C>:update<CR>
" Leader k makes a checkmark (✓)
inoremap <leader>k <C-k>OK
nnoremap <leader>k i<C-k>OK <esc>h
" Leader dg does a diffget
nnoremap <leader>dg :diffget

syntax enable       " enable syntax highlighting because why wouldn't you?
set number          " show line numbers
set showcmd         " show command prefix in lower right
set cursorline      " highlight the current line
set laststatus=2    " show status line
filetype indent on  " allow different indentation by filetype
                    " e.g. ~/.vim/indent/python.vim for python
set wildmenu        " visual autocomplete for command menu
set lazyredraw      " don't redraw during macros
set showmatch       " show matches in searches
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab " def tab settings
set backspace=indent,eol,start                              " and bksp
" setup a nice status line
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set colorcolumn=80 " sets a vertical ruler (maybe this should be 72?)
set list           " show whitespace
set listchars=tab:▸\ ,trail:_,extends:> " ,eol:¬ " chars (minus eol)
set foldenable        " enable folding
set foldlevelstart=10 " leave most folds open - beyond 10? refactor!
set foldnestmax=10    " only allow 10 nested folds ^^^^^^^^^^^^^^^^^
set foldmethod=indent " indent (rather than marker). Not sure this is right
" 'jk' in quick succession in insert mode = escape
inoremap jk <esc>
                      " (this is the *BOMB*)
set incsearch         " incremenal search
set hlsearch          " highlight search terms after search is complete
" leader-x clears search hl
nnoremap <silent> <leader>x :nohlsearch<Bar>:echo<CR>
" leader-f to toggle folds
nnoremap <leader>f za " leader-f open/closes folds
" copy/paste from system clipboard (note linux differs between clipboard and
" primary)
nnoremap <leader>v "*p
nnoremap <leader>V "+p
nnoremap <leader>c "*y
nnoremap <leader>C "+y

" Install plug.vim if it doesn't exist
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !mkdir -p ~/.vim/autoload
  silent !url=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&
    \ { curl -fLo ~/.vim/autoload/plug.vim $url || wget -O ~/.vim/autoload/plug.vim $url; }
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  " After plugins installed, kill the window it created
  autocmd VimEnter * sleep 1
  autocmd VimEnter * q
endif

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')
Plug 'editorconfig/editorconfig'
Plug 'benmills/vimux'
Plug 'rust-lang/rust.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'w0rp/ale'
if !has('nvim')
  Plug 'roxma/vim-hug-neovim-rpc'
endif
" Also: pip3 install --user neovim jedi mistune psutil setproctitle
if has('python3')
  Plug 'roxma/nvim-completion-manager'
  " Language Server Protocol - works with nvim-completion-manager
  Plug 'autozimu/LanguageClient-neovim'
endif
Plug 'tomtom/tcomment_vim' " Commenting gcc or gc-motion
call plug#end()

" Airline
" Not airline per-se, but this will turn off showing the mode in the command
" line. Since airline is doing this in the status we don't need it in
" the command line as well
set noshowmode

" Required by airline - allows operation on hidden buffers
set hidden
set nocompatible
if !empty(glob("$HOME/.fonts/PowerlineSymbols.otf"))
  let g:airline_powerline_fonts = 1
endif
let g:airline_theme='distinguished'
let g:airline#extensions#tabline#enabled = 1
" Only show buffers at the top if there are more than 1
let g:airline#extensions#tabline#buffer_min_count =2
" Enable ale warning/error count on status line
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = '☠  '
let airline#extensions#ale#warning_symbol = '⚠ '

" Set LanguageClient configuration
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <leader>r :call LanguageClient_textDocument_rename()<CR>

" Set Ctrl-P to mixed mode, which will search buffers, files, mru
let g:ctrlp_cmd='CtrlPMixed'

" Let ale use Ctrl-k/Ctrl-J to navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_sign_error = '☠  '
let g:ale_sign_warning = '⚠ '
highlight clear ALEErrorSign
highlight clear ALEWarningSign

" Hide completion stuff on command line
set shortmess+=c

" Vimux bindings - we interact with tmux, so the prefix is t
nnoremap <leader>tp :VimuxPromptCommand<CR>
nnoremap <leader>tl :VimuxRunLastCommand<CR>
inoremap <leader>tl <C-O>:VimuxRunLastCommand<CR>
nnoremap <leader>ti :VimuxInspectRunner<CR>
nnoremap <leader>tx :VimuxInterruptRunner<CR>
nnoremap <leader>tq :VimuxCloseRunner<CR>
" Use <bind-key> z to restore runner pane
nnoremap <leader>tz :VimuxZoomRunner<CR>

" Golang uses tabs
au Filetype go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab
