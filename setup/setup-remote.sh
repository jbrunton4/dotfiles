initial_dir="$(pwd)"
repo_dir="dotfiles-$(date +%s)"
git clone "https://github.com/jbrunton4/dotfiles" "${repo_dir}"
cd $repo_dir/setup
sudo /bin/bash ./setup.sh
cd $initial_dir
rm -rf $repo_dir