curl -s https://ohmyposh.dev/install.sh | bash -s

if grep -q "oh-my-posh init bash --config" ~/.bashrc
then
    : # pass
else
    echo "" >> ~/.bashrc
    echo "# oh-my-posh" >> ~/.bashrc
    echo "eval \"\$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_frappe.omp.json')\"" >> ~/.bashrc
fi