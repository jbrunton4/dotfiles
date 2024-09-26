use chrono::Local;
use git2::Repository;
use is_wsl::is_wsl;
use reqwest::blocking::Client;
use serde::{Deserialize, Serialize};
use std::fs::File;
use std::fs::OpenOptions;
use std::io::BufReader;
use std::io::{Read, Write};
use std::path::PathBuf;
use std::process::{Command, Stdio};
use std::time::Instant;
use std::{env, fs};

mod nvim;

#[derive(Debug, Deserialize)]
struct Commit {
    sha: String,
}

#[derive(Debug, Deserialize, Serialize)]
#[allow(non_snake_case)]
struct ConfigOptions {
    profile: String,
    installGithubRepos: bool,
}

fn ensure_directory_exists(path: &str) {
    let _ = Command::new("mkdir")
        .args(&["-p", path])
        .output()
        .expect("Failed to create a directory");
}

fn main() {
    let start = Instant::now();

    // install_refresh_script();

    let home_dir = std::env::var("HOME").expect("Could not retrieve $HOM£");

    apply_config_default(&home_dir);

    // get the profile
    log("Loading profile");
    let config_json_path = PathBuf::from(&home_dir).join(".brunt-dotfiles/config/install.json");
    let file = File::open(&config_json_path).expect("Failed to open install.json");
    let reader = BufReader::new(file);
    let config: ConfigOptions = serde_json::from_reader(reader).expect("Failed to parse JSON");
    log(&format!("\tProfile: {}", &config.profile));
    log(&format!(
        "\tInstall GitHub Repos: {}",
        config.installGithubRepos
    ));

    // Use Quad9 on home
    if config.profile == "home" {
        log("Setting nameserver to quad9");
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open("/etc/resolv.conf")
            .expect("Could not set nameserver in /etc/resolv.conf");
        let _ = file.write_all(b"nameserver 9.9.9.9");
    }

    let yes_command = Command::new("yes")
        .args(&["\"\""])
        .stdout(Stdio::piped())
        .spawn()
        .expect("Failed to start `yes` command");

    // Pipe the output of `yes` to another command
    log("Installing packages via pacman");
    let _ = Command::new("pacman")
        .args(&[
            "-Syu",
            "pass",
            "wl-clipboard", // Required for pass show -c
            "git",
            "neofetch",
            "github-cli",
            "thefuck",
            "jq",
            "base-devel",
            "tmux",
            "bat",
            "exa",
            "python3",
            "python-pip",
            "python-pipx",
            "python-setuptools",
            "ffmpeg",
            "tree",
            "fzf",
            "cloc",
            "nmap",
            "bashtop",
            "unzip",
            "lolcat",
            "neovim",
            "github-cli",
            "stow",
            "man",
            "fzf",
            "vi",
        ])
        .stdin(yes_command.stdout.unwrap())
        .output()
        .expect("Failed to start `pacman`");

    nvim::install_nvim();
    stow(&home_dir);
    sync_clock();
    install_yay(&home_dir);
    install_cargo_crates(&home_dir);
    // install_pip_packages();
    // install_snap_packages();
    install_oh_my_posh();
    install_tpm();
    install_nerdfetch();
    configure_git(&config);
    install_scripts(&home_dir);
    setup_cron();

    if config.profile == "home" {
        install_qbittorrent();
        install_tor_browser(&home_dir);
        if is_wsl() {
            install_discord();
        } else {
            let yes_command = Command::new("yes")
                .args(&["\"\""])
                .stdout(Stdio::piped())
                .spawn()
                .expect("Failed to start `yes` command");
            let _ = Command::new("pacman")
                .args(&["-Syu", "qbittorrent"])
                .stdin(yes_command.stdout.unwrap())
                .output()
                .expect("Failed to start `pacman`");
        }
    }

    if !is_wsl() {
        let yes_command = Command::new("yes")
            .args(&["\"\""])
            .stdout(Stdio::piped())
            .spawn()
            .expect("Failed to start `yes` command");
        let _ = Command::new("pacman")
            .args(&["-Syu", "firefox"])
            .stdin(yes_command.stdout.unwrap())
            .output()
            .expect("Failed to start `pacman`");
    }

    query_github_head_commit();
    log(&format!(
        "Installation complete, took {}s",
        Instant::now().duration_since(start).as_secs()
    ));

    remove_temp_dir(&home_dir);
}

