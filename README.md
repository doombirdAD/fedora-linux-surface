# fedora-linux-surface
Fedora Linux kernel patching scripts and procedures for MS Surface devices based on jakeday's [Surface device kernel build process](https://github.com/jakeday/linux-surface).

This is a repostitory hosting the scripts and information one would need to run on Fedora Linux to build and install a kernel for the MS Surface line of tablets and laptops.  

While the Jake Day scripts work well to build for Ubuntu/Debian and for once off generic kernels, the way Fedora packages its kernel can cause issues.  Fedora uses much smaller images, so the typical Fedora install will have a correspondingly smaller /boot partition.  If a user tries to install multiple kernels using the typcal kernel build process, it will quickly run /boot out of space.  Furthermore, trying to manage updated kernel packages from DNF/yum alongside custom built and manualy installed kernels is a drag.  

I created this repository and script set to incorporate Jake Day's work on the kernel for Surface devices into the standard Fedora build process so that the system can treat those kernels the same as it would any other maintained kernel package.

Currently under construction.

## Prepare

Firstly, you'll want to make sure your Fedora installation is prepared to build using the Fedora build system.

```
dnf install -y fedpkg fedora-packager rpmdevtools ncurses-devel pesign
```

Clone this repository locally

```
git clone https://github.com/doombirdAD/fedora-linux-surface.git
cd fedora-linux-surface
```

## Building

To build, run the setup script
```
bash ./setup.sh
```
to build the branch for your current version of Fedora.

The script will 
1. clone the kernel from the Fedora Project GIT repository
2. checkout the branch that matches the version you selected
3. clone the jakeday/linux-surface repository to get Jake Day's linux-surface patches
4. apply patches that allow the automated Fedora packager to incorporate the linux-surface patches
5. run the `fedpkg --release <release> local` to build the kernel packages locally.

The process will take several hours to completely compile and package the new kernel build.  Once the script is done, the RPMs will be in the rpms subdirectory, with ".surface" added to the version string to distinguish them from official released packages.

## To Do:
In no particular order,

1. Manage space when downloading kernel source (check free space, shallow clone, etc)
1. setup script interactive: ask to auto-install kernel
1. Host published packages (not everyone is interested in building a kernel from scratch.)
1. Automate inclusion of firmware from jakeday's repo (create .rpm for firmware versions, maybe?)
1. Automate inclusion of config files from jakeday
1. Automate inclusion of xorg/pulse configs from jakeday
1. Futzing with suspend/hibernate
1. Better documentation
1. Sanity checks in setup script
1. Dockerfile to allow building on vanilla Fedora container
