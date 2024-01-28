bold=$(tput bold)
normal=$(tput sgr0)
prevline='\e[1A'
clearline='\e[K'

github_logo=""
repo_logo=""
version_logo=""

logs_dir="$HOME/.brunt-dotfiles/logs"
mkdir -p $logs_dir
logs_file="$logs_dir/$(date +%s).log"
touch $logs_file

preliminary=($(find ./preliminary/ -type f -name "*.sh"))
before=($(find ./before/ -type f -name "*.sh"))
install=($(find ./install/ -type f -name "*.sh"))
after=($(find ./after/ -type f -name "*.sh"))
all=("${preliminary[@]}" "${before[@]}" "${install[@]}" "${after[@]}")

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

    echo -e "\n\n===== $script =====" >> $logs_file
    yes | /bin/bash $script >> $logs_file 2>&1
done

cp -f $logs_file "$logs_dir/latest.log"

source $HOME/.bashrc
clear

github_link="\e]8;;https://github.com\aGithub\e]8;;\a"
repo_link="\e]8;;https://github.com/jbrunton4/dotfiles\ajbrunton4/dotfiles\e]8;;\a"
version_link="\e]8;;https://example.com\aUnversioned\e]8;;\a"
echo -e "
╭━━╮╱╭╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╮ ˎˊ˗ ✩₊˚.⋆☾⋆⁺₊✧
┃━━╋━┫╰┳┳┳━╮╭━┳━┳━━┳━┳╮╭━┫╰┳━╮      [ $github_logo  ${bold}${github_link}${normal} ]
┣━━┃┻┫╭┫┃┃╋┃┃━┫╋┃┃┃┃╋┃╰┫┻┫╭┫┻┫      [ $repo_logo  ${bold}${repo_link}${normal} ]
╰━━┻━┻━┻━┫╭╯╰━┻━┻┻┻┫╭┻━┻━┻━┻━╯      [ $version_logo  ${bold}${version_link}${normal} ]
╱╱╱╱╱╱╱╱╱╰╯╱╱╱╱╱╱╱╱╰╯
" | lolcat -a --duration=1 --seed=100