fn setup_cron() {
    let yes_command = Command::new("yes")
        .args(&["\"\""])
        .stdout(Stdio::piped())
        .spawn()
        .expect("Failed to start `yes` command");

    log("Installing cronie via pacman");
    let _ = Command::new("pacman")
        .args(&["-Syu", "cronie"])
        .stdin(yes_command.stdout.unwrap())
        .output()
        .expect("Failed to start `pacman`");

    log("Enabling cron service");
    let _ = Command::new("systemctl")
        .args(&["start", "cronie"])
        .output()
        .expect("Failed to enable cron service");

    log("Starting cron service");
    let _ = Command::new("systemctl")
        .args(&["start", "cronie"])
        .output()
        .expect("Failed to start cron service");
}

fn stow(home_dir: &String) {
    log("Stowing");
    let binding = PathBuf::from(&home_dir).join(".brunt-dotfiles/repo");
    let path = binding
        .to_str()
        .expect("Could not form a path for dotfiles repo");
    if let Ok(_) = fs::metadata(path) {
        let _ = Command::new("git")
            .args(&["-C", path, "stash", "-u"])
            .output()
            .expect("Could not git fetch dotfiles repo");
        let _ = Command::new("git")
            .args(&["-C", path, "fetch", "origin", "--progress", "--all"])
            .output()
            .expect("Could not git fetch dotfiles repo");
        let _ = Command::new("git")
            .args(&["-C", path, "reset", "--hard", "origin/main"])
            .output()
            .expect("Could not git fetch dotfiles repo");
    } else {
        let _ = Command::new("git")
            .args(&["clone", "https://github.com/jbrunton4/dotfiles", path])
            .output()
            .expect("Could not git clone dotfiles repo");
    }

    apply_stow("atuin", path, home_dir);
    apply_stow("bash", path, home_dir);
    apply_stow("git", path, home_dir);
    apply_stow("npm", path, home_dir);
    apply_stow("nvim", path, home_dir);
    apply_stow("tmux", path, home_dir);
    apply_stow("wezterm", path, home_dir);
}

fn apply_stow(package: &str, dir: &str, target: &str) {
    log(&format!("Stow {}", package));
    let _ = Command::new("stow")
        .args(&[package, "-d", dir, "-t", target])
        .output()
        .expect(&format!("Could not stow {}", package));
}

fn remove_temp_dir(home_dir: &String) {
    let path = PathBuf::from(&home_dir).join(".brunt-dotfiles/temp");
    match fs::remove_dir_all(path.clone()) {
        Ok(_) => log("Removed temp files"),
        Err(_) => eprintln!(
            "Could not remove temp files, please manually remove {}",
            path.display()
        ),
    }
}

fn install_yay(home_dir: &String) {
    log("Installing yay");
    let url = "https://aur.archlinux.org/yay.git";
    let path = PathBuf::from(&home_dir).join(".brunt-dotfiles/temp/yay");
    match Repository::clone(url, path.clone()) {
        Ok(_) => log("Cloned yay from the AUR"),
        Err(e) => panic!("Failed to clone yay repo from AUR: {}", e),
    }

    let current_dir = env::current_dir().expect("Could not determine current working directory");
    env::set_current_dir(&path).expect("Failed to change directory");
    let _ = Command::new("makepkg")
        .args(&["-si"])
        .output()
        .expect("Could not makepkg on yay");
    env::set_current_dir(current_dir).expect("Could not switch back to original directory");
}

fn install_cargo_crates(home_dir: &String) {
    log("Installing cargo crates");
    let _ = Command::new("rustup")
        .arg("update")
        .output()
        .expect("Failed to install one or more cargo crates");

    let binding = PathBuf::from(&home_dir).join(".brunt-dotfiles");
    let install_root = binding
        .to_str()
        .expect("Could not create a path for ~/.brunt-dotfiles");

    let _ = Command::new("cargo")
        .args(&[
            "install", "atuin", "du-dust", "eza", "ripgrep", "exa", "bat",
        ])
        .output()
        .expect("Failed to install one or more cargo crates");
    let _ = Command::new("cargo")
        .args(&[
            "install",
            "--git",
            "https://github.com/jbrunton4/watch-file.git",
            "--root",
            install_root,
        ])
        .output()
        .expect("Failed to install one or more cargo crates from git");
}

