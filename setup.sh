#!/bin/bash

# Get argument, set as RELEASE and enforce it's one of f{29,30,31} (more will be supported later.)

case $1 in
	/29|f29|F29/) RELEASE="f29";;
	/30|f30|F30/) RELEASE="f30";;
	/31|f31|F31/) RELEASE="f31";;
	*)
		echo "Unsupported release version $1."
		exit 3
		;;
esac

# clone Fedora kernel repository
## TODO: The Fedora repo plus the kernel repo is 25+ GiB.  Make sure we have space
fedpkg clone -a kernel
cd kernel

# check out origin/$RELEASE
git checkout ${RELEASE}

## Get kernel version (needed to figure out correct patches to pull from jakeday)
KERNELVER=$(fedpkg verrel | sed -e 's/^kernel-\([^.]*\)\.\([^.]*\)\..*$/\1.\2/')


# Clone jakeday/linux-surface to get latest matching patches
git clone https://github.com/jakeday/linux-surface
## Move jakeday patches to local directory
cp linux-surface/patches/${KERNELVER}/*.patch .

# Apply my patches to Fedora repository
git am ../patches/${RELEASE}/*.patch

# Build new configs
configs/build_configs.sh

# run `fedpkg --release $RELEASE local`
fedpkg --release ${RELEASE} local

# Copy RPMs to rpm/ directory
cd ../
mv kernel/x86_64/*.rpm rpms/
