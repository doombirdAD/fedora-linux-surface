#!/bin/bash

# Figure out where and what we are
if [[ ! -e /etc/os-release ]]; then
  echo "Missing fedora-release-common package or not a Fedora install, exiting."
  exit 3
fi

. /etc/os-release

RELEASE="f${VERSION_ID}"
if [[ ! -d patches/${RELEASE} ]]; then
  echo "${RELEASE} is not currently supported."
  echo "Currently supported versions are:"
  ls patches
  exit 3
fi

echo "Building kernel for Fedora ${RELEASE}.\n"
sleep 3

## CLONE REPOSITORIES

# Start with rpmdev-buildtree.  It's idempotent so it's not a problem to
# run it multiple times.
rpmdev-setuptree

cd build

# clone jakeday/linux-surface
git clone https://github.com/jakeday/linux-surface

# clone Fedora kernel repository
# (We use fedpkg to manage practically every aspect of package building
# on Fedora.)
fedpkg clone -a --branch ${RELEASE} kernel

## BUILD KERNEL PACKAGES

# Get kernel Maj.min version
# (needed to figure out correct patches to pull from jakeday repo)
KERNELVER=$(fedpkg --path kernel verrel | \
  sed -e 's/^kernel-\([^.]*\)\.\([^.]*\)\..*$/\1.\2/')

# Move jakeday patches to local directory
cp linux-surface/patches/${KERNELVER}/*.patch kernel/

cd kernel
#  Apply our patches to Fedora repository
git am ../../patches/${RELEASE}/*.patch

# Build new configs based off of the changes to the config file tree
configs/build_configs.sh

# run the fedpkg command which will build the kernel packages
# TODO: The kernel source is going to be 21+G, Make sure we have space
fedpkg --release ${RELEASE} local

# Copy RPMs to rpm/ directory
cd ../
mv kernel/x86_64/*.rpm ../rpms/

# TODO: Collect firmware packages from jakeday/linux-surface
# into rpm packages.
