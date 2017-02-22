FROM ubuntu:trusty
ENV HOME /root
ADD dotfiles.tar.gz /root/.dotfiles

WORKDIR /root/.dotfiles
RUN sudo apt-get update && sudo apt-get install -y gawk
