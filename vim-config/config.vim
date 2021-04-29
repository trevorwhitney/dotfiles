"========== General ==========
set expandtab                   " Use soft tabs
set tabstop=2                   " Tab settings
set autoindent
set smarttab                    " Use shiftwidth to tab at line beginning
set shiftwidth=2                " Width of autoindent
set number                      " Line numbers
set nowrap                      " No wrapping
set backspace=indent,eol,start  " Let backspace work over anything.
set showmatch                   " Show matching brackets/braces
set autoread                    " Don't prompt when a file is changed outside of vim
set ignorecase smartcase        " ignore case only when search term is all lowercase
set mouse=a                     " enable moude in all modes
set omnifunc=syntaxcomplete#Complete
set incsearch
set scrolloff=5
set autowrite
set autowriteall
set autoread

if has('unnamedplus')
  set clipboard^=unnamed,unnamedplus
else
  set clipboard=unnamed
endif

cabb W w
cabb Wq wq
cabb WQ wq
cabb Q q

" <C-a> is for tmux
noremap <C-a> <Nop>

" Spell checking
set spelllang=en_us
nmap <silent> <leader>sp :set spell!<CR>
map <Leader>z :'<,'>sort<CR>

" UTF-8 all the way
set encoding=utf-8

"========== Directories ===========
set directory=~/.vim-tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim-tmp,~/tmp,/var/tmp,/tmp

"========== CamelCase Motion ======
let g:wordmotion_nomap = 1
map <silent> w <Plug>WordMotion_w
map <silent> b <Plug>WordMotion_b
omap <silent> iw <Plug>WordMotion_iw
xmap <silent> iw <Plug>WordMotion_iw

"========== Keybindings ==========
imap jj <Esc>
cmap w!! w !sudo tee > /dev/null %

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <C-w>q :windo close<cr>

" paste the 0 register
nnoremap <silent><nowait> \p "0p
nnoremap <silent><nowait> \P "0P

" nvim uses coc for better document formatting
if !has('nvim')
  nmap <leader>= gg=G2<C-o>
endif
nnoremap <silent> \q ZZ
nnoremap <silent> \Q :xa<cr>

"========== NERDtree ==========
nnoremap <silent><nowait> \ :NERDTreeToggle<CR>
nnoremap <silent><nowait> \| :NERDTreeFind<CR>

" automatically close NERDTree when a file is opened
let NERDTreeQuitOnOpen = 1
" Small default width for NERDTree pane
let g:NERDTreeWinSize = 40
" Change working directory if you change root directories
let g:NERDTreeChDirMode=2
" Show hidden files
let NERDTreeShowHidden=1

"========== Folding ==========
set foldmethod=syntax   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use
set foldopen=insert        "open folds when inserted into

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

"============= surround vim ============
" surround.vim: Add $ as a jQuery surround, _ for Underscore.js
autocmd FileType javascript let b:surround_36 = "$(\r)"
      \ | let b:surround_95 = "_(\r)""
set tags^=./.git/tags

"========== Syntastic ==========
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs=1
let g:syntastic_loc_list_height=5

"============ Auto completion ============
set completeopt=menuone,menu,longest
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu
set completeopt+=longest

"======== Helpful Shortcuts =========
:nnoremap <Leader>sr :%s/\<<C-r><C-w>\>/
:map <Leader>lo :lopen<Cr>
:map <Leader>lc :lclose<Cr>
:map <Leader>co :copen<Cr>
:map <Leader>cc :cclose<Cr>

"========= Automatically set paste when pasting =========
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

"========= Yaml ==============
" disable yaml indenting logic
autocmd FileType yaml setlocal indentexpr=

" ====== vim-visual-multi ======
" press n/N to get next/previous occurrence
" press [/] to select next/previous cursor
" press q to skip current and get next occurrence
" press Q to remove current cursor/selection
" start insert mode with i,a,I,A
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'           " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'           " replace visual C-n

" ===== vim-wiki =====
let g:vimwiki_list = [{'path': '~/Dropbox/Notes/vimwiki',
      \ 'syntax': 'markdown',
      \ 'ext': '.md'}]

" ===== gruvbox ====
let g:gruvbox_italic=0
let g:gruvbox_contrast_light="hard"
let g:gruvbox_improved_warnings=1
set termguicolors

if $BACKGROUND == 'dark'
  set background=dark
else
  set background=light
endif

colorscheme gruvbox_less_red
let g:airline_theme="solarized"
let g:airline_powerline_fonts=1

" bufferline
let g:bufferline_echo = 0

" ====== easy-motion ======
map <leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" ========= grep ==============
" use ripgrep for grep command
if executable("rg")
    set grepprg=rg\ --vimgrep
endif


" ======= Markdown ==========
let g:textobj_markdown_no_default_key_mappings=1

omap imc <plug>(textobj-markdown-chunk-i)
xmap imc <plug>(textobj-markdown-chunk-i)
omap amc <plug>(textobj-markdown-chunk-a)
xmap amc <plug>(textobj-markdown-chunk-a)
