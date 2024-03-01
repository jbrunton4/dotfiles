use super::super::command_handler::*;

pub fn install_pips() {

    let pips = [ "speedtest-cli", "pyinstaller" ];

    for item in pips {
        run_command(format!("python3 -m pip install {}", item));
    }
}
