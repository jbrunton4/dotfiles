#!/bin/bash

start=$(date +%s)

bold=$(tput bold)
normal=$(tput sgr0)
prevline='\e[1A'
clearline='\e[K'

github_logo=""
repo_logo=""
version_logo=""
github_link="\e]8;;https://github.com/jbrunton4\ajbrunton4\e]8;;\a"
repo_link="\e]8;;https://github.com/jbrunton4/dotfiles\adotfiles\e]8;;\a"
version=$(echo "$(git rev-parse HEAD)" | cut -c 1-7)
version_link="\e]8;;https://example.com\a${version}\e]8;;\a"

logs_dir="$HOME/.brunt-dotfiles/logs"
mkdir -p $logs_dir
timestamped_logs_file="$logs_dir/$(date +%s).log"
touch $timestamped_logs_file
logs_file="$HOME/.brunt-dotfiles/logs/latest.log"
echo -n > $logs_file

preliminary=($(find ./preliminary/ -type f -name "*.sh"))
before=($(find ./before/ -type f -name "*.sh"))
configure=($(find ./configure/ -type f -name "*.sh"))
install=($(find ./install/ -type f -name "*.sh"))
housekeeping=($(find ./housekeeping/ -type f -name "*.sh"))
after=($(find ./after/ -type f -name "*.sh"))
all=("${preliminary[@]}" "${before[@]}" "${configure[@]}" "${install[@]}" "${housekeeping[@]}" "${after[@]}")

for ((i=0; i<${#all[@]}; i++)); do
    script="${all[i]}"

    clear
    echo "
             ／＞　 フ    ${i}/${#all[@]}
            |   | | |     ${script}
          ／\` ミ＿•ノ
         /　　　　 |
        /　 ヽ　　 ﾉ         》★/)＿/)★
        │　　|　|　|          ／(๑^᎑^๑)っ ＼~♥︎
    ／￣|　　 |　|　|       ／|￣∪￣ ￣ |＼／
   (￣ヽ＿  _ヽ_)__)        |＿＿_＿＿|／
    ＼二)"
    sleep 0.1

    if [[ $1 == "-v" || $1 == "--verbose" ]]; then 
        echo -e "\n\n===== $script ====="
        yes | /bin/bash $script
    else
        echo -e "\n\n===== $script =====" >> $logs_file
        yes | /bin/bash $script >> $logs_file 2>&1
    fi
done

cp -f $logs_file $timestamped_logs_file

source $HOME/.bashrc
clear

time=$(($(date +%s) - $start))
message="
╭━━╮╱╭╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╮ ˎˊ˗ ✩₊˚.⋆☾⋆⁺₊✧\n
┃━━╋━┫╰┳┳┳━╮╭━┳━┳━━┳━┳╮╭━┫╰┳━╮      [ $github_logo  ${bold}${github_link}${normal} ]\n
┣━━┃┻┫╭┫┃┃╋┃┃━┫╋┃┃┃┃╋┃╰┫┻┫╭┫┻┫      [ $repo_logo  ${bold}${repo_link}${normal} ]\n
╰━━┻━┻━┻━┫╭╯╰━┻━┻┻┻┫╭┻━┻━┻━┻━╯      [ $version_logo  ${bold}${version_link}${normal} ]\n
╱╱╱╱╱╱╱╱╱╰╯╱╱╱╱╱╱╱╱╰╯ ${time}s\n
" 

if command -v lolcat &> /dev/null
then
    echo -e $message | lolcat -a --duration=1 --seed=100
else
    echo -e $message
fi