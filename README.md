# jbrunton4/dotfiles

## Installation & Usage
To apply this configuration on your system, it is recommended to use cURL: 
```bash
curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/setup/setup-remote.sh | sudo /bin/bash /dev/stdin
```

Alternatively, if you're feeling lazy: 
```bash
curl -L joshbrunton.dev/i | bash
```

If you want to host an endpoint to this file, you should read the content at the URL and return it with the `content-type: text/plain`. This is mostly in case I forget. 
```python
@app.route("/i")
def i():
  return flask.Response(requests.get("https://raw.githubusercontent.com/jbrunton4/dotfiles/main/setup/setup-remote.sh").text, content_type='text/plain')
```

Before running, a backup of any files that are likely to be edited is created in `~/.brunt-dotfiles/backup/latest`. This folder also contains previous backups, organised by time generated. As there is [not yet an uninstall/restore feature](https://github.com/jbrunton4/dotfiles/issues/5), backups must be restored manually if desired. 

Logs are output to the alphabetical last file in `~/.brunt-dotfiles/logs`. Should the script be allowed to run to completion, the latest logs are copied into `~/.brunt-dotfiles/logs/latest.log`. 

## Dependencies
Most functionality is dependent on the apt package manager.

It is **recommended** to use a nerd font, so that programs such as [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) and [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) can display correctly. [FiraCode Nerd Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Regular) is a great option to use and guaranteed to work with this configuration. 

## Acknowledgements
Thanks to everyone whose open-source code fuels this configuration. Links lead to [github.com](https://github.com/) unless otherwise stated. 

- **Operating Systems & Virtual Machines**
    - [ubuntu/WSL](https://github.com/ubuntu/WSL)
    - Ubuntu Linux ([ubuntu.com](http://archive.ubuntu.com/ubuntu/))
    - Kali Linux ([gitlab.com](https://gitlab.com/kalilinux))
- **CLI Tools**
    - [AlDanial/cloc](https://github.com/AlDanial/cloc)
    - [aristocratos/bashtop](https://github.com/aristocratos/bashtop)
    - [atuinsh/atuin](https://github.com/atuinsh/atuin)
    - [bootandy/dust](https://github.com/bootandy/dust)
    - [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
    - [busyloop/lolcat](https://github.com/busyloop/lolcat)
    - [cli/cli](https://github.com/cli/cli)
    - [dylanaraps/neofetch](https://github.com/dylanaraps/neofetch)
    - [eza-community/eza](https://github.com/eza-community/eza)
    - [git/git](https://github.com/git/git)
    - [JanDeDobbeleer/oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)
    - [jbrunton4/git-back](https://github.com/jbrunton4/git-back) ([me](https://pbs.twimg.com/media/D90nHuOXkAAGxtJ.jpg:large))
    - [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit)
    - [junegunn/fzf](https://github.com/junegunn/fzf)
    - [LunarVim/LunarVim](https://github.com/LunarVim/LunarVim) (based on [neovim/neovim](https://github.com/neovim/neovim)), and associated plugins: 
        - [andweeb/presence.nvim](https://github.com/andweeb/presence)
        - [catppuccin/nvim](https://github.com/MunifTanjim/nui.nvim)
        - [lewis6991/gitsigns.nvim"](https://github.com/lewis6991/gitsigns.nvim")
        - [tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
    - [mozilla/sccache](https://github.com/mozilla/sccache)
    - [newsboat/newsboat](https://github.com/newsboat/newsboat)
    - [nmap/nmap](https://github.com/nmap/nmap)
    - [nvbn/thefuck](https://github.com/nvbn/thefuck)
    - [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
    - [scop/bash-completion](https://github.com/scop/bash-completion)
    - [sharkdp/bat](https://github.com/sharkdp/bat)
    - [sivel/speedtest-cli](https://github.com/sivel/speedtest-cli)
    - [TizenTeam/dos2unix](https://github.com/TizenTeam/dos2unix)
    - [TheZoraiz/ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter)
    - [tmux/tmux](https://github.com/tmux/tmux) and associated plugins:
        - [catppuccin/tmux](https://github.com/catppuccin/tmux)
        - [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
- **GUI Software**
    - GIMP ([gimp.org](https://www.gimp.org/source/))
    - [gitextensions/gitextensions](https://github.com/gitextensions/gitextensions)
    - Mozilla Firefox ([mozilla.org](https://www.mozilla.org/firefox/))
    - [microsoft/vscode](https://github.com/microsoft/vscode)
    - [postmanlabs/postman-runtime](https://github.com/postmanlabs/postman-runtime)
    - [qbittorrent/qBittorrent](https://github.com/qbittorrent/qBittorrent)
- **Other Tools**
    - [microsoft/dotnet](https://github.com/microsoft/dotnet)
    - [python/cpython](https://github.com/python/cpython)
    - [rust-lang/rust](https://github.com/rust-lang/rust) and its package manager [rust-lang/cargo](https://github.com/rust-lang/cargo)

Further thanks to Quad9 DNS service ([quad9.net](https://www.quad9.net)), which by nature does not fit under the definition of open-source code, but is still used in this configuration and worthy of recognition. 

## License
MIT License

Copyright (c) 2024 Joshua Brunton

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
