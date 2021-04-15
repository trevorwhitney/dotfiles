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

"========== Directories ==========
set directory=~/.vim-tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim-tmp,~/tmp,/var/tmp,/tmp

"========== Keybindings ==========
imap jj <Esc>
cmap w!! w !sudo tee > /dev/null %
nmap <Leader>bn :bn<CR>
nmap <Leader>bp :bp<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" paste the 0 buffer
nnoremap <silent><nowait> \p "0p
nnoremap <silent><nowait> \P "0P

if !has('nvim')
  nmap <leader>= gg=G2<C-o>
endif
nnoremap <silent> \q ZZ

" ========== Dash =================
nmap <silent> <leader>d <Plug>DashSearch

"========== NERDtree ==========
function! IsNerdTreeEnabled()
    return exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1
endfunction
nnoremap <silent><nowait><expr> \ IsNerdTreeEnabled() ? ":NERDTreeToggle\<CR>" : ":NERDTreeFind\<CR>"

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

"========== vim-fugitivie ==========
map <leader>gb   :Gblame<CR>
map <leader>gd   :Gdiffsplit<CR>
map <leader>gh   :Gclog<CR>
map <leader>go   :GBrowse<CR>
map <leader>gk   :Git commit -s<CR>

" clean up unused fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost .git/index set nolist

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

" Set var for things that should only be enabled in git repos
let s:in_git = system('git rev-parse --is-inside-work-tree')

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
  function! MyTabLine()
    let s = ''
    let wn = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= ' '
      let wn = tabpagewinnr(i,'$')

      let s .= '%#TabNum#'
      let s .= i
      " let s .= '%*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let bufnr = buflist[winnr - 1]
      let file = bufname(bufnr)
      let buftype = getbufvar(bufnr, 'buftype')
      if buftype == 'nofile'
        if file =~ '\/.'
          let file = substitute(file, '.*\/\ze.', '', '')
        endif
      else
        let file = fnamemodify(file, ':p:t')
      endif
      if file == ''
        let file = '[No Name]'
      endif
      let s .= ' ' . file . ' '
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
  endfunction
  set stal=2
  set tabline=%!MyTabLine()
  set showtabline=1
  highlight link TabNum Special
endif

"============ Auto completion ============
set completeopt=menuone,menu,longest
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu
set completeopt+=longest

"=========== SuperTab ==============
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'

if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

""========= Tabular ===============
"nmap <Leader>n= :Tabularize /=<CR>
"vmap <Leader>n= :Tabularize /=<CR>
"nmap <Leader>n: :Tabularize /:\zs<CR>
"vmap <Leader>n: :Tabularize /:\zs<CR>

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
