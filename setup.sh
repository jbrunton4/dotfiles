bold=$(tput bold)
normal=$(tput sgr0)
prevline='\e[1A'
clearline='\e[K'

check_requirements(){
    clear
    echo "/ᐠ. .ᐟ\\ฅ Hi!"
    sleep 2
    
    if command -v apt-get &>/dev/null
    then
        : # pass
    else
        echo "This script requires apt"
        exit 1
    fi
}

apt_update() {
    apt-get update > /dev/null 2>&1
}

install_brew(){
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)" > /dev/null 2>&1 &
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" > /dev/null 2>&1
    if grep -q $(brew --prefix) ~/.bashrc
    then
        : # pass
    else
        echo "" >> ~/.bashrc
        echo "# Brew" >> ~/.bashrc
        echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
    fi
}

install_dotnet7() {
    apt install dotnet7 > /dev/null 2>&1
}

install_tmux(){
    apt-get install tmux > /dev/null 2>&1
}

config_tmux(){
    if grep -q "tmux kill-session -a" ~/.bashrc
    then
        : # pass
    else
        echo "" >> ~/.bashrc
        echo "# tmux" >> ~/.bashrc
        echo "tmux" >> ~/.bashrc
        echo "tmux kill-session -a" >> ~/.bashrc
    fi
}

install_nvim(){
    yes | add-apt-repository ppa:neovim-ppa/unstable > /dev/null 2>&1
    yes | apt-get install neovim > /dev/null 2>&1
}

install_oh_my_posh(){
    brew install jandedobbeleer/oh-my-posh/oh-my-posh > /dev/null 2>&1
    brew update && brew upgrade oh-my-posh > /dev/null 2>&1
}

config_oh_my_posh(){
    if grep -q "oh-my-posh init bash --config" ~/.bashrc
    then
        : # pass
    else
        echo "" >> ~/.bashrc
        echo "# oh-my-posh" >> ~/.bashrc
        echo "eval \"\$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_frappe.omp.json')\"" >> ~/.bashrc
    fi
}

install_neofetch(){
    apt install neofetch > /dev/null 2>&1
}

install_tree() {
    apt install tree > /dev/null 2>&1
}

install_lazygit() {
    apt install lazygit > /dev/null 2>&1
}

install_bash_completion(){
    apt install bash-completion > /dev/null 2>&1
}

config_bash_completion(){
    if grep -q "bash_completion" ~/.bashrc
    then
        : # pass
    else
        echo "" >> ~/.bashrc
        echo "# bash-completion" >> ~/.bashrc
        echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc
    fi
}

install_cloc(){
    apt install cloc > /dev/null 2>&1
}

config_neofetch(){
    if grep -q "neofetch" ~/.bashrc
    then
        : # pass
    else
        echo "" >> ~/.bashrc
        echo "# neofetch" >> ~/.bashrc
        echo "neofetch" >> ~/.bashrc
    fi
}

install_thefuck(){
    brew install thefuck > /dev/null 2>&1 # generic linux install
    
    : 'Ubuntu/mint specific install
    apt install python3-dev python3-pip python3-setuptools
    pip3 install thefuck --user'
}

config_thefuck(){
    if grep -q "eval \$(thefuck --alias" ~/.bashrc
    then
        : # pass
    else
        echo "" >> ~/.bashrc
        echo "# the fuck" >> ~/.bashrc
        echo "eval \$(thefuck --alias)" >> ~/.bashrc
        echo "eval \$(thefuck --alias fuck)" >> ~/.bashrc
        echo "eval \$(thefuck --alias FUCK)" >> ~/.bashrc
    fi
}

finish(){
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
}


back_up_files() {
    function_list=(
        # do things here
    )
    
    for func in "${function_list[@]}"
    do
        clear
        echo "Backing up your files"
        echo "〃∩ ∧＿∧ ♡       "
        echo "⊂⌒（ '·ω·）♡     "
        echo "｀ヽ_っ＿/￣￣￣/"
        echo "　  　 ＼/＿＿＿/"
        $func
        sleep 0.1
    done
}

manage_package_managers() {
    function_list=(
        "apt_update"
        "install_brew"
    )
    
    for func in "${function_list[@]}"
    do
        clear
        echo "Managing package managers"
        echo ""
        echo "             ／＞　 フ"
        echo "            |   | | |     ${func}"
        echo "          ／\` ミ＿•ノ"
        echo "         /　　　　 |"
        echo "        /　 ヽ　　 ﾉ         》★/)＿/)★"
        echo "        │　　|　|　|          ／(๑^᎑^๑)っ ＼~♥︎"
        echo "    ／￣|　　 |　|　|       ／|￣∪￣ ￣ |＼／"
        echo "    (￣ヽ＿  _ヽ_)__)        |＿＿_＿＿|／"
        echo "    ＼二)"
        $func
        sleep 0.1
    done
}

install_software() {
    function_list=(
        "install_nvim"
        "install_thefuck"
        "install_dotnet7" # (requirement for some Mason LSPs in nvim)
        "install_neofetch"
        "install_oh_my_posh"
        "install_tmux"
        "install_tree" 
        "install_lazygit"
        "install_bash_completion"
        "install_cloc"
    )
    
    for func in "${function_list[@]}"
    do
        clear
        echo "Installing software"
        echo " ╱|、"
        echo "(˚ˎ 。7  ${func}"
        echo " |、˜〵   "
        echo "じしˍ,)ノ"
        $func
        sleep 0.1
    done
}

config_software() {
    function_list=(
        "config_thefuck"
        "config_neofetch"
        "config_oh_my_posh"
        "config_tmux"
        "config_bash_completion"
    )
    
    for func in "${function_list[@]}"
    do
        clear
        echo "Configuring software"
        echo " /\___/\\"
        echo "꒰˶•༝-˶꒱   ${func}"
        echo "./づ~🍨"
        $func
        sleep 0.1
    done
}

final_cleanup(){
    apt autoremove > /dev/null 2>&1 
}

function_list=(
    "check_requirements"
    "back_up_files"
    "manage_package_managers"
    "install_software"
    "config_software"
    "final_cleanup"
    "finish"
)

for func in "${function_list[@]}"
do
    yes | $func
    sleep 5
done
