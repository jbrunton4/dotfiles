snap install newsboat 

newsboat_dir="$HOME/snap/newsboat/7339/.newsboat"
mkdir -p $newsboat_dir
touch $newsboat_dir/urls
curl https://raw.githubusercontent.com/jbrunton4/dotfiles/main/newsboat/urls > $newsboat_dir/urls