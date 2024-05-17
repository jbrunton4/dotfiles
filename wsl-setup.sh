echo "Configure password for root user"
passwd
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
echo "New sudo user name:"
read new_user_name
useradd -m -G wheel -s /bin/bash $new_user_name
passwd $new_user_name
yes "" | sudo pacman-key --init && sudo pacman-key --populate && sudo pacman -Sy archlinux-keyring && sudo pacman -Su
curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/setup/setup-remote.sh | sh