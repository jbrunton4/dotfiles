if [ ! -f "$HOME/.brunt-dotfiles/config/projects_directory" ]; then 
    exit 1;
fi

projects_directory="$(cat $HOME/.brunt-dotfiles/config/projects_directory)"
if [ -z $projects_directory ]; then 
    exit 1;
fi

if [[ $(jq -r '.installGithubRepos' $HOME/.brunt-dotfiles/config/install.json) == "true" ]]; then
    repos=$(curl -s "https://api.github.com/users/jbrunton4/repos" | jq -r '.[] | .name')
    for repo in $repos
    do
        git clone "https://github.com/jbrunton4/$repo" "${projects_directory}/${repo}" 
    done
fi