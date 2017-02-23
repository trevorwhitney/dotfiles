#!/bin/bash

describe "dependencies"
  describe "binaries"
    it "installs the git binary"
      assert present $(which git)
    end

    it "installs the ag binary"
      assert present $(which ag)
    end

    it "installs the uncrustify binary"
      assert present $(which uncrustify)
    end

    it "installs the curl binary"
      assert present $(which curl)
    end

    it "installs the direnv binary"
      assert present $(which direnv)
    end

    it "installs the gawk binary"
      assert present $(which gawk)
    end

    it "installs the astyle binary"
      assert present $(which astyle)
    end
  end
end
