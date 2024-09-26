#!/bin/bash

scripts_dir="$HOME/.brunt-dotfiles/bin"
config_dir="$HOME/.brunt-dotfiles/config"

mkdir -p "$scripts_dir"
mkdir -p "$config_dir"

scripts=(
    "open_visual_studio_pro_22"
    "open_work_project"
    "lolcat_block"
    "dotfiles"
    "pspsps"
    "git-back"
    "unix"
    "git-find"
    "git-forget"
    "git-ignoretemplate"
)
if [[ $(jq -r '.profile' $HOME/.brunt-dotfiles/config/install.json) == "home" ]]; then
    scripts+=("lolcat_block")
fi

for script_name in "${scripts[@]}"
do
    curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/scripts/${script_name}.sh > "${scripts_dir}/${script_name}"
    chmod +x "${scripts_dir}/${script_name}"
done

config_files=(
    "projects_directory"
    "visual_studio_install_location"
)
for file in "${config_files[@]}"
do
    [ ! -f "${config_dir}/${file}" ] && touch "${config_dir}/${file}"
done
