let mapleader = ' ' " space as leader

lua <<EOF
-- Packer is installed via home-manager, so need to setup
-- the packpath so packer can install packages outside of the nix store
local fn = vim.fn
local package_root = table.concat({fn.stdpath('data'), "site", "pack"}, "/")
vim.cmd("set packpath^=" .. package_root)

local install_path = table.concat({package_root, "packer", "start", "packer.nvim"}, "/")
local compile_path = table.concat({install_path, "plugin", "packer_compiled.lua"}, "/")

local vim_lib_install_path = package_root .. '/packer/start/tw-vim-lib'

-- all my config (including packer) is in my tw-vim-lib plugin, so fetch that manually
if fn.empty(fn.glob(vim_lib_install_path)) > 0 then
	vim_lib_bootstrap = fn.system({'git', 'clone', 'https://github.com/trevorwhitney/tw-vim-lib', vim_lib_install_path})
end

require("packer").init({
	package_root = package_root,
	compile_path = compile_path,
})

require('tw.packer').install(require('packer').use)

-- sync packer if this is a fresh install
if vim_lib_bootstrap then
  require('packer').sync()
end

require('tw.config').setup()
EOF

" turn off CGO for go diagnostic tools
call setenv('CGO_ENABLED', 0)

" For some reason I have to set this last or it ends up
" being set to dark. I'm guessing a plugin is doing this?
set background=light
