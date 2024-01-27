apt install neofetch

if grep -q "neofetch" ~/.bashrc
then
    : # pass
else
    echo "" >> ~/.bashrc
    echo "# neofetch" >> ~/.bashrc
    echo "neofetch" >> ~/.bashrc
fi