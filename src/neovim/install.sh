#!/usr/bin/env bash

set -e

source ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer nanolayer_location "v0.5.6"

$nanolayer_location \
	install \
	devcontainer-feature \
	"ghcr.io/devcontainers-contrib/features/apt-get-packages:1.0.4" \
	--option packages='curl,ca-certificates'

NVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
if [[ $(uname -m) == "x86_64" ]]; then
	curl -Lo nvim.tar.gz "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
elif [[ $(uname -m) == "aarch64" ]]; then
	curl -Lo nvim.tar.gz "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-arm64.tar.gz"
else
	echo "Unsupported architecture"
	exit 1
fi

tar xf nvim.tar.gz
cd nvim-linux*
cp -r * /usr/local
