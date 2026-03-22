#!/usr/bin/env bash

set -euo pipefail

sudo apt update

libev_pkg=libev4
if apt-cache show libev4t64 >/dev/null 2>&1; then
  libev_pkg=libev4t64
fi

packages=(build-essential curl git pkg-config)
optional_packages=(shellcheck hyperfine "$libev_pkg")

for package in "${optional_packages[@]}"; do
  if apt-cache show "$package" >/dev/null 2>&1; then
    packages+=("$package")
  fi
done

sudo apt install -y "${packages[@]}"

# Rust
if ! command -v cargo >/dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  # shellcheck disable=SC1091
  source "$HOME/.cargo/env"
else
  rustup update
fi

# cargo-based tools
cargo install ast-grep difftastic sd hyperfine watchexec-cli git-delta

# scc
latest=$(curl -s https://api.github.com/repos/boyter/scc/releases/latest \
  | grep browser_download_url \
  | grep -i Linux_x86_64.tar.gz \
  | cut -d '"' -f 4)
curl -L "$latest" -o scc.tar.gz
tar xzf scc.tar.gz
sudo mv scc /usr/local/bin/
rm scc.tar.gz

# yq
YQ_BIN=yq_linux_amd64
curl -L "https://github.com/mikefarah/yq/releases/latest/download/${YQ_BIN}.tar.gz" -o yq.tar.gz
tar xzf yq.tar.gz
sudo mv yq_linux_amd64 /usr/local/bin/yq
sudo chmod +x /usr/local/bin/yq
rm yq.tar.gz

# comby
if ! dpkg -s libpcre3 >/dev/null 2>&1; then
  curl -sLO http://ftp.us.debian.org/debian/pool/main/p/pcre3/libpcre3_8.39-15_amd64.deb
  sudo dpkg -i libpcre3_8.39-15_amd64.deb
  rm libpcre3_8.39-15_amd64.deb
fi
curl -sL get.comby.dev | bash
