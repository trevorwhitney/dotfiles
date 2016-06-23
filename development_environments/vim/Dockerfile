FROM debian:jessie
RUN apt-get update && apt-get install -y git vim
RUN git clone https://github.com/trevorwhitney/dotfiles.git ~/.dotfiles
RUN ~/.dotfiles/install.sh
CMD /bin/bash

#Once complete, log in to image, open vim, run :PluginInstall, and commit changes to image