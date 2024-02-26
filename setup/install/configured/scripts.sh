#!/bin/bash

scripts_dir="$HOME/.brunt-dotfiles/scripts"
config_dir="$HOME/.brunt-dotfiles/config"

mkdir -p "$scripts_dir"
mkdir -p "$config_dir"

scripts=(
    "open_visual_studio_pro_22"
    "open_work_project"
)
if [ $(jq '.profile' $HOME/.brunt-dotfiles/config/install.json) -eq "\"home\"" ]; then
    scripts+=("lolcat_block")
fi

for script_name in "${scripts[@]}"
do
    curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/scripts/${script_name}.sh > "${scripts_dir}/${script_name}.sh"
done

config_files=(
    "projects_directory"
    "visual_studio_install_location"
)
for file in "${config_files[@]}"
do
    [ ! -f "${config_dir}/${file}" ] && touch "${config_dir}/${file}"
done

chmod +x "$scripts_dir/*"