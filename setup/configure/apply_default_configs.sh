files=(
    "logs.json"
    "install.json"
)

for file in "${files[@]}"; do
    filepath="$HOME/.brunt-dotfiles/config/$file"
    if [ ! -f $filepath ]; then
        curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/config_defaults/$file > $filepath
    fi
done