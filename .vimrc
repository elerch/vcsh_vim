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
" Leader u to underline
nnoremap <leader>u yyp<C-v>$r-j
" Leader U to underline (=)
nnoremap <leader>U yyp<C-v>$r=j

syntax enable       " enable syntax highlighting because why wouldn't you?
set mouse=a         " turn on mouse in all modes (could also be mouse=n for normal
set number          " show line numbers
set showcmd         " show command prefix in lower right
set cursorline      " highlight the current line
set laststatus=2    " show status line
filetype indent on  " allow different indentation by filetype
                    " e.g. ~/.vim/indent/python.vim for python
filetype plugin on  " Omnisharp needs this
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
" + register is the clipboard in X11 (Ctrl-Shift-V in some terminals)
" * register is the cut buffer (three finger click paste operation) (a.k.a.
" PRIMARY)
nnoremap <leader>a :%y+<CR>
nnoremap <leader>A :%y*<CR>
nnoremap <leader>v "+p
nnoremap <leader>V "*p
" This most makes sense in visual mode
vnoremap <leader>c "+y
vnoremap <leader>C "*y

" delete buffer, retain position
" https://superuser.com/questions/289285/how-to-close-buffer-without-closing-the-window
command Bd bp | sp | bn | bd

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
Plug 'chaoren/vim-wordmotion'
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
  " neovim 0.x.x also reports version as 800 so this is ok
  if v:version >= 800
    " Only using fzf for lsp. It isn't totally necessary and the install
    " messes with .bashrc and .zshrc, so I shall leave it commented for now
    " PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
    " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

    " The plugins here theoretically work with vim8 but I suspect things
    " will be broken. Have not tested.
    Plug 'roxma/nvim-yarp'
    Plug 'ncm2/ncm2'
    " Language Server Protocol - works with ncm2
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh'
        \ }
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    " Use silent! here because on first run we don't want an error to appear
    autocmd BufEnter * silent! call ncm2#enable_for_buffer()
    au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
    au User Ncm2PopupClose set completeopt=menuone
  endif
  Plug 'OmniSharp/omnisharp-vim'
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
" '✖ '
let airline#extensions#ale#error_symbol = '✗ '
let airline#extensions#ale#warning_symbol = '⚠ '

" Set LanguageClient configuration
let g:LanguageClient_serverCommands = {}
" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_loggingFile =  expand('/tmp/LanguageClient.log')
" let g:LanguageClient_serverStderr = expand('/tmp/LanguageServer.log')

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
" Should this be 'fi'? In C# there are multiple, and that's what OmniSharp
" recommends
nnoremap <silent> gi :call LanguageClient_textDocument_implementation()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> gD :call LanguageClient_textDocument_typeDefinition()<CR>
nnoremap <silent> <leader>r :call LanguageClient_textDocument_rename()<CR>
"nnoremap <silent> <Leader><Space> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> <Leader><Space> :call LanguageClient_textDocument_codeAction()<CR>
nnoremap <silent> <leader>cf :call LanguageClient_textDocument_formatting()<CR>
"Document highlight kills syntax highlighting
" nnoremap <silent> fu :call LanguageClient_textDocument_documentHighlight()<CR>
" nnoremap <silent> fx :call LanguageClient_clearDocumentHighlight()<CR>

" Set Ctrl-P to mixed mode, which will search buffers, files, mru
let g:ctrlp_cmd='CtrlPMixed'

" Let ale use Ctrl-k/Ctrl-J to navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" '✗ ' '✖ '
let g:ale_sign_error = '✗'
" '⚠ '
let g:ale_sign_warning = '▲'
"highlight clear ALEErrorSign
"hi ALEErrorSign guifg=#FF0000
"highlight clear ALEWarningSign

"there's probably a better way to do this, but we'll create a toggle for
"yaml/cloudformation
au Filetype cloudformation set syntax=yaml
au Filetype cloudformation nmap <silent> <leader>t :set filetype=yaml<CR>
au Filetype yaml nmap <silent> <leader>t :set filetype=cloudformation<CR>

nnoremap <leader>c :ALEFix<CR>
" Hide completion stuff on command line (nvim only)
if has('nvim')
  set shortmess+=c
endif

