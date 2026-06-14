# Boykisser Linux builder image :3
# Debian trixie with everything live-build needs. Run it --privileged.
FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends \
        live-build \
        debootstrap \
        squashfs-tools \
        xorriso \
        isolinux \
        syslinux \
        syslinux-common \
        syslinux-utils \
        grub-pc-bin \
        grub-efi-amd64-bin \
        grub-common \
        mtools \
        dosfstools \
        e2fsprogs \
        rsync \
        ca-certificates \
        curl \
        wget \
        gnupg \
        file \
        procps \
        sudo \
        librsvg2-bin \
        imagemagick \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
ENTRYPOINT ["/bin/bash"]
