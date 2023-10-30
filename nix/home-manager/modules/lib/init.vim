" moved this into the vim plugin, does it work there?
" let mapleader = ' ' " space as leader
" call setenv('CGO_ENABLED', 0)

lua <<EOF
local lua_ls_path = vim.api.nvim_eval('get(s:, "lua_ls_path", "")')
local rocks_tree_root = vim.api.nvim_eval('get(s:, "rocks_tree_root", "")')
require('tw.config').setup({
  lua_ls_root = lua_ls_path,
  rocks_tree_root = rocks_tree_root,
})
EOF