" Vimux bindings - we interact with tmux, so the prefix is t
nnoremap <leader>tp :VimuxPromptCommand<CR>
nnoremap <leader>tl :VimuxRunLastCommand<CR>
inoremap <leader>tl <C-O>:VimuxRunLastCommand<CR>
nnoremap <leader>ti :VimuxInspectRunner<CR>
nnoremap <leader>tx :VimuxInterruptRunner<CR>
nnoremap <leader>tq :VimuxCloseRunner<CR>
" Use <bind-key> z to restore runner pane
nnoremap <leader>tz :VimuxZoomRunner<CR>

" Git gutter colors - I want my green back! :)
highlight GitGutterAdd ctermfg=2 ctermbg=236 guifg=#009900 guibg=#232526
highlight GitGutterChange ctermfg=3 ctermbg=236 guifg=#bbbb00 guibg=#232526
highlight GitGutterDelete ctermfg=1 ctermbg=236 guifg=#ff2222 guibg=#232526


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Program Language Specific configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javacript
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Javascript/Typescript (still fragile install)
if !empty(glob('~/.nvm/versions/node/v8.7.0/lib/node_modules/javascript-typescript-langserver/lib/language-server-stdio.js'))
    " using nvm, npm install -g javascript-typescript-langserver
    let g:LanguageClient_serverCommands.javascript = [glob('~/.nvm/versions/node/v8.7.0/lib/node_modules/javascript-typescript-langserver/lib/language-server-stdio.js')]
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rust
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rust directions on github https://github.com/rust-lang/rls
let g:LanguageClient_serverCommands.rust = ['rustup', 'run', 'stable', 'rls']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Go
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Official go language server is in the works, so everything else is kind of
" broken. Bingo is the best for now in early 2019
if executable('bingo')
    " go get github.com/sourcegraph/go-langserver
    " go nomodules get github.com/nsf/gocode
    let g:LanguageClient_serverCommands.go = ['bingo']
    let g:LanguageClient_rootMarkers = { 'go': ['.git', 'go.mod'] }
endif
" Golang uses tabs
au Filetype go setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab
au Filetype go let g:ale_linters['go'] = ['go build', 'golint', 'gofmt', 'go vet']
au Filetype go let g:ale_fixers['go'] = ['gofmt', 'goimports']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Python (pip install --user python-language-server)
if executable('pyls')
    let g:LanguageClient_serverCommands.python = ['pyls']
endif

" flake8 is better and we should not fall back to pylint
au Filetype python let g:ale_linters['python'] = ['flake8']

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" C#
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Omnisharp. From a langauge server perspective it's kind of broken, but the
" direct plugin works ok, so we let Omnisharp override some of the Langauge
" Server bindings below

if executable(expand('command -v ~/.omnisharp/omnisharp-roslyn/bin/mono.linux-x86_64'))
  " No worky: https://github.com/OmniSharp/omnisharp-roslyn/issues/1191
   let g:LanguageClient_serverCommands.cs = [expand('~/.omnisharp/omnisharp-roslyn/bin/mono.linux-x86_64'), expand('~/.omnisharp/omnisharp-roslyn/omnisharp/OmniSharp.exe'), '--languageserver', '--verbose' ]
endif

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview' if you
" don't want to see any documentation whatsoever.
" set completeopt=longest,menuone,preview

" Fetch full documentation during omnicomplete requests.
" There is a performance penalty with this (especially on Mono).
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
"let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
au Filetype cs let g:ale_linters['cs'] = ['OmniSharp']

" Fetch semantic type/interface/identifier names on BufEnter and highlight them
let g:OmniSharp_highlight_types = 1

augroup omnisharp_commands
    autocmd!

    " When Syntastic is available but not ALE, automatic syntax check on events
    " (TextChanged requires Vim 7.4)
    " autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Show type information automatically when the cursor stops moving
    " autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    " Update the highlighting whenever leaving insert mode
    autocmd InsertLeave *.cs call OmniSharp#HighlightBuffer()

    " Alternatively, use a mapping to refresh highlighting for the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>th :OmniSharpHighlightTypes<CR>

    " The following commands are contextual, based on the cursor position.
    " Most of these should be moved to the language server global bindings,
    " but OmniSharp appears to be badly broken from a pure lsp perspective
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-h> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-l> :OmniSharpNavigateDown<CR>
    " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
    autocmd FileType cs nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
augroup END

" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
" let g:OmniSharp_want_snippet=1
