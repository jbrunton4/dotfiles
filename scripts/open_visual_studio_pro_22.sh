#!/bin/bash

# preliminary checks
if [ ! -f /etc/wsl.conf ]
then
    echo "Fatal: Not in WSL"
    echo "This command is intended for use in the Windows Subsystem for Linux virtual machine to interact with a Windows installation of Visual Studio Professional 2022"
    exit 1
fi

# find the visual studio installation (we cache because it takes some time)
installation_path_cache_file="$HOME/.brunt-dotfiles/config/visual_studio_install_location"
devenv_path=$(cat "$installation_path_cache_file")
if [ -z "$devenv_path" ]; then
    default_install_dir="/mnt/c/Program Files/Microsoft Visual Studio/2022/Professional/Common7/IDE"
    
    if [ ! -d "$default_install_dir" ]; then
        echo "Fatal: Could not find the installation folder for Visual Studio 2022 Professional."
        echo "Please specify in $installation_path_cache_file"
        exit 1
    fi
    
    devenv_path=$(find "$default_install_dir" -name devenv.exe -type f -print -quit)
    if [ ! -n "$devenv_path" ]; then
        echo "Fatal: Could not find devenv.exe in the installation folder for Visual Studio 2022 Professional."
        echo "Folder: $devenv_path"
        exit 1
    fi
    
    echo "$devenv_path" > "$installation_path_cache_file"
fi

# find .SLN files if not given
sln_file="$1"
if [ -z "$sln_file" ]; then
    depth=1
    max_depth=10
    while [ $depth -le $max_depth ]; do
        count=$(find . -maxdepth $depth -type f -name "*.sln" | wc -l)
        
        if [ $count -eq 0 ]; then
            ((depth++))
            continue
            elif [ $count -eq 1 ]; then
            sln_file=$(find . -type f -name "*.sln")
            break
        else
            sln_file=$(echo "$(find . -maxdepth $depth -type f -name "*.sln")" |
                fzf --info "hidden" \
                --header "Multiple viable candidates, did you mean:" \
                --header-first --reverse --keep-right
            )
            
            if [ ! -z "$sln_file" ]; then
                break
            fi
            
            exit 1
        fi
    done
fi

if [ -z "$sln_file" ]; then
    echo "Fatal: No files matching pattern \"*.sln\" found (searched with depth of ${max_depth})"
    exit 1
fi

"$devenv_path" "$sln_file" &