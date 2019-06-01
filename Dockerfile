ARG RELEASE=latest
FROM fedora:${RELEASE}
LABEL maintainer="Tony Kelly <apatheticelation+github@gmail.com>"

RUN dnf update -y && yum clean all

RUN dnf install fedpkg fedora-packager rpmdevtools ncurses-devel pesign && yum clean all

ENTRYPOINT bash ./setup.sh

VOLUME rpms/
