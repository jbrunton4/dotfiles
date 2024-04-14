if [ ! -f $HOME/.brunt-dotfiles/config/backup.gitconfig ]; then 
    cat $HOME/.gitignore > $HOME/.brunt-dotfiles/config/backup.gitconfig
fi