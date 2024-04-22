alias rn="mv"

alias ls="exa"
alias cat="batcat"
alias top="bashtop"
alias ripgrep="rg"
alias grep="rg"
alias nvim="lvim"
alias at="__atuin_history"
alias dos="wslpath -w"

alias rtfm="tail -n 1 $HOME/.bash_history | awk '{print $1}' | xargs man"
alias pyserver="python3 -m http.server -b 127.0.0.1 8080"

alias vsp="open_visual_studio_pro_22"

bind '"\C-o": "\C-usource $HOME/.brunt-dotfiles/bin/open_work_project\n"'
bind -x '"\C-r": source $HOME/.bashrc'
