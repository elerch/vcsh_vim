set t_Co=256
colorscheme desert
syntax enable
set number
set laststatus=2
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

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
Plug 'mtscout6/syntastic-local-eslint.vim', { 'for': 'javascript' }
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
