This is all the linux specific stuff that was removed.

```bash
sudo apt-get install -y \
    software-properties-common \
    python-software-properties

  sudo add-apt-repository -y ppa:jonathonf/vim
  sudo apt-get update

  sudo apt-get install -y \
    vim \
    gettext \
    silversearcher-ag \
    uncrustify \
    curl \
    git \
    build-essential \
    zlibc \
    zlib1g-dev \
    libyaml-dev \
    openssl \
    libxslt-dev \
    libxml2-dev \
    libssl-dev \
    libreadline6 \
    libreadline6-dev \
    autoconf \
    dh-autoreconf \
    pkg-config \
    jq \
    wget

  function install_direnv() {
    sudo curl -Lk https://github.com/direnv/direnv/releases/download/v2.10.0/direnv.linux-amd64 \
      -o /usr/local/bin/direnv
    sudo chmod a+x /usr/local/bin/direnv
  }
  if [ ! `which direnv` ]; then install_direnv; fi

  function install_astyle() {
    mkdir -p $HOME/tmp/astyle
    curl -L https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_linux.tar.gz/download -o ~/tmp/astyle/astyle.tar.gz
    pushd $HOME/tmp/astyle
      tar -xzf astyle.tar.gz
      pushd astyle/build/gcc
        make
        sudo cp bin/astyle /usr/local/bin/astyle
        sudo chmod a+x /usr/local/bin/astyle
      popd
    popd
    rm -rf ~/tmp/astyle
  }
  if [ ! `which astyle` ]; then install_astyle; fi

  function install_universal_ctags() {
    mkdir -p ~/tmp
    pushd ~/tmp
      git clone https://github.com/universal-ctags/ctags.git
      pushd ctags/
        ./autogen.sh
        ./configure --prefix=/usr/local
        make
        sudo make install
      popd
    popd
  }
  if [ ! `which ctags` ]; then install_universal_ctags; fi
```

```bash
sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install -y neovim
```

```bash
[ -h "$HOME/.tmux.conf" ] && rm -rf "$HOME/.tmux.conf"
ln -s "$dotfiles_dir/tmux.linux.conf" "$HOME/.tmux.conf"
```
