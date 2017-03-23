" Also worth checking out:
" https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
" Many settings were gathered from here though:
" https://dougblack.io/words/a-good-vimrc.html
set t_Co=256        " 256 color terminal (probably too heavy-handed)
colorscheme molokai " molokai colors pleasing to me
let mapleader=","   " change leader to ',' from default '\'
" Remove background color (originally 233). By doing this we can
" leverage terminal transparency (as long as it's dark)
" we use VimEnter rather than ColorScheme because we only want to fire this
" once on startup. After that, if you switch color schemes you're on your
" own. This helps with the below *get out of jail free card" if you're
" on a terminal with a white background
autocmd VimEnter * hi Normal ctermbg=None
" Add shortcut to put it back in case we're on an ugly terminal
" The ctermbg will mess with comment colors in a bad way, so we'll restore
" by just setting colorscheme. This works due to the use of VimEnter above
nnoremap <silent> <leader>o :colorscheme molokai<CR>
" The shortcut to put it back wouldn't be complete without another to put
" transparent background back in!
nnoremap <silent> <leader>t :colorscheme molokai<CR>:hi Normal ctermbg=None<CR>
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
