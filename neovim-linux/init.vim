set nocompatible
syntax on
filetype plugin indent on

let mapleader = " "

" enable these for debugging coc
" let g:coc_node_args = ['-r', expand('~/.config/yarn/global/node_modules/source-map-support/register')]
" let g:node_client_debug = 1
" let $NODE_CLIENT_LOG_FILE = '~/node_client.log'
" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']

let s:packer_install_path = stdpath('data') . '/site/pack/packer/start/packer.nvim'
let s:vim_lib_install_path = stdpath('data') . '/site/pack/packer/start/tw-vim-lib'

if empty(glob(s:packer_install_path)) > 0
  execute('!git clone https://github.com/wbthomason/packer.nvim ' . s:packer_install_path)
endif

if empty(glob(s:vim_lib_install_path)) > 0
  execute('!git clone https://github.com/trevorwhitney/tw-vim-lib ' . s:vim_lib_install_path)
endif

augroup Packer
  autocmd!
  autocmd BufWritePost init.lua PackerCompile
augroup end

lua <<EOF
local use = require('packer').use
require('tw.packer').install(use)
require('tw.config').setup()
EOF

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

" formatter
nnoremap <leader>= :call tw#format#Format()<cr>
xmap <silent> <leader>=  <Plug>(coc-format-selected)

nnoremap <silent> \q ZZ
nnoremap <silent> \Q :xa<cr>

" search and replace
nnoremap <Leader>sr :%s/\<<C-r><C-w>\>/

" ====== Git (vim-fugitive) =====
" Set var for things that should only be enabled in git repos
let g:in_git = system('git rev-parse --is-inside-work-tree')

" Git status, show currently changed files
nmap <leader>gb   :Git blame<CR>
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

" clean up unused fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost .git/index set nolist

" ==== Fzf and fzf preview ====
" find file (in git files if in git repo)
nnoremap <leader>ff :GFiles<cr>
" find file (in all files)
nnoremap <leader>fa :Files<cr>

" turn spell check on
nmap <silent> <leader>sp :set spell!<CR>
" search and replace in file
nnoremap <Leader>sr :%s/\<<C-r><C-w>\>/

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

"============= surround vim ============
" surround.vim: Add $ as a jQuery surround, _ for Underscore.js
autocmd FileType javascript let b:surround_36 = "$(\r)"
      \ | let b:surround_95 = "_(\r)""

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

" ========= grep ==============
" use ripgrep for grep command
if executable("rg")
  set grepprg=rg\ --vimgrep
endif

" Ripgrep for the word under cursor
nnoremap <leader>rg :<C-u>Rg<Space><C-R>=expand('<cword>')<CR><CR>
nnoremap <leader>* :<C-u>Rg<Space><C-R>=expand('<cword>')<CR><CR>
" Ripgrep for the visually selected text
xnoremap <leader>rg "sy:Rg -- <C-R>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR><CR>
xnoremap <leader>* "sy:Rg -- <C-R>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR><CR>

" ======== Auto Save =========
function! s:AutosaveBuffer()
  " Don't try to autosave fugitive buffers
  " or buffers without filenames
  if @% =~? '^fugitive:' || @% ==# ''
    return
  endif

  update
endfun

autocmd BufLeave * call <SID>AutosaveBuffer()
autocmd FocusLost * call <SID>AutosaveBuffer()

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
      \   'jsonnet': ['jsonnetfmt'],
      \   'vim': [function('tw#format#vim')]
      \}

" disabling to not mess with fugitive index buffers
let g:ale_fix_on_save=0

" ====== Jsonnet ========
" need to disable this or it messes with git index buffers
let g:jsonnet_fmt_on_save = 0

" ==== Fzf and fzf preview ====
let g:fzf_preview_command = 'bat --color=always --plain --number {-1}'
let g:fzf_preview_lines_command = 'bat --color=always --plain --number'
let g:fzf_preview_preview_key_bindings = 'ctrl-a:select-all'
let g:fzf_preview_grep_cmd = 'rg --line-number --no-heading --color=always'
let g:fzf_preview_window = ['']

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=auto:2
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use enter to seelect auto-complete suggestion
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

" close coc floats when they get annoying
inoremap kk <C-o>:call coc#float#close_all()<cr>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD :<C-u>call CocAction('jumpDefinition', 'CocSelectSplit')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gY :<C-u>call CocAction('jumpTypeDefinition', 'CocSelectSplit')<CR>
nmap <silent> gi :<C-u>CocCommand fzf-preview.CocImplementations<CR>
nmap <silent> gr :<C-u>CocCommand fzf-preview.CocReferences<CR>

" Use <leader>h to show documentation in preview window.
nnoremap <leader>h :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>aa  <Plug>(coc-codeaction-cursor)
nmap <leader>ac  <Plug>(coc-codeaction)

xmap <leader>rf   <Plug>(coc-refactor)

