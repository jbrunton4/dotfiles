use super::super::command_handler::*;

pub fn install_apts() {
    let apts = [ 
        "bash-completion",
        "bashtop",
        "bat",
        "cloc",
        "dos2unix",
        "dotnet7",
        "dotnet-sdk-8.0",
        "ffmpeg",
        "fzf",
        "git",
        "gh",
        "kdiff3",
        "neofetch",
        "nmap",
        "ripgrep",
        "tree"
    ];

    for item in apts {
        run_command(format!("apt install {}", item));
    }

}
