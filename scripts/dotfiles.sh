if [[ "$1" == "refresh" ]]; then 
    dotfiles-refresh
fi

if [[ $1 == "commands" ]]; then 
    ls -1 "$HOME/.brunt-dotfiles/bin"
fi

if  [[ $1 == "--help" ]] || [[ $1 == "-h" ]] || [[ $1 == "-?" ]] || [[ $1 == "help" ]] ; then 
    echo "Usage: dotfiles [refresh|commands|help]"
fi