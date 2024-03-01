use super::super::command_handler::*;

pub fn install_snaps() {
    let snaps = [ 
        "ascii-image-converter", 
        "lazygit", 
        "lolcat", 
        "code" 
    ];

    for item in snaps {
        run_command(format!("snap install {}", item));
    }

}
