set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" enable these for debugging
" let g:coc_node_args = ['-r', expand('~/.config/yarn/global/node_modules/source-map-support/register')]
" let g:node_client_debug = 1
" let $NODE_CLIENT_LOG_FILE = '~/node_client.log'
" let g:coc_node_args = ['--nolazy', '--inspect-brk=6045']

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Open diffs vertically
set diffopt=vertical

" disable python2 provider
let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python3'

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

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

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

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

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

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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

" ================ yank =============
nnoremap <leader>y :<C-u>CocCommand fzf-preview.Yankround<cr>

"=========== Other Code Actions =========
" Symbol renaming.
nmap <leader>re <Plug>(coc-rename)

" Formatting
function! s:format_and_organize()
  if CocHasProvider('format')
    call CocAction('runCommand', 'editor.action.format')
    " refresh lint warnings after reformat
    execute "ALELint"

    " TODO: not working for some reason? Seems to have been included in format?
    " call CocAction('runCommand', 'editor.action.organizeImport')
  else
    " silent execute "normal gg=G"
    " silent execute "normal \<C-o>"
    execute "ALEFix"
  endif
endfunction

xmap <silent> <leader>=  <Plug>(coc-format-selected)
nnoremap <silent> <leader>= :call <SID>format_and_organize()<CR>

"===== Coc-Explorer replaces NERDTree
nnoremap <silent><nowait> <leader>\ :CocCommand explorer<CR>
nnoremap <silent><nowait> \| :call <SID>FocusInExplorer()<CR>

function! s:FocusInExplorer()
  let l:a = 0
  for window in getwininfo()
    if getbufvar(window.bufnr, '&ft') == 'coc-explorer'
      let l:a = 1
      break
    endif
  endfor
  if l:a == 1
    call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal'], [['relative', 0, 'file']])
    execute 'CocCommand explorer --focus --no-toggle'
  else
    execute 'CocCommand explorer --reveal '.expand('%:p')
  endif
endfunction

"========= Go ===========
let g:delve_use_vimux = 1

"TODO: these functions could be smarter and could parse the current file to
"look for relevant build tags at the top of the file

function! s:dlvTestFocused(...)
  let build_flags = (a:0 > 0) ? join(a:000, ',') : ""
  let test_line = search("func Test", "bs")

  if test_line > 0
    let line = getline(test_line)
    let test_name_raw = split(line, " ")[1]
    let test_name = split(test_name_raw, "(")[0]

    if len(build_flags) > 0
      call delve#dlvTest(expand('%:p:h'), '--build-flags="-tags=' . build_flags . '"', '--', '-test.run', test_name)
    else
      call delve#dlvTest(expand('%:p:h'), '--', '-test.run', test_name)
    endif
  else
    echo "No test found"
  endif
endfunction

command! -nargs=* DlvTestFocused call s:dlvTestFocused(<f-args>)

function! GolangTestFocusedWithTags(...)
  let build_flags = (a:0 > 0) ? join(a:000, ',') : ""
  let test_line = search("func Test", "bs")

  let separator = ShellCommandSeperator()

  if test_line > 0
    let line = getline(test_line)
    let test_name_raw = split(line, " ")[1]
    let test_name = split(test_name_raw, "(")[0]

    if len(build_flags) > 0
      call VimuxRunCommand("cd " . GolangCwd() . " " . separator . " clear " . separator . " go test " . '-tags="' . build_flags . '" ' . GolangFocusedCommand(test_name) . " -v " . GolangCurrentPackage())
    else
      call VimuxRunCommand("cd " . GolangCwd() . " " . separator . " clear " . separator . " go test " . GolangFocusedCommand(test_name) . " -v " . GolangCurrentPackage())
    endif

  else
    echo "No test found"
  endif
endfunction

command! -nargs=* GolangTestFocusedWithTags call GolangTestFocusedWithTags(<f-args>)

augroup go
  autocmd!

  " open test in a vertical split
  autocmd FileType go nmap <leader>gt  :<C-u>CocCommand go.test.toggle<cr>
  autocmd FileType go nmap <silent>gT :<C-u>wincmd o<cr> :vsplit<cr> :<C-u>CocCommand go.test.toggle<cr>
  autocmd FileType go nmap <leader>t   :<C-u>CocCommand go.test.generate.function<cr>
  autocmd FileType go nmap <leader>i   :<C-u>CocCommand go.impl.cursor<cr>

  " run tests
  autocmd FileType go nmap <Leader>rp  :wa<CR> :GolangTestCurrentPackage<CR>
  autocmd FileType go nmap <Leader>rt  :wa<CR> :GolangTestFocused<CR>

  " run integration tests
  autocmd FileType go nmap <leader>ri  :wa<cr> :GolangTestFocusedWithTags e2e_gme requires_docker<cr><C-o>

  " delve
  autocmd FileType go nmap <leader>bp  :DlvToggleBreakpoint<cr>
  autocmd FileType go nmap <leader>dt  :wa<cr> :DlvTestFocused<CR><C-o>

  " delve integration test
  autocmd FileType go nmap <leader>di  :wa<cr> :DlvTestFocused e2e_gme requires_docker<cr><C-o>

  " tags
  autocmd FileType go nmap <leader>tj :CocCommand go.tags.add json<cr>
  autocmd FileType go nmap <leader>ty :CocCommand go.tags.add yaml<cr>
  autocmd FileType go nmap <leader>tx :CocCommand go.tags.clear<cr>

  " search
  autocmd FileType go nmap <leader>gr :Rg -g '**/*.go' --
augroup END

" ==== JSONNET ====
function! JsonnetEval()
  " check if the file is a tanka file or not
  let output = system("tk tool jpath " . shellescape(expand('%')))
  if v:shell_error
    let output = system("jsonnet " . shellescape(expand('%')))
  else
    let output = system("tk eval " . shellescape(expand('%')))
  endif
  vnew
  setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile ft=json
  put! = output
endfunction

function! JsonnetExpand()
  " check if the file is a tanka file, and if so get its JSONNET_PATH
  let jsonnet_path = system('tk tool jpath ' . shellescape(expand('%')))
  if v:shell_error
    let output = system('jsonnet-tool expand ' . shellescape(expand('%')))
  else
    let output = system("JSONNET_PATH=\"" . jsonnet_path . "\" jsonnet-tool expand " . shellescape(expand('%')))
  endif
  vnew
  setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile ft=jsonnet
  put! = output
endfunction

augroup jsonnet
  autocmd!
  autocmd FileType jsonnet nmap <leader>b :call JsonnetEval()<cr>
  autocmd FileType jsonnet nmap <leader>e :call JsonnetExpand()<cr>
augroup END

" ==== fzf config =====
" the open in split functionality relies on coc-explorer
" so we only define these actions for nvim

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'enter': 'FzfSelectSplit',
  \ '': 'FzfSelectSplit' }
