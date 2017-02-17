#!/bin/bash

describe 'python'
  it 'installs pyenv'
    pyenv --version > /dev/null
    assert equal "$?" "0"
  end

  it 'installs pyenv virtualenv'
    pyenv virtualenv --version > /dev/null
    assert equal "$?" "0"
  end

  it 'installs python 2.7.11'
    assert file_present $HOME/.pyenv/versions/2.7.11
  end

  it 'installs python 3.4.4'
    assert file_present $HOME/.pyenv/versions/3.4.4
  end

  it 'creates a virtualenv for neovim for python 2'
    assert file_present $HOME/.pyenv/versions/neovim2/bin/python
  end

  it 'creates a virtualenv for neovim for python 3'
    assert file_present $HOME/.pyenv/versions/neovim3/bin/python
  end
end
