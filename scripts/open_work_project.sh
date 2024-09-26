#!/bin/bash

# requires tree, fzf
root="$(cat $HOME/.brunt-dotfiles/config/projects_directory)"

# check that root is configured
if [[ -z $root ]]
then
    echo "# No directory configured - where are your projects?" > $HOME/.brunt-dotfiles/config/projects_directory
    $(git config --get core.editor) $HOME/.brunt-dotfiles/config/projects_directory
    root="$(cat $HOME/.brunt-dotfiles/config/projects_directory)"
fi

# check that the directory exists
if [ ! -d "$root" ]
then
    echo "Directory does not exist (${root})"
fi

# check that the directory has subdirectories
subdircount=$(find "${root}" -maxdepth 1 -type d | wc -l)
if [[ "$subdircount" -eq 1 ]]
then
    echo "Directory contains no subdirectories (${root})"
fi

# move
target=$(ls -d -a -1 "${root}/"**/ |
    awk -F "/" '{print $(NF-1) "/" $NF}' |
    fzf --preview "tree '$(dirname $root)/{}' -L 1" \
        --info "hidden" \
        --header "$root/" \
        --header-first \
        --reverse \
        --keep-right)
target=$(echo "$target" | awk '{sub(/^'"'"'/,""); sub(/'"'"'$/,""); print}') # strip quotes from fzf output

if [[ ! -z $target ]]
then
    target=$(basename $target)
    cd "${root}/${target}"
fi

