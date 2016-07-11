FROM debian:jessie
RUN apt-get update && apt-get install -y git vim curl && apt-get -y clean
RUN git clone https://github.com/trevorwhitney/dotfiles.git ~/.dotfiles
RUN ~/.dotfiles/install.sh
CMD /bin/bash

