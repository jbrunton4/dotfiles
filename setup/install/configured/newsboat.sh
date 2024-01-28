snap install newsboat 

mkdir -p $HOME/.config/newsboat
touch $HOME/.config/newsboat/urls
curl https://raw.githubusercontent.com/jbrunton4/dotfiles/main/newsboat/urls > $HOME/.config/newsboat/urls