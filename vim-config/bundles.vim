Plug 'AndrewRadev/bufferize.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'coachshea/vim-textobj-markdown'
Plug 'dense-analysis/ale'
Plug 'easymotion/vim-easymotion'
Plug 'google/vim-jsonnet'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', { 'do': { -> fzf#install() } }
Plug 'junegunn/vader.vim'
Plug 'jvirtanen/vim-hcl'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'LeafCage/yankround.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/emmet-vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'pedrohdz/vim-yaml-folds'
Plug 'preservim/nerdtree'
Plug 'roxma/vim-tmux-clipboard'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'trevorwhitney/tw-vim-lib'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }

if !has('nvim')
 Plug 'vim-colors-solarized/colors'
endif