fn install_scripts(home_dir: &String) {
    log("Installing scripts");
    let folder_name = ".brunt-dotfiles/bin";
    let binding = PathBuf::from(&home_dir).join(folder_name);
    let folder = binding.to_str().expect(&format!(
        "Could not turn buffer to string while concatonating home directory to {}",
        folder_name
    ));

    let _ = Command::new("mkdir")
        .args(&["-p", folder])
        .output()
        .expect(&format!("Failed to create directory ~/{}", folder));
    for file in [
        "git-back",
        "git-find",
        "git-forget",
        "git-ignoretemplate",
        "git-profile",
        "lolcat_block",
        "open_visual_studio_pro_22",
        "open_work_project",
        "pspsps",
        "unix",
        "split-video",
    ] {
        let url = format!(
            "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/scripts/{}.sh",
            file
        );
        let path = PathBuf::from(folder)
            .join(file)
            .to_str()
            .expect(&format!(
                "Could not turn buffer to string while concatonating {} to {}",
                folder, file
            ))
            .to_string();
        download_file(&url, &path);
    }
}

fn query_github_head_commit() {
    let owner = "jbrunton4";
    let repo = "dotfiles";
    let branch = "main";
    let url = format!(
        "https://api.github.com/repos/{}/{}/commits/{}",
        owner, repo, branch
    );

    let client = Client::new();
    let response = client
        .get(&url)
        .header(reqwest::header::USER_AGENT, "My Rust Program")
        .send()
        .expect("Something went wrong while trying to find what commit we're at");

    if response.status().is_success() {
        let commit: Commit = response
            .json()
            .expect("Could not decode response from GitHub into commit info");
        log(&format!("Commit {}", commit.sha));
    } else {
        log("Error while accessing GitHub API to retrieve commit hash at head of refs/main")
    }
}

fn install_nerdfetch() {
    log("Installing nerdfetch");
    let _ = Command::new("curl")
        .args(&[
            "https://raw.githubusercontent.com/ThatOneCalculator/NerdFetch/main/nerdfetch",
            "-o",
            "/usr/bin/nerdfetch",
        ])
        .output()
        .expect("Failed to curl nerdfetch into file /usr/bin/nerdfetch");
    let _ = Command::new("chmod")
        .args(&["+x", "/usr/bin/nerdfetch"])
        .output()
        .expect("Failed to add execute permission to nerdfetch binary (/usr/bin/nerdfetch)");
}

fn install_tor_browser(home_dir: &String) {
    let folder_name = ".brunt-dotfiles/install/tor";
    let binding = PathBuf::from(&home_dir).join(folder_name);
    let install_dir = binding.to_str().expect(&format!(
        "Failed to concatonate home directory to {}",
        folder_name
    ));

    let tor_installed = match fs::metadata(&install_dir) {
        Ok(metadata) => metadata.is_dir(),
        Err(_) => false,
    };

    if tor_installed {
        log("Tor is already installed, skipping this step...");
        return;
    }
    log("Installing tor browser");

    let url = "https://www.torproject.org/dist/torbrowser/13.0.10/tor-browser-linux-x86_64-13.0.10.tar.xz";
    let path = ".brunt-dotfiles/install/tor/installer.tar.xz";
    let binding = PathBuf::from(&home_dir).join(path);
    let tar_xz_location = binding.to_str().expect(&format!(
        "Couldn't assemble a path for tor tarball download, concatonating home directory to {}",
        path
    ));

    ensure_directory_exists(install_dir);

    let _ = Command::new("wget")
        .args(&["-O", tar_xz_location, url])
        .output()
        .expect("Failed to download tor 13.0.10 tarbal using wget");

    let _ = Command::new("tar")
        .args(&["-xf", tar_xz_location, "-C", install_dir])
        .output()
        .expect("Failed to extract tor tarball");
}

fn download_file(source: &String, path: &String) {
    log(&format!("    Downloading file {} -> {}", &source, &path));
    let mut response =
        reqwest::blocking::get(source).expect(&format!("Couldn't find file online: {}", source));
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(path)
            .expect(&format!("Could not open path to download file: {}", path));
        let mut buffer = Vec::new();
        response.read_to_end(&mut buffer).expect(&format!(
            "Could not read a response while downloading file {}",
            source
        ));
        file.write_all(&buffer)
            .expect(&format!("Could not write to file {}", path));
    }
}

fn configure_git(config: &ConfigOptions) {
    log("Configuring git");
    if config.profile == "home" {
        let _ = Command::new("git")
            .args(&["config", "--global", "user.email", "josh.brunton@proton.me"])
            .output()
            .expect("Failed to set git global user.email");

        let _ = Command::new("git")
            .args(&["config", "--global", "github.user", "jbrunton4"])
            .output()
            .expect("Failed to set git global github.user");
    } else {
        let _ = Command::new("git")
            .args(&["config", "--global", "user.email", "josh.brunton@binary.ax"])
            .output()
            .expect("Failed to set git global github.user");
    }
}

