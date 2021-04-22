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

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
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

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <leader>[ <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <leader>] <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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
nnoremap <silent><nowait> \a  :<C-u>CocList --normal diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> \x  :<C-u>CocList extensions<cr>
" Show recent files
nnoremap <silent><nowait> \e  :<C-u>CocList mru<cr>
" Show open buffers
nnoremap <silent><nowait> \b  :<C-u>CocList buffers<cr>
" Show commands.
nnoremap <silent><nowait> \c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> \o  :<C-u>CocList --normal outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> \s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> \j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> \k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> \p  :<C-u>CocListResume<CR>

nnoremap <silent><expr> <C-p> pumvisible() ? "<C-p>" : ":<C-u>CocList files<cr>"

" =============== Git ==============
nnoremap <leader>ci <Plug>(coc-git-chunkinfo)
nnoremap <silent> [c <Plug>(coc-git-prevchunk)
nnoremap <silent> ]c <Plug>(coc-git-nextchunk)
nnoremap <leader>cr :<C-u>CocCommand git.chunkUndo<cr>
nnoremap <leader>gr :<C-u>CocCommand git.chunkUndo<cr>

nnoremap <leader>gn <Plug>(coc-git-nextconflict)
nnoremap <leader>gp <Plug>(coc-git-prevconflict)

nnoremap <leader>kc <Plug>(coc-git-keepcurrent)
nnoremap <leader>ki <Plug>(coc-git-keepincoming)
nnoremap <leader>kb <Plug>(coc-git-keepboth)

let g:airline#extensions#hunks#coc_git = 1

" ================ yank =============
nnoremap <silent> <leader>y :<C-u>CocList -A --normal yank<cr>

" ==== find/grep ====
command! -nargs=+ -complete=custom,s:GrepArgs Rg exe 'CocList -A --normal grep '.<q-args>

function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

nnoremap <silent> <Leader>ff :exe 'CocList -I --input='.expand('<cword>').' grep'<CR>
xnoremap <silent> <leader>f :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
nnoremap <silent> <leader>f :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@

function! s:GrepFromSelected(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let word = substitute(@@, '\n$', '', 'g')
  let word = escape(word, '| ')
  let @@ = saved_unnamed_register
  execute 'CocList -A --normal grep '.word
endfunction

"=========== Other Code Actions =========
" Symbol renaming.
nmap <leader>re <Plug>(coc-rename)

" Formatting
function! s:format_and_organize()
  if CocHasProvider('format')
    call CocAction('runCommand', 'editor.action.format')
    " TODO: not working for some reason? Seems to have been included in
    " format?
    " call CocAction('runCommand', 'editor.action.organizeImport')
  else
    silent execute "normal gg=G"
    silent execute "normal \<C-o>"
  endif
endfunction

xmap <silent> <leader>=  <Plug>(coc-format-selected)
nnoremap <silent> <leader>= :call <SID>format_and_organize()<CR>

"========= Go ===========
let g:delve_use_vimux = 1

augroup go
  autocmd!
  autocmd FileType go nmap <silent> gt :<C-u>CocCommand go.test.toggle<cr>
  autocmd FileType go nmap <leader>t   :<C-u>CocCommand go.test.generate.function<cr>
  autocmd FileType go nmap <leader>i   :<C-u>CocCommand go.impl.cursor<cr>
  autocmd FileType go nmap <Leader>rp  :wa<CR> :GolangTestCurrentPackage<CR>
  autocmd FileType go nmap <Leader>rt  :wa<CR> :GolangTestFocused<CR>
  autocmd FileType go nnoremap <silent><nowait> \b  :DlvToggleBreakpoint<cr>
  autocmd FileType go nmap <leader>dt  :wa<cr> :DlvTest<CR>
  " delve integration test
  autocmd FileType go nmap <leader>dit  :wa<cr> :DlvTest --build-flags="-tags=requires_docker,e2e_gme"<CR>
  autocmd FileType go nmap <leader>tj :CocCommand go.tags.add json<cr>
  autocmd FileType go nmap <leader>ty :CocCommand go.tags.add yaml<cr>
  autocmd FileType go nmap <leader>tx :CocCommand go.tags.clear<cr>
augroup END
