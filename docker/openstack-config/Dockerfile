FROM centos:8
MAINTAINER "Will Szumski" <will@stackhpc.com>

ENV container docker

RUN dnf update -y && \
    dnf install -y sudo git python3-pyyaml python3-virtualenv libffi-devel openssh-clients which && \
    dnf clean all

ENV KAYOBE_USER=stack
ARG KAYOBE_USER_UID=1000
ARG KAYOBE_USER_GID=1000

RUN groupadd -g $KAYOBE_USER_GID -o stack &&  \
    useradd -u $KAYOBE_USER_UID -g $KAYOBE_USER_GID \
    -G wheel -m -d /stack \
    -o -s /bin/bash stack
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /stack
USER stack
