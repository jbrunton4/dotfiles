bold=$(tput bold)
normal=$(tput sgr0)
prevline='\e[1A'
clearline='\e[K'

preliminary=($(find ./install/ -type f -name "*.sh"))
before=($(find ./before/ -type f -name "*.sh"))
install=($(find ./install/ -type f -name "*.sh"))
after=($(find ./after/ -type f -name "*.sh"))
all=("${preliminary[@]}" "${before[@]}" "${install[@]}" "${after[@]}")

for script in "${all[@]}"; do
    clear
    echo ""
    echo "             ／＞　 フ"
    echo "            |   | | |     ${script}"
    echo "          ／\` ミ＿•ノ"
    echo "         /　　　　 |"
    echo "        /　 ヽ　　 ﾉ         》★/)＿/)★"
    echo "        │　　|　|　|          ／(๑^᎑^๑)っ ＼~♥︎"
    echo "    ／￣|　　 |　|　|       ／|￣∪￣ ￣ |＼／"
    echo "    (￣ヽ＿  _ヽ_)__)        |＿＿_＿＿|／"
    echo "    ＼二)"
    sleep 0.1
    /bin/bash $script > /dev/null 2>&1
done

clear
tmux > /dev/null 2>&1
tmux kill-session -a > /dev/null 2>&1
eval "$(oh-my-posh init bash)" > /dev/null 2>&1

neofetch
echo "/ᐠ. ｡.ᐟ\\ ${bold}All done!${normal}ˎˊ˗ ✩₊˚.⋆☾⋆⁺₊✧"
echo ""
echo "===REMINDERS==="
echo "* Clone your neovim config into ~/.config/nvim"
echo "* Clone your tmux config into ~/.tmux.conf"
echo "* Install a nerd font for OMP to work correctly"
echo ""