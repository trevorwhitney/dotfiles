"========== General ==========
set autoindent
set autoread
set autoread                    " Don't prompt when a file is changed outside of vim
set autowrite
set autowriteall
set backspace=indent,eol,start  " Let backspace work over anything.
set expandtab                   " Use soft tabs
set ignorecase smartcase        " ignore case only when search term is all lowercase
set incsearch
set mouse=a                     " enable mouse in all modes
set nowrap                      " No wrapping
set number                      " Line numbers
set omnifunc=syntaxcomplete#Complete
set scrolloff=5
set shiftwidth=2                " Width of autoindent
set showmatch                   " Show matching brackets/braces
set smarttab                    " Use shiftwidth to tab at line beginning
set switchbuf=useopen
set tabstop=2                   " Tab settings
set undodir=$HOME/.vim/undodir
set undofile

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

"==== Some custom text objects ====
" line text object
xnoremap il g_o^
onoremap il :normal vil<CR>
xnoremap al $o^
onoremap al :normal val<CR>

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

" use the coc version of these commands for nvim
if !has('nvim')
  " find file (in git files)
  nnoremap <leader>ff :<C-u>FzfPreviewGitFilesRpc<cr>
  " find file (in all files)
  nnoremap <leader>fa :<C-u>FzfPreviewProjectFilesRpc<cr>
  " yank ring
  nnoremap <leader>y :<C-u>FzfPreviewYankroundRpc<cr>
  " turn spell check on
  nmap <silent> <leader>sp :set spell!<CR>
  " search and replace in file
  nnoremap <Leader>sr :%s/\<<C-r><C-w>\>/
endif

"========== NERDtree ==========
if !has('nvim')
  nnoremap <silent><nowait> \ :NERDTreeToggle<CR>
  nnoremap <silent><nowait> \| :NERDTreeFind<CR>
endif

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
let g:vimwiki_global_ext = 0

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
let g:airline#extensions#ale#enabled=1

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

" ======== Auto Save =========
autocmd BufLeave * update
autocmd FocusLost * update

" ====== Readline / RSI =======
inoremap <c-k> <c-o>D
cnoremap <c-k> <c-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

" ====== ALE ======
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'go': ['gofmt'],
\   'yaml': ['prettier'],
\   'markdown': ['prettier'],
\}

let g:ale_fix_on_save=1

" ==== Fzf and fzf preview ====
let g:fzf_preview_command = 'bat --color=always --plain --number {-1}'
let g:fzf_preview_lines_command = 'bat --color=always --plain --number'
let g:fzf_preview_preview_key_bindings = 'ctrl-a:select-all'
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=always'
let g:fzf_preview_window = ['']

" Remap Rg function to allow more args to be passed
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, a:query)
  let spec = {'options': ['--phony', '--query', a:query, '--expect', 'ctrl-q', '--bind', g:fzf_preview_preview_key_bindings]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
