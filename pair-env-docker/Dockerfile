FROM ubuntu:groovy

RUN apt update && apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  docker \
  docker-compose \
  git \
  gnupg \
  iptables \
  locales \
  lsb-release \
  openssh-server \
  sudo \
  systemd \
  zsh

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && \
  apt-get install -y docker-ce docker-ce-cli containerd.io

RUN systemctl enable ssh docker

# remove ssh keys
RUN rm -vrf /etc/ssh/ssh_host*

# provide a fake modprobe
RUN ln -s true /bin/modprobe

# switch to compat iptables (otherwise docker fails)
RUN \
  update-alternatives --set iptables /usr/sbin/iptables-legacy && \
  update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

RUN groupadd -g 1000 pair
RUN useradd -u 1000 -g 1000 --groups docker,sudo,users -ms /bin/zsh pair && \
  chown -R root:users /usr/local && \
  chmod -R 775 /usr/local

# Give pair passwordless access to sudo for dotfiles install
RUN echo "pair    ALL= (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  mkdir /dotfiles

USER pair
COPY . /dotfiles
WORKDIR /dotfiles

# locale settings so pretty fonts/zsh themes work
ENV TZ "America/Denver"
ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# Set the timezone to make tzdata happy about being noninteractive
RUN sudo ln -fs /usr/share/zoneinfo/America/Denver /etc/localtime
RUN DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends tzdata \
  && sudo dpkg-reconfigure --frontend noninteractive tzdata

# Install dotfiles
COPY ./pair-env-docker/dotexclude /home/pair/.dotexclude
RUN sudo chown -R pair:pair /home/pair /dotfiles
RUN /bin/zsh -l install

# Clean up unused files and
# Remove last line from sudoers file to revoke passwordless sudo access for pair user
RUN ./pair-env-docker/clean.sh && sudo sed -i '$ d' /etc/sudoers

VOLUME [ "/sys/fs/cgroup" ]

USER root
COPY ./pair-env-docker/run.sh /run.sh
CMD ["/run.sh"]
