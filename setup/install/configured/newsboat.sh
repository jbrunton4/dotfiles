
snap install newsboat 

newsboat_dir="$HOME/snap/newsboat/7339/.newsboat"
mkdir -p $newsboat_dir
touch $newsboat_dir/urls

curl https://raw.githubusercontent.com/jbrunton4/dotfiles/main/newsboat/urls.json > ./urls.temp.json

echo "" > $newsboat_dir/urls
output=$(jq -r 'recurse(.[]?) | scalars' ./urls.temp.json)
for ((i=0; i<${#output[@]}; i++)); do    
    item="${output[i]}"
    echo -e "${item}\n" >> $newsboat_dir/urls
    echo -e "${item}\n"
done

rm -f ./urls.temp.json
