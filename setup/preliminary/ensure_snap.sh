if command -v snap &>/dev/null
then
    : # pass
else
    echo "The installation process requires snap. Please run in an environment where snap is available."
    exit 1
fi