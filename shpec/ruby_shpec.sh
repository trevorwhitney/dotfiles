#!/bin/bash

export PATH=$HOME/.rbenv/bin:$PATH

describe 'ruby'
  it 'installs rbenv'
    assert present $(which rbenv)
  end

  it 'installs ruby 2.3.1'
    assert file_present $HOME/.rbenv/versions/2.3.1
  end
end
