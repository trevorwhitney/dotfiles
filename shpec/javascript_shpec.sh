#!/bin/bash

describe "javascript"
  it "installs npm"
    assert present $(which npm)
  end

  it "installs bower"
    assert present $(which bower)
  end

  it "installs pulp"
    assert present $(which pulp)
  end

  describe "elm"
    for bin in  elm \
                elm-test \
                elm-oracle \
                elm-format \
                elm-reactor \
                elm-repl \
                elm-package \
                elm-make; do
      it "installs ${bin}"
        assert present $(which ${bin})
      end
    done
  end
end
