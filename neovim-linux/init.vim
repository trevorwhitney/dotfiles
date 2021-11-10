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

xmap <silent> <leader>=  <Plug>(coc-format-selected)

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

" Ripgrep for the word under cursor
nnoremap <leader>rg :<C-u>Rg<Space><C-R>=expand('<cword>')<CR><CR>
nnoremap <leader>* :<C-u>Rg<Space><C-R>=expand('<cword>')<CR><CR>
" Ripgrep for the visually selected text
xnoremap <leader>rg "sy:Rg -- <C-R>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR><CR>
xnoremap <leader>* "sy:Rg -- <C-R>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR><CR>

" treesitter config
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "bash",
    "c",
    "go",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "css",
    "rust",
    "java",
    "yaml",
    "vim",
  }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "haskell" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
