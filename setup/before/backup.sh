backup_filepath="$HOME/.brunt-dotfiles/backup"
mkdir -p "$backup_filepath"

if [ -d "$backup_filepath/.git" ]
then
    : # pass
else
    git init "$backup_filepath"
    git -C "$backup_filepath" add --all
    git -C "$backup_filepath" commit -m "$(date +%s%N)"
fi

find "$backup_filepath" -mindepth 1 ! -path "$backup_filepath/.git*" -delete

cp -r "$HOME/.config/nvim" "$backup_filepath/nvim"
cp -r "$HOME/.config/neofetch" "$backup_filepath/neofetch" 
cp -r "$HOME/.tmux.conf" "$backup_filepath/tmux/.tmux.conf"
cp -r "$HOME/.bashrc" "$backup_filepath/bash/.bashrc"
cp -r "$HOME/.bash_aliases" "$backup_filepath/bash/.bash_aliases"
cp -r "$HOME/.config/newsboat/urls" "$backup_filepath/newsboat/urls"
cp -r "$HOME/git/.gitconfig" "$backup_filepath/git/.gitconfig"

git -C "$backup_filepath" add --all
git -C "$backup_filepath" commit -m "$(date +%s%N)"
git -C "$backup_filepath" gc