backup_filepath="$HOME/.brunt-dotfiles/backup/$(date +%s%N)"
mkdir -p $backup_filepath

cp -r "$HOME/.config/nvim" "$backup_filepath/nvim"
cp -r "$HOME/.config/neofetch" "$backup_filepath/neofetch" 

cp -r "$HOME/.tmux.conf" "$backup_filepath/.tmux.conf"
cp -r "$HOME/.bashrc" "$backup_filepath/.bashrc"

cp -r "$HOME/.config/newsboat/urls" "$backup_filepath/newsboat/urls"