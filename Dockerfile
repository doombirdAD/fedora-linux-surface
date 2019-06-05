FROM fedora:latest
LABEL maintainer="Tony Kelly <apatheticelation+github@gmail.com>"

RUN dnf update -y && yum clean all

RUN dnf install -y fedpkg fedora-packager rpmdevtools ncurses-devel pesign && yum clean all

ADD setup.sh /setup.sh
ADD patches/ /patches/

VOLUME rpms/
