" Also worth checking out:
" https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
" Many settings were gathered from here though:
" https://dougblack.io/words/a-good-vimrc.html
set t_Co=256        " 256 color terminal (probably too heavy-handed)
colorscheme molokai " molokai colors pleasing to me
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
inoremap jk <esc>     " 'jk' in quick succession in insert mode = escape 
                      " (this is the *BOMB*)
set incsearch         " incremenal search
set hlsearch          " highlight search terms after search is complete
let mapleader=","     " change leader to ',' from default '\'
" leader-x clears search hl
nnoremap <silent> <leader>x :nohlsearch<Bar>:echo<CR>
" leader-f to toggle folds
nnoremap <leader>f za " leader-f open/closes folds

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
Plug 'vim-syntastic/syntastic'
Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'editorconfig/editorconfig'
call plug#end()

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']
