FROM trevorwhitney/vim
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442
RUN echo 'deb http://download.fpcomplete.com/debian jessie main' > /etc/apt/sources.list.d/fpco.list
RUN apt-get update && apt-get install -y stack && apt-get -y clean
RUN stack setup
RUN stack install hlint stylish-haskell hindent ghc-mod
ENV PATH /root/.local/bin:$PATH
CMD /bin/bash
