# jbrunton4/dotfiles

## Installation & Usage
To apply this configuration on your system, it is recommended to use cURL: 
```bash
curl -sSL https://raw.githubusercontent.com/jbrunton4/dotfiles/main/setup/setup-remote.sh | bash /dev/stdin
```

Before running, a backup of any files that are likely to be edited is created in `~/.brunt-dotfiles/backup/latest`. This folder also contains previous backups, organised by time generated. As there is [not yet an uninstall/restore feature](https://github.com/jbrunton4/dotfiles/issues/5), backups must be restored manually if desired. 

Logs are output to the alphabetical last file in `~/.brunt-dotfiles/logs`. Should the script be allowed to run to completion, the latest logs are copied into `~/.brunt-dotfiles/logs/latest.log`. 

## Dependencies
The ideal environment to run this installer is a debian-based linux distribution, as the strict requirements for installation are `apt` and `snap`. 

Any other dependency will be installed automatically - for example, [sivel/speedtest-cli](https://github.com/sivel/speedtest-cli) is installed via `python3`'s `pip` module, whose presence in the environment will be automatically ensured by the program. 

It is **recommended** to use a nerd font, so that programs such as [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) and [dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) can display correctly. [FiraCode Nerd Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Regular) is a great option to use and guaranteed to work with this configuration. 

## Uninstallation
The uninstall feature has not yet been implemented. See [the issue addressing this enhancement](https://github.com/jbrunton4/dotfiles/issues/5).

## Acknowledgements
Thanks to everyone whose open-source code fuels this configuration: 
- [AlDanial/cloc](https://github.com/AlDanial/cloc)
- [busyloop/lolcat](https://github.com/busyloop/lolcat)
- [cli/cli](https://github.com/cli/cli)
- [dylanaraps/neofetch](https://github.com/dylanaraps/neofetch)
- [eza-community/eza](https://github.com/eza-community/eza)
- [JanDeDobbeleer/oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)
- [jbrunton4/git-back](https://github.com/jbrunton4/git-back) ([me](https://pbs.twimg.com/media/D90nHuOXkAAGxtJ.jpg:large))
- [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit)
- [microsoft/dotnet](https://github.com/microsoft/dotnet) (.NET 7)
- [microsoft/vscode](https://github.com/microsoft/vscode)
- [neovim/neovim](https://github.com/neovim/neovim) as well as related plugins and dependencies: 
    - [3rd/image.nvim](https://github.com/3rd/image.nvim)
    - [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
    - [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)
    - [VonHeikemen/lsp-zero.nvim](https://github.com/VonHeikemen/lsp-zero.nvim)
    - [andweeb/presence.nvim](https://github.com/wbthomason/packer.nvim)
    - [catppuccin/nvim](https://github.com/catppuccin/nvim)
    - [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
    - [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    - [kdheepak/lazygit.nvim](kdheepak/lazygit.nvim)
    - [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    - [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
    - [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
    - [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
    - [nvimdev/dashboard-nvim](https://github.com/nvimdev/dashboard-nvim)
    - [ojroques/nvim-hardline](https://github.com/ojroques/nvim-hardline)
    - [wbthomason/packer.nvim](https://github.com/andweeb/presence.nvim)
    - [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
    - [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- [newsboat/newsboat](https://github.com/newsboat/newsboat)
- [nmap/nmap](https://github.com/nmap/nmap)
- [nvbn/thefuck](https://github.com/nvbn/thefuck)
- [python/cpython](https://github.com/python/cpython)
- [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
- [scop/bash-completion](https://github.com/scop/bash-completion)
- [sharkdp/bat](https://github.com/sharkdp/bat)
- [sivel/speedtest-cli](https://github.com/sivel/speedtest-cli)
- [TizenTeam/dos2unix](https://github.com/TizenTeam/dos2unix)
- [TheZoraiz/ascii-image-converter](https://github.com/TheZoraiz/ascii-image-converter)
- [tmux/tmux](https://github.com/tmux/tmux)

See also some other great open-source tools:
- [gitextensions/gitextensions](https://github.com/gitextensions/gitextensions)

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