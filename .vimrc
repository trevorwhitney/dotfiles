let mapleader = " "

set nocompatible
filetype off

if has('nvim')
    let s:editor_root=expand("$XDG_CONFIG_HOME/nvim")
else
    let s:editor_root=expand("$HOME/.vim")
endif

let s:bundles_path = s:editor_root . '/bundles'
let s:dein_path = s:bundles_path . '/repos/github.com/Shougo/dein.vim'
let &rtp = &rtp . ',' . s:dein_path

if dein#load_state(s:bundles_path)
  call dein#begin(s:bundles_path)

  for bundle in [
  \	s:editor_root . '/vimrc.bundles',
  \	s:editor_root . '/vimrc.ruby.bundles',
  \	s:editor_root . '/vimrc.javascript.bundles',
  \	s:editor_root . '/vimrc.coffeescript.bundles',
  \	s:editor_root . '/vimrc.kotlin.bundles',
  \	s:editor_root . '/vimrc.scala.bundles',
  \	s:editor_root . '/vimrc.java.bundles',
  \	s:editor_root . '/vimrc.haskell.bundles' ]
    if filereadable(expand(bundle))
      execute "source " . expand(bundle)
    endif
  endfor

  if has('nvim')
    for bundle in [ s:editor_root . '/vimrc.neovim.bundles' ]
      if filereadable(expand(bundle))
        execute "source " . expand(bundle)
      endif
    endfor
  endif

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax on

for config in [ 
      \ s:editor_root . '/vimrc.config', 
      \ s:editor_root . '/vimrc.ruby.config',
      \ s:editor_root . '/vimrc.haskell.config',
      \ s:editor_root . '/vimrc.java.config',
      \ s:editor_root . '/vimrc.localvimrc.config' ]
  if filereadable(expand(config))
    execute "source " . expand(config)
  endif
endfor

if has('nvim')
  for bundle in [ s:editor_root . '/vimrc.neovim.config' ]
    if filereadable(expand(bundle))
      execute "source " . expand(bundle)
    endif
  endfor
endif

if filereadable($HOME . "/.vimrc.local")
  source ${HOME}/.vimrc.local
endif
