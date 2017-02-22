FROM ubuntu:trusty
ENV HOME /root
ADD dotfiles.tar.gz /root/.dotfiles
RUN chown -R root:root /root/.dotfiles

WORKDIR /root/.dotfiles
RUN sudo apt-get update && sudo apt-get install -y gawk
RUN bin/install.sh --skip-tests
