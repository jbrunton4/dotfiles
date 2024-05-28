use chrono::Local;
use is_wsl::is_wsl;
use reqwest::blocking::Client;
use serde::{Deserialize, Serialize};
use std::fs;
use std::fs::File;
use std::fs::OpenOptions;
use std::io::BufReader;
use std::io::{Read, Write};
use std::path::PathBuf;
use std::process::{Command, Stdio};
use std::time::Instant;

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
    // if config.profile == "home" {
    //     log("Setting nameserver to quad9");
    //     let mut file = OpenOptions::new()
    //         .write(true)
    //         .create(true)
    //         .truncate(true)
    //         .open("/etc/resolv.conf")
    //         .expect("Could not set nameserver in /etc/resolv.conf");
    //     let _ = file.write_all(b"nameserver 9.9.9.9");
    // }

    let yes_command = Command::new("yes")
        .stdout(Stdio::piped())
        .spawn()
        .expect("Failed to start `yes` command");

    // Pipe the output of `yes` to another command
    log("Installing packages via pacman");
    let _ = Command::new("pacman")
        .args(&[
            "-Syu",
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
            "neovim",
            "nmap",
            "bashtop",
            "unzip",
        ])
        .stdin(yes_command.stdout.unwrap())
        .output()
        .expect("Failed to start `pacman`");

    
    sync_clock();
    install_cargo_crates();
    // install_pip_packages();
    // install_snap_packages();
    configure_profile(&home_dir);
    configure_bash_aliases(&home_dir);
    configure_bashrc(&home_dir);
    configure_git(&home_dir, &config);
    install_oh_my_posh();
    configure_tmux(&home_dir);
    install_tpm();
    install_nerdfetch();
    install_scripts(&home_dir);
    config_wezterm(&home_dir);
    install_git_hooks(&home_dir);

    if is_wsl() {
        touch_hushlogin(&home_dir);
        // set_wsl_default_user();
    }

    if config.profile == "home" {
        install_discord(&home_dir);
        install_qbittorrent();
        install_tor_browser(&home_dir);
    }

    query_github_head_commit();
    log(&format!(
        "Installation complete, took {}s",
        Instant::now().duration_since(start).as_secs()
    ))
    // todo: gh-repos, gitext, newsboat
}

fn install_cargo_crates() {
    log("Installing cargo crates");
    let _ = Command::new("rustup")
        .arg("update")
        .output()
        .expect("Failed to install one or more cargo crates");
    let _ = Command::new("cargo")
        .args(&["install", "atuin", "du-dust", "eza", "ripgrep"])
        .output()
        .expect("Failed to install one or more cargo crates");
}

fn install_git_hooks(home_dir: &String) {
    log("Installing git hooks");
    let folder_name = ".brunt-dotfiles/config/git/hooks";
    let folder = PathBuf::from(&home_dir).join(folder_name);

    let _ = Command::new("mkdir")
        .args(&[
            "-p",
            folder.to_str().expect("Could not turn buffer to string"),
        ])
        .output()
        .expect(&format!(
            "Could not create folder for git commit hooks - tried to create {}",
            folder_name
        ));

    for file in ["prepare-commit-msg"] {
        let url = format!(
            "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/git-hooks/{}",
            file
        );
        let path = PathBuf::from(folder.clone())
            .join(file)
            .to_str()
            .expect("Could not turn buffer to string")
            .to_string();
        download_file(&url, &path);
        let _ = Command::new("chmod")
            .args(&["+x", &path])
            .output()
            .expect(&format!(
                "Could not add execute permission for git hook \"{}\"",
                path
            ));
    }
}

