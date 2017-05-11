FROM ubuntu:trusty
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ADD dotfiles.tar.gz /root/.dotfiles
RUN chown -R root:root /root/.dotfiles

WORKDIR /root/.dotfiles
RUN sudo apt-get update && sudo apt-get install -y gawk
ENV DOTFILES_USER root
RUN bin/install.sh full --skip-tests
