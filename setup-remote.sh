#!/bin/bash

rm -r $HOME/.brunt-dotfiles/temp
rm -r $HOME/.brunt-dotfiles/repo

dpkg --configure -a

yes "" | sudo pacman -S git curl base-devel

if [ ! -f $HOME/.cargo/bin/cargo ]; then
	yes "" | curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	yes "" | sudo pacman -S cargo
fi

yes "y" | sudo pacman -S rustup

repo_dir="dotfiles-$(date +%s)"
git clone "https://github.com/jbrunton4/dotfiles" "${repo_dir}"

rm -r $HOME/.config/nvim
cp -r "${repo_dir}/userhome/.config/nvim" $HOME/.config/nvim

cargo run --jobs 1 --manifest-path "$repo_dir/installer/Cargo.toml"

rm -rf $repo_dir
rm -rf $HOME/.brunt-dotfiles/repo/.git
rm -rf $HOME/.brunt-dotfiles/repo/installer
