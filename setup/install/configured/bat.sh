apt install bat

if grep -q "alias batcat='cat'" ~/.bash_aliases
then
    : # pass
else
    echo "alias batcat='cat'" >> ~/.bash_aliases
fi