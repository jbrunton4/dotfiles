#!/bin/bash

scripts_dir="$HOME/.brunt-dotfiles/scripts"
config_dir="$HOME/.brunt-dotfiles/config"

mkdir -p "$scripts_dir"
mkdir -p "$config_dir"

curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/scripts/open_visual_studio_pro_22.sh > "${scripts_dir}/open_visual_studio_pro_22.sh"
curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/scripts/open_work_project.sh > "${scripts_dir}/open_work_project.sh"

if [ $(jq '.profile' $HOME/.brunt-dotfiles/config/install.json) -eq "home" ]; then
    curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/scripts/lolcat_block.sh > "${scripts_dir}/lolcat_block.sh"

fi

config_files=(
    "projects_directory"
    "visual_studio_install_location"
)
for file in "${config_files[@]}"
do
    [ ! -f "${config_dir}/${file}" ] && touch "${config_dir}/${file}"
done

chmod +x "$scripts_dir/*"