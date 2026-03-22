# https://github.com/openwrt/buildbot/blob/master/docker/buildworker/Dockerfile

FROM	debian:11
MAINTAINER	Entware team

ARG	DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && \
    apt-get install -y \
	build-essential \
	ccache \
	clang \
	curl \
	gawk \
	g++-multilib \
	gcc-multilib \
	genisoimage \
	git-core \
	gosu \
	libdw-dev \
	libelf-dev \
	libncurses5-dev \
	libssl-dev \
	locales \
	mc \
    procps \
    pv \
	pwgen \
	python \
	python3 \
	python3-venv \
	python3-pip \
	python3-pyelftools \
	python3-cryptography \
	qemu-utils \
	rsync \
	signify-openbsd \
	subversion \
	sudo \
	swig \
	unzip \
	wget \
	zstd \
    vim \
    binutils-arm-linux-gnueabihf \
    pkg-config \
    texinfo \
    build-essential gcc g++ binutils make \
    libncurses5-dev zlib1g-dev gawk flex bison gettext \
    libssl-dev swig libelf-dev python3 python3-distutils \
    git wget rsync unzip file quilt patch \
    xsltproc libxml-parser-perl && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash - && \
    apt-get update && apt-get install -y nodejs && \
    apt-get clean && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN pip3 install -U pip
RUN pip3 install \
	pyelftools \
	pyOpenSSL \
	service_identity

RUN npm install -g @github/copilot
RUN npm install -g @google/gemini-cli

ENV LANG=en_US.utf8

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -c "OpenWrt Builder" -m -d /home/appuser -G sudo -s /bin/bash appuser
COPY install-agent-tools.sh /usr/local/bin/install-agent-tools.sh
RUN chmod 0755 /usr/local/bin/install-agent-tools.sh

USER appuser
WORKDIR /home/appuser
ENV HOME /home/appuser
ENV PATH /home/appuser/.cargo/bin:/home/appuser/.local/bin:${PATH}

RUN /usr/local/bin/install-agent-tools.sh
RUN sudo rm /usr/local/bin/install-agent-tools.sh

#ENTRYPOINT /bin/bash
