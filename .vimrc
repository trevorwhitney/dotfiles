let mapleader = " "

syntax on

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/bundle')

Plugin 'gmarik/Vundle.vim'

for bundle in [
\	'~/.vim/vimrc.bundles',
\	'~/.vim/vimrc.ruby.bundles',
\	'~/.vim/vimrc.javascript.bundles',
\	'~/.vim/vimrc.coffeescript.bundles',
\	'~/.vim/vimrc.kotlin.bundles',
\	'~/.vim/vimrc.haskell.bundles' ]
  if filereadable(expand(bundle))
    execute "source " . expand(bundle)
  endif
endfor

call vundle#end()

filetype plugin indent on

for config in [ 
      \ '~/.vim/vimrc.config', 
      \ '~/.vim/vimrc.ruby.config',
      \ '~/.vim/vimrc.haskell.config',
      \ '~/.vim/vimrc.localvimrc.config' ]
  if filereadable(expand(config))
    execute "source " . expand(config)
  endif
endfor

if filereadable($HOME . "/.vimrc.local")
  source ${HOME}/.vimrc.local
endif
