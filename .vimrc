let mapleader = " "

set nocompatible
filetype off

if has('nvim')
  let s:editor_root=expand("$XDG_CONFIG_HOME/nvim")
else
  let s:editor_root=expand("$HOME/.vim")
endif

call plug#begin()
if has('nvim')
  for bundle in [ s:editor_root . '/vimrc.neovim.bundles' ]
    if filereadable(expand(bundle))
      execute "source " . expand(bundle)
    endif
  endfor
endif

for bundle in [
      \	s:editor_root . '/vimrc.bundles',
      \	s:editor_root . '/vimrc.ruby.bundles',
      \	s:editor_root . '/vimrc.javascript.bundles',
      \	s:editor_root . '/vimrc.coffeescript.bundles',
      \	s:editor_root . '/vimrc.kotlin.bundles',
      \	s:editor_root . '/vimrc.scala.bundles',
      \	s:editor_root . '/vimrc.java.bundles',
      \	s:editor_root . '/vimrc.go.bundles',
      \	s:editor_root . '/vimrc.html.bundles',
      \	s:editor_root . '/vimrc.purescript.bundles',
      \	s:editor_root . '/vimrc.elm.bundles',
      \	s:editor_root . '/vimrc.haskell.bundles' ]
  if filereadable(expand(bundle))
    execute "source " . expand(bundle)
  endif
endfor
call plug#end()

filetype plugin indent on
syntax on

if has('nvim')
  for bundle in [
        \ s:editor_root . '/vimrc.neovim.config',
        \ s:editor_root . '/vimrc.deoplete.config' ]
    if filereadable(expand(bundle))
      execute "source " . expand(bundle)
    endif
  endfor
endif

for config in [
      \ s:editor_root . '/vimrc.config',
      \ s:editor_root . '/vimrc.ruby.config',
      \ s:editor_root . '/vimrc.javascript.config',
      \ s:editor_root . '/vimrc.haskell.config',
      \ s:editor_root . '/vimrc.java.config',
      \ s:editor_root . '/vimrc.go.config',
      \ s:editor_root . '/vimrc.purescript.config',
      \ s:editor_root . '/vimrc.elm.config',
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
