FROM trevorwhitney/pairing:base

USER root

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN systemctl enable ssh docker

COPY ./pair-env-docker/run.sh /run.sh
CMD ["/run.sh"]