// fn install_pip_packages() {
//     log("Installing pip packages");
//     let _ = Command::new("pipx")
//         .args(&["install", "speedtest-cli", "pyinstaller"])
//         .output()
//         .expect("Failed to install one or more pip packages");
// }

fn apply_config_default(home_dir: &String) {
    log("Ensuring configurations exist");
    let install_json_path = ".brunt-dotfiles/config/install.json";
    let binding = PathBuf::from(&home_dir).join(install_json_path);
    let config_json_path = binding.to_str().expect(&format!(
        "Failed to concatonate home directory to {}",
        install_json_path
    ));
    ensure_directory_exists(
        PathBuf::from(&home_dir)
            .join(".brunt-dotfiles/config")
            .to_str()
            .expect("Could not assemble a path for config defaults"),
    );
    match fs::metadata(&config_json_path) {
        Ok(_) => {}
        Err(_) => {
            let mut response = reqwest::blocking::get("https://raw.githubusercontent.com/jbrunton4/dotfiles/main/config_defaults/install.json")
                .expect("install.json was not found, but couldn't find the default file online");
            if response.status().is_success() {
                let mut file =
                    File::create(config_json_path).expect("Could not create install.json");
                let mut buffer = Vec::new();
                response
                    .read_to_end(&mut buffer)
                    .expect("Could not read a response for install.json");
                file.write_all(&buffer)
                    .expect("Could not write to install.json");
            } else {
                panic!("install.json was not found, but couldn't find the default file online")
            }
        }
    }
    let logs_json_path = PathBuf::from(&home_dir).join(".brunt-dotfiles/config/logs.json");
    match fs::metadata(&logs_json_path) {
        Ok(_) => {}
        Err(_) => {
            let mut response = reqwest::blocking::get("https://raw.githubusercontent.com/jbrunton4/dotfiles/main/config_defaults/logs.json")
                .expect("logs.json was not found, but couldn't find the default file online");
            if response.status().is_success() {
                let mut file = File::create(logs_json_path).expect("Could not create logs.json");
                let mut buffer = Vec::new();
                response
                    .read_to_end(&mut buffer)
                    .expect("Could not read a response for logs.json");
                file.write_all(&buffer)
                    .expect("Could not write to logs.json");
            } else {
                panic!("logs.json was not found, but couldn't find the default file online")
            }
        }
    }
}

fn sync_clock() {
    log("Syncing system clock");
    let _ = Command::new("hwclock")
        .args(&["--systohc"])
        .output()
        .expect("Failed to sync system clock");
}

fn install_oh_my_posh() {
    log("Installing oh my posh");
    let _ = Command::new("bash")
        .arg("-c")
        .arg(r#"curl -s -sSL https://ohmyposh.dev/install.sh | bash -s"#)
        .output()
        .expect("Failed to install oh my posh");
}

// fn ensure_pipx_in_path() {
//     log("Ensuring pipx in the path");
//     let _ = Command::new("pipx")
//         .args(&["ensurepath"])
//         .output()
//         .expect("Failed to install ensure pipx in PATH");
// }

fn install_tpm() {
    log("Installing tpm (tmux plugin manager)");
    let _ = Command::new("bash")
        .arg("-c")
        .arg(r#"git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm"#)
        .output()
        .expect("Failed to install tpm");
}

fn install_discord() {
    log("Installing discord");
    let _ = Command::new("yay")
        .args(&["-S", "discord"])
        .output()
        .expect("Failed to install discord via yay");
}

fn install_qbittorrent() {
    log("Installing qbittorrent");

    let _ = Command::new("add-apt-repository")
        .args(&["ppa:qbittorrent-team/qbittorrent-stable"])
        .output()
        .expect("Failed to add apt repository ppa:qbittorrent-team/qbittorrent-stable");

    let _ = Command::new("apt")
        .args(&["update", "-y"])
        .output()
        .expect("Failed to run apt update with newly added repositories.");

    let _ = Command::new("apt-get")
        .args(&["install", "-y", "qbittorrent"])
        .output()
        .expect("Failed to install qbittorrent via apt");
}

fn log(message: &str) {
    println!("[{}] {}", Local::now().format("%Y-%m-%d %H:%M:%S"), message)
}
