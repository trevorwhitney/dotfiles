let mapleader = ' ' " space as leader

lua <<EOF
local use = require('packer').use
require('tw.packer').install(use)
require('tw.config').setup()
EOF

cabb W w
cabb Wq wq
cabb WQ wq
cabb Q q
cabb Qa qa

" <C-q> is for tmux
noremap <C-q> <Nop>

" Spell checking
set spelllang=en_us
map <Leader>z :'<,'>sort<CR>

" UTF-8 all the way
set encoding=utf-8

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

nnoremap <silent> \q ZZ
nnoremap <silent> \Q :xa<cr>

" search and replace
nnoremap <Leader>sr :%s/\<<C-r><C-w>\>/

" ====== Git (vim-fugitive) =====
" Set var for things that should only be enabled in git repos
let g:in_git = system('git rev-parse --is-inside-work-tree')

" Git status, show currently changed files
nmap <leader>gb   :Gitsigns blame_line<CR>
nmap <leader>gB   :Git blame<CR>

" pneumonic git diff
nmap <leader>gd   :Gdiffsplit<CR>

nnoremap <leader>go   :GitBrowseCurrentLine<cr>
xnoremap <leader>go   :'<,'>GBrowse<CR>

" pneumonic git commit
nmap <leader>gk       :Git commit<CR>
nnoremap <nowait> \k  :Git commit<CR>

" Git status
nnoremap <nowait> \s  :ToggleGitStatus<cr>
" Git logs
nnoremap <nowait> \l  :<C-u>Git log -n 50 --graph --decorate --oneline<cr>
" pneumonic git history
nmap <leader>gh   :0Gclog!<CR>
" pneumonic git log
nmap <leader>gl   :0Gclog!<CR>

augroup HiddenFugitive
  autocmd!
  autocmd BufReadPost fugitive://* set bufhidden=delete
  autocmd BufReadPost .git/index set nolist
augroup end
" clean up unused fugitive buffers

" turn spell check on
nmap <silent> <leader>sp :set spell!<CR>
" search and replace in file
nnoremap <Leader>sr :%s/\<<C-r><C-w>\>/

" TODO: do I need this?
"" Don't screw up folds when inserting text that might affect them, until
"" leaving insert mode. Foldmethod is local to the window. Protect against
"" screwing up folding when switching between windows.
"autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
"autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

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
  return ''
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" ====== vim-visual-multi ======
" press n/N to get next/previous occurrence
" press [/] to select next/previous cursor
" press q to skip current and get next occurrence
" press Q to remove current cursor/selection
" start insert mode with i,a,I,A
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'           " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'           " replace visual C-n

" ====== easy-motion ======
map <leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" ======== Auto Save =========
function! s:AutosaveBuffer()
  " Don't try to autosave fugitive buffers
  " or buffers without filenames
  if @% =~? '^fugitive:' || @% ==# ''
    return
  endif

  update
endfun

augroup Autosave
  autocmd!
  autocmd BufLeave * call <SID>AutosaveBuffer()
  autocmd FocusLost * call <SID>AutosaveBuffer()
augroup end

" ====== Readline / RSI =======
inoremap <c-k> <c-o>D
cnoremap <c-k> <c-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>

" ====== Jsonnet ========
" need to disable this or it messes with git index buffers
let g:jsonnet_fmt_on_save = 0

"=== NvimTree
nnoremap <silent><nowait> <leader>\ :<c-u>NvimTreeToggle<cr>
nnoremap <silent><nowait> \| :<c-u>NvimTreeFindFile<cr>

" TODO: figure out why I need to set this at the very end?
set background=light
