use super::super::command_handler::*;

pub fn install_crates() {

    // we ensure sccache first to skip re-compiling shared dependencies
    run_command("cargo install sccache".to_string());

    let crates = [ "du-dust", "atuin" ];

    for item in crates {
        run_command(format!("cargo install {}", item));
    }

}
