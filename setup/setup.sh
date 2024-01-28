bold=$(tput bold)
normal=$(tput sgr0)
prevline='\e[1A'
clearline='\e[K'

github_logo=""
user_logo=""
version_logo=""

logs_dir="$HOME/.brunt-dotfiles/logs"
mkdir -p $logs_dir
logs_file="$logs_dir/$(date +%s).log"
touch $logs_file

preliminary=($(find ./install/ -type f -name "*.sh"))
before=($(find ./before/ -type f -name "*.sh"))
install=($(find ./install/ -type f -name "*.sh"))
after=($(find ./after/ -type f -name "*.sh"))
all=("${preliminary[@]}" "${before[@]}" "${install[@]}" "${after[@]}")

for script in "${all[@]}"; do
    clear
    echo "
             ／＞　 フ
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

echo "
╭━━╮╱╭╮╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭╮
┃━━╋━┫╰┳┳┳━╮╭━┳━┳━━┳━┳╮╭━┫╰┳━╮      [$github_logo  Github]
┣━━┃┻┫╭┫┃┃╋┃┃━┫╋┃┃┃┃╋┃╰┫┻┫╭┫┻┫      [$user_logo  jbrunton4]
╰━━┻━┻━┻━┫╭╯╰━┻━┻┻┻┫╭┻━┻━┻━┻━╯      [$version_logo  Unversioned]
╱╱╱╱╱╱╱╱╱╰╯╱╱╱╱╱╱╱╱╰╯" | lolcat 

echo ""
echo "${bold}===REMINDERS=== ˎˊ˗ ✩₊˚.⋆☾⋆⁺₊✧${normal}"
echo "* Install a nerd font for OMP to work correctly"
echo "* Your old config has been backed up in $HOME/.brunt-dotfiles"
echo ""