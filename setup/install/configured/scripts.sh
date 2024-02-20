scripts_dir="$HOME/.brunt-dotfiles/scripts"
config_dir="$HOME/.brunt-dotfiles/config"

mkdir -p "$scripts_dir"
mkdir -p "$config_dir"

cp -r ../../../scripts/* "${scripts_dir}"

config_files=(
    "projects_directory"
)
for file in "${config_files[@]}"
do
    [ -f "${config_dir}/${file}" ] && touch "${config_dir}/${file}"
done

chmod +x "$scripts_dir/*"