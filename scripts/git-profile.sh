# git config profiles

profiles_folder="$HOME/.brunt-dotfiles/data/git-profiles"
mkdir -p "${profiles_folder}"

# ensure we're not about to discard the current configuration
current_config_stored=false
for filename in ${profiles_folder}/**/*.gitconfig; do
	cmp --silent "$HOME/.gitconfig" $filename && current_config_stored=true
done

if [ $current_config_stored = false ]; then
	filename="$(git config --get user.name) - $(git config --get user.email)"
	filename=$(echo "$filename" | sed "s/\s//g")
	if [ -f "${profiles_folder}/${filename}" ]; then
		old_filename="$filename"
		filename="${filename}-$(date +'%Y-%m-%dT%T')"
	fi

	backups_path="${profiles_folder}/auto-backup"
	mkdir -p "${backups_path}"
	cp $HOME/.gitconfig "${backups_path}/${filename}.gitconfig"
fi

# select a profile
selected_profile=$(find "${profiles_folder}" -type f -name *.gitconfig | fzf --preview="cat {}" --keep-right -1)

# apply the profile
if [ ! -z "${selected_profile}" ]; then
	cat "${selected_profile}" >$HOME/.gitconfig
	echo "Applied profile: $(git config --get user.name)<$(git config --get user.email)>"
fi
