mkdir -p "$HOME/.brunt-dotfiles/config"
mkdir -p "$HOME/.brunt-dotfiles/scripts"

install_path="$HOME/.brunt-dotfiles/scripts/open_work_project.sh"
config_file="$HOME/.brunt-dotfiles/config/projects_directory"

if [ ! -f $config_file ]
then
    touch $config_file
fi

curl "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/scripts/open_work_project.sh" > $install_path