" Apply AutoFix to problem on the current line.
nmap <leader><cr>  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <nowait> \a  :<C-u>CocCommand fzf-preview.CocDiagnostics<cr>
" Show diagnostics for current file
nnoremap <nowait> \x  :<C-u>CocCommand fzf-preview.CocCurrentDiagnostics<cr>
" Show recent files
nnoremap <nowait> \e  :<C-u>CocCommand fzf-preview.MruFiles<cr>
" Show open buffers
nnoremap <nowait> \b  :<C-u>CocCommand fzf-preview.Buffers<cr>
" Show commands.
nnoremap <nowait> \c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <nowait> \o  :<C-u>CocList outline<cr>
" Resume latest coc list.
nnoremap <nowait> \r  :<C-u>CocListResume<CR>
" Resume latest grep
nnoremap <nowait> \g  :<C-u>CocCommand fzf-preview.ProjectGrepRecall<CR>

" Do default action for next (search/liSt) item.
nnoremap <silent><nowait> ]s  :<C-u>CocNext<CR>
" Do default action for previous (search/liSt) item.
nnoremap <silent><nowait> [s  :<C-u>CocPrev<CR>

" =============== Git ==============
nmap <leader>ci  <Plug>(coc-git-chunkinfo)

" navigate git chunks when not in diff mode
nnoremap <silent> <expr> [c &diff ? '[c' : ':execute "normal \<Plug>(coc-git-prevchunk)"<cr>'
nnoremap <silent> <expr> ]c &diff ? ']c' : ':execute "normal \<Plug>(coc-git-nextchunk)"<cr>'

" git/chunk revert
nmap <leader>cr :<C-u>CocCommand git.chunkUndo<cr>

nmap <silent> ]x  <Plug>(coc-git-nextconflict)
nmap <silent> [x  <Plug>(coc-git-prevconflict)

nmap <leader>kc <Plug>(coc-git-keepcurrent)
nmap <leader>ki <Plug>(coc-git-keepincoming)
nmap <leader>kb <Plug>(coc-git-keepboth)

" Git status, show currently changed files
nmap <leader>ga   :<c-u>CocCommand fzf-preview.GitActions<CR>

let g:airline#extensions#hunks#coc_git = 1

" find symbol
nnoremap <leader>fs :<C-u>CocFzfList symbols

"=========== Other Code Actions =========
" Symbol renaming.
nmap <leader>re <Plug>(coc-rename)


"=== NvimTree
nnoremap <silent><nowait> <leader>\ :<c-u>NvimTreeToggle<cr>
nnoremap <silent><nowait> \| :<c-u>NvimTreeFindFile<cr>

" === Begin filetype specific
" TODO: move to ftplugin files

"========= Go ===========
augroup go
  autocmd!

  " open test in a vertical split
  autocmd FileType go nmap <leader>gt  :<C-u>CocCommand go.test.toggle<cr>
  autocmd FileType go nmap <silent>gT :<C-u>wincmd o<cr> :vsplit<cr> :<C-u>CocCommand go.test.toggle<cr>
  autocmd FileType go nmap <leader>t   :<C-u>CocCommand go.test.generate.function<cr>
  autocmd FileType go nmap <leader>i   :<C-u>CocCommand go.impl.cursor<cr>

  " run tests
  autocmd FileType go nmap <Leader>rp  :wa<CR> :GolangTestCurrentPackage<CR>
  autocmd FileType go nmap <Leader>rt  :wa<CR> :GolangTestFocusedWithTags<CR>

  " run integration tests
  autocmd FileType go nmap <leader>ri  :wa<cr> :GolangTestFocusedWithTags e2e_gme requires_docker<cr>

  " delve
  autocmd FileType go nmap <leader>bp  :DlvToggleBreakpoint<cr>
  autocmd FileType go nmap <leader>dt  :wa<cr> :DlvTestFocused<cr>

  " delve integration test
  autocmd FileType go nmap <leader>di  :wa<cr> :DlvTestFocused e2e_gme requires_docker<cr>

  " tags
  autocmd FileType go nmap <leader>tj :CocCommand go.tags.add json<cr>
  autocmd FileType go nmap <leader>ty :CocCommand go.tags.add yaml<cr>
  autocmd FileType go nmap <leader>tx :CocCommand go.tags.clear<cr>

  " search
  autocmd FileType go nmap <leader>gr :Rg -g '**/*.go' --
augroup END

" ==== JSONNET ====
augroup jsonnet
  autocmd!
  autocmd FileType jsonnet call tw#jsonnet#updateJsonnetPath()
  autocmd FileType jsonnet nmap <leader>b :call tw#jsonnet#eval()<cr>
  autocmd FileType jsonnet nmap <leader>e :call tw#jsonnet#expand()<cr>
augroup END

"========= Yaml ==============
" disable yaml indenting logic
autocmd FileType yaml setlocal indentexpr=

" =========== VimL ==========
augroup vader
  autocmd!

  " run tests with vader
  autocmd FileType vader nmap <Leader>rt  :wa<CR> :Vader %<CR>
augroup END

" ======= Markdown ==========
let g:textobj_markdown_no_default_key_mappings=1

" TODO: move to filetype specific
omap imc <plug>(textobj-markdown-chunk-i)
xmap imc <plug>(textobj-markdown-chunk-i)
omap amc <plug>(textobj-markdown-chunk-a)
xmap amc <plug>(textobj-markdown-chunk-a)


" TODO: figure out why I need to set this at the very end
set background=light
