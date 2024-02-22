filepath="$HOME/.brunt-dotfiles/config/logs.json"

if [ ! -f $filepath ]; then
    curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/config_defaults/logs.json > $filepath
fi