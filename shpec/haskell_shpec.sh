#!/bin/bash

describe "haskell"
  describe "binaries"
    it "installs stack"
      assert present $(which stack)
    end

    it "installs hlint"
      assert present $(which hlint)
    end

    it "installs stylish-haskell"
      assert present $(which stylish-haskell)
    end

    it "installs hindent"
      assert present $(which hindent)
    end

    it "installs ghc-mod"
      assert present $(which ghc-mod)
    end

    it "installs hdevtools"
      assert present $(which hdevtools)
    end

    it "installs fast-tags"
      assert present $(which fast-tags)
    end
  end
end
