apt install ffmpeg

if grep -q "alias ffmpeg='ffmpreg'" ~/.bash_aliases
then
    : # pass
else
    echo "alias ffmpeg='ffmpreg'" >> ~/.bash_aliases
fi