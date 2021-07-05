set runtimepath^=~/.vim,~/.local/share/nvim/plugged runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

if has('nvim-0.5')
  " Use completion-nvim in every buffer
  autocmd BufEnter * lua require'completion'.on_attach()

  lua require('nvimconfig')

  " nvim >= 0.5 wants things in lua, but we want to have a config that's
  " progressively enhanced from old minimal vim to modern neovim
  " Neovim 0.5 also has a built-in Language Server client, so we kind of
  " want to ignore all the ncm2/LanguageClient stuff, and while we're at
  " it, I feel Omnisharp is kind of an odd bird so I'm going to chill on that
  " until I need it again
endif
