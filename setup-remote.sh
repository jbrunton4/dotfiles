#!/bin/bash

dpkg --configure -a

apt update
apt upgrade
apt install -y git libssl-dev curl build-essential pkg-config

if [ ! -f $HOME/.cargo/bin/cargo ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if cargo install --list | -grep -q "sccache"; then
	echo "Crate 'sccache' is already installed, skipping..."
else
	$HOME/.cargo/bin/cargo install sccache
fi

repo_dir="dotfiles-$(date +%s)"
git clone "https://github.com/jbrunton4/dotfiles" "${repo_dir}"

rm -r $HOME/.config/nvim
cp -r "${repo_dir}/userhome/.config/nvim" $HOME/.config/nvim

cargo run --jobs 1 --manifest-path "$repo_dir/installer/Cargo.toml"

rm -rf $repo_dir
