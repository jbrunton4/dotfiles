#!/bin/bash

apt update 
apt upgrade
apt install git libssl-dev curl build-essential  

if [ ! -f $HOME/.cargo/bin/cargo ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

$HOME/.cargo/bin/cargo install sccache

initial_dir="$(pwd)"
repo_dir="dotfiles-$(date +%s)"
git clone "https://github.com/jbrunton4/dotfiles" "${repo_dir}"
cd $repo_dir/installer
$HOME/.cargo/bin/cargo run 
cd $initial_dir
rm -rf $repo_dir
