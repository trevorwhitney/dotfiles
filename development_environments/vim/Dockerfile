FROM debian:jessie
ENV HOME /root
RUN (apt-get update && \
    apt-get install -y --fix-missing build-essential software-properties-common \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev \
    libxml2-dev libxslt-dev git wget curl vim && \
    apt-get -y clean)

# Add a non-root user
RUN (useradd -m -d /home/docker -s /bin/bash docker && \
    echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers)

USER docker
ENV HOME /home/docker
WORKDIR /home/docker

RUN git clone https://github.com/trevorwhitney/dotfiles.git $HOME/.dotfiles
RUN $HOME/.dotfiles/install.sh
CMD /bin/bash