fn config_wezterm(home_dir: &String) {
    log("Configuring wezterm");
    let folder = PathBuf::from(&home_dir)
        .join(".wezterm.lua")
        .to_str()
        .expect("")
        .to_string();
    download_file(
        &"https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.wezterm.lua"
            .to_string(),
        &folder,
    );
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
        "split-video"
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

fn configure_git(home_dir: &String, config: &ConfigOptions) {
    log("Installing .gitconfig");
    let mut response = reqwest::blocking::get(
        "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.gitconfig",
    )
    .expect("Couldn't find .gitconfig online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(PathBuf::from(&home_dir).join(".gitconfig"))
            .expect("Could not open ~/.gitconfig");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for .gitconfig");
        file.write_all(&buffer)
            .expect("Could not write ~/.gitconfig");
    }
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

fn configure_bashrc(home_dir: &String) {
    log("Configuring bashrc");
    let mut response = reqwest::blocking::get(
        "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.bashrc",
    )
    .expect("Couldn't find bashrc online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(PathBuf::from(&home_dir).join(".bashrc"))
            .expect("Could not open ~/.bashrc");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for bashrc");
        file.write_all(&buffer).expect("Could not write ~/.bashrc");
    }
}

fn configure_profile(home_dir: &String) {
    log("Configuring ~/.profile");
    let mut response = reqwest::blocking::get(
        "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.profile",
    )
    .expect("Couldn't find .profile online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(PathBuf::from(&home_dir).join(".profile"))
            .expect("Could not open ~/.profile");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for profile");
        file.write_all(&buffer).expect("Could not write ~/.profile");
    }
}

fn configure_bash_aliases(home_dir: &String) {
    log("Configuring bash aliases");
    let mut response = reqwest::blocking::get(
        "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.bash_aliases",
    )
    .expect("Couldn't find bash aliases online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(PathBuf::from(&home_dir).join(".bash_aliases"))
            .expect("Could not open ~/.bash_aliases");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for bash aliases");
        file.write_all(&buffer)
            .expect("Could not write ~/.bash_aliases");
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

fn touch_hushlogin(home_dir: &String) {
    log("Touching ~/.hushlogin");
    let _ = File::create(PathBuf::from(&home_dir).join(".hushlogin"));
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

fn configure_tmux(home_dir: &String) {
    log("Installing tmux");
    let mut response = reqwest::blocking::get(
        "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.tmux.conf",
    )
    .expect("Couldn't find tmux.conf online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(PathBuf::from(&home_dir).join(".tmux.conf"))
            .expect("Could not open ~/.tmux.conf");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for .tmux.conf");
        file.write_all(&buffer)
            .expect("Could not write ~/.tmux.conf");
    }
}

fn install_tpm() {
    log("Installing tpm (tmux plugin manager)");
    let _ = Command::new("bash")
        .arg("-c")
        .arg(r#"git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm"#)
        .output()
        .expect("Failed to install tpm");
}

fn install_discord(home_dir: &str) {
    let discord_installed =
        match fs::metadata(PathBuf::from(&home_dir).join(".brunt-dotfiles/install/discord")) {
            Ok(metadata) => metadata.is_dir(),
            Err(_) => false,
        };

    if discord_installed {
        log("Skipping discord install (already installed)");
        return;
    }

    log("Installing discord");

    let _ = Command::new("apt")
        .args(&["install", "libnotify4", "libnspr4", "libnss3"])
        .output()
        .expect("Failed to install one or more apt packages as a dependency of discord");

    fs::create_dir(PathBuf::from(&home_dir).join(".brunt-dotfiles/install/discord"))
        .expect("Could not create directory for discord install");

    let discord_deb_path =
        PathBuf::from(&home_dir).join(".brunt-dotfiles/install/discord/installer.deb");

    let mut response =
        reqwest::blocking::get("https://discord.com/api/download?platform=linux&format=deb")
            .expect("Couldn't find discord .deb");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(&discord_deb_path)
            .expect("Could not open .brunt-dotfiles/install/discord/installer.deb");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for discord install");
        file.write_all(&buffer)
            .expect("Could not write a file for discord install");
    }

    let _ = Command::new("dpkg")
        .args(&[
            "-i",
            discord_deb_path
                .to_str()
                .expect("Could not convert discord.deb path from PathBuf to string"),
        ])
        .output()
        .expect("Failed to install one or more apt packages as a dependency of discord");

    let _ = Command::new("apt")
        .args(&["install", "-f"])
        .output()
        .expect("Failed to install one or more apt packages as a dependency of discord");
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
