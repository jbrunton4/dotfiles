use std::process::{ChildStdout, Command, Stdio};

pub fn install_nvim() {
    // first, plain nvim install
    let _ = Command::new("pacman")
        .args(&["-Syu", "neovim"])
        .stdin(get_yes())
        .output()
        .expect("Failed to start `pacman`");

    // npm is required to install pyright
    let _ = Command::new("pacman")
        .args(&["-Syu", "npm"])
        .stdin(get_yes())
        .output()
        .expect("Failed to start `pacman`");

    // install pyright for LSP support in nvim
    let _ = Command::new("npm")
        .args(&["install", "pyright"])
        .stdin(get_yes())
        .output()
        .expect("Failed to start `pacman`");
}

fn get_yes() -> ChildStdout {
    return Command::new("yes")
        .args(&["\"\""])
        .stdout(Stdio::piped())
        .spawn()
        .expect("Failed to start `yes` command")
        .stdout
        .unwrap();
}
