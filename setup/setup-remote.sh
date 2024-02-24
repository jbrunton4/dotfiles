#!/bin/bash

# update and create a quick alias for this script
refresh_script_path="/usr/bin/dotfiles-refresh"
curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/setup/setup-remote.sh > $refresh_script_path
chmod +x $refresh_script_path

# apply installation
initial_dir="$(pwd)"
repo_dir="dotfiles-$(date +%s)"
git clone "https://github.com/jbrunton4/dotfiles" "${repo_dir}"
cd $repo_dir/setup
sudo /bin/bash ./setup.sh
cd $initial_dir
rm -rf $repo_dir