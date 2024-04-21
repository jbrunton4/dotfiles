use serde::{Deserialize, Serialize};
use std::fs;
use std::fs::File;
use std::fs::OpenOptions;
use std::io::BufReader;
use std::io::{Read, Write};
use std::path::PathBuf;
use std::process::Command;
use chrono::Local;
use std::time::Instant;

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

    let home_dir = std::env::var("HOME").expect("Could not retrieve $HOM£");

    // detect wsl
    log("Detecting WSL");
    let is_wsl = match fs::metadata("/etc/wsl.conf") {
        Ok(_) => true,
        Err(_) => false,
    };

    apply_config_default(&home_dir);

    // get the profile
    log("Loading profile");
    let config_json_path = PathBuf::from(&home_dir).join(".brunt-dotfiles/config/install.json");
    let file = File::open(&config_json_path).expect("Failed to open install.json");
    let reader = BufReader::new(file);
    let config: ConfigOptions = serde_json::from_reader(reader).expect("Failed to parse JSON");
    log(&format!("Profile: {}", &config.profile));
    log(&format!("Install GitHub Repos: {}", config.installGithubRepos));

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

    update_apt();
    ensure_mono();
    ensure_python3();
    update_pip();
    ensure_snap();
    configure_atuin(&home_dir);
    sync_clock();
    install_apt_packages();
    install_cargo_crates();
    install_pip_packages();
    install_snap_packages(&is_wsl);
    configure_bash_aliases(&home_dir);
    configure_bashrc(&home_dir);
    configure_git(&home_dir, &config);
    install_lunarvim(&home_dir);
    install_oh_my_posh();
    install_thefuck();
    install_tmux(&home_dir);
    install_tpm();

    if is_wsl {
        touch_hushlogin(&home_dir);
        set_wsl_default_user();
    }

    if config.profile == "home" {
        install_discord(&home_dir);
        install_qbittorrent();
        install_tor_browser(&home_dir);
    }

    apply_apt_fixes();

    log("Done!");

    log(&format!("Installation complete, took {}s", Instant::now().duration_since(start).as_secs()))
    // todo: gh-repos, gitext, newsboat, scripts, prune old logs
}

fn install_tor_browser(home_dir: &String) {
    let binding = PathBuf::from(&home_dir).join(".brunt-dotfiles/install/tor");
    let install_dir = binding.to_str().expect("Couldn't assemble a path for tor installation");

    let tor_installed =
        match fs::metadata(&install_dir) {
            Ok(metadata) => metadata.is_dir(),
            Err(_) => false,
        };

    if tor_installed {
        log("Tor is already installed, skipping this step...");
        return;
    }

    let url = "https://www.torproject.org/dist/torbrowser/13.0.10/tor-browser-linux-x86_64-13.0.10.tar.xz";
    let binding = PathBuf::from(&home_dir).join(".brunt-dotfiles/install/tor/installer.tar.xz");
    let tar_xz_location = binding.to_str().expect("Couldn't assemble a path for tor tarball download"); 

    ensure_directory_exists(install_dir);

    let _ = Command::new("wget")
        .args(&["-O", tar_xz_location, url])
        .output()
        .expect("Failed to download tor 13.0.10 tarball");

    let _ = Command::new("tar")
        .args(&["-xf", tar_xz_location, "-C", install_dir])
        .output()
        .expect("Failed to extract tor tarball");
}

fn ensure_snap() {
    log("Ensuring snap is installed");
    let _ = Command::new("apt")
        .args(&["install", "snapd"])
        .output()
        .expect("Failed to install snapd via apt");

    let _ = Command::new("ln")
        .args(&["-s", "/var/lib/snapd/snap", "/snap"])
        .output()
        .expect("Failed to symlink /var/lib/snapd/snap -> /snap");
}

fn install_snap_packages(is_wsl: &bool) {
    log("Installing snaps");
    let _ = Command::new("snap")
        .args(&["install", "ascii-image-converter", "lazygit", "lolcat"])
        .output()
        .expect("Failed to install one or more pip packages");
    if !is_wsl {
        let _ = Command::new("snap")
            .args(&["install", "firefox", "gimp", "postman"])
            .output()
            .expect("Failed to install one or more pip packages (wsl-specific)");
    } else {
        let _ = Command::new("snap")
            .args(&["install", "snap-store"])
            .output()
            .expect("Failed to install one or more pip packages (wsl-exclusive)");
    }
}

fn install_lunarvim(home_dir: &String) {
    log("Installing LunarVim");

    let _ = Command::new("add-apt-repository")
        .args(&["ppa:neovim-ppa/unstable"])
        .output()
        .expect("Failed to add apt repository ppa:neovim-ppa/unstable");

    let _ = Command::new("apt")
        .args(&["update", "-y"])
        .output()
        .expect("Failed to run apt update with newly added repositories.");

    let _ = Command::new("apt")
        .args(&["install", "-y", "neovim"])
        .output()
        .expect("Failed to install neovim via apt");

    let _ = Command::new("bash")
            .arg("-c")
            .arg(r#"LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)"#)
            .output()
            .expect("Failed to install LunarVim");

    match fs::create_dir_all(PathBuf::from(&home_dir).join(".config/lvim")) {
        Ok(_) => {}
        Err(_) => {}
    }
    match fs::create_dir_all(PathBuf::from(&home_dir).join(".config/lvim/luasnippets")) {
        Ok(_) => {}
        Err(_) => {}
    }

    let mut response = reqwest::blocking::get(
            "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.config/lvim/config.lua",
        )
        .expect("Couldn't find lvim/config.lua online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(PathBuf::from(&home_dir).join(".config/lvim/config.lua"))
            .expect("Could not open ~/.config/lvim/config.lua");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for lvim/config.lua");
        file.write_all(&buffer)
            .expect("Could not write ~/.config/lvim/config.lua");
    }

    let mut response = reqwest::blocking::get(
            "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.config/lvim/luasnippets/all.lua",
        )
        .expect("Couldn't find lvim/luasnippets/all.lua online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(PathBuf::from(&home_dir).join(".config/lvim/luasnippets/all.lua"))
            .expect("Could not open ~/.config/lvim/luasnippets/all.lua");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for lvim/luasnippets/all.lua");
        file.write_all(&buffer)
            .expect("Could not write ~/.config/lvim/luasnippets/all.lua");
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
            .open(PathBuf::from(&home_dir).join(".bash_alises"))
            .expect("Could not open ~/.bash_aliases");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for bash aliases");
        file.write_all(&buffer)
            .expect("Could not write ~/.bash_aliases");
    }
}

fn install_pip_packages() {
    log("Installing pip packages");
    let _ = Command::new("python3")
        .args(&["-m", "pip", "install", "speedtest-cli", "pyinstaller"])
        .output()
        .expect("Failed to install one or more pip packages");
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

fn apply_config_default(home_dir: &String) {
    log("Ensuring configurations exist");
    let config_json_path = PathBuf::from(&home_dir).join(".brunt-dotfiles/config/install.json");
    ensure_directory_exists(PathBuf::from(&home_dir).join(".brunt-dotfiles/config").to_str().expect("???"));
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

fn install_apt_packages() {
    log("Installing apt packages");
    let _ = Command::new("apt")
        .args(&[
            "install",
            "-y",
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
            "tree",
        ])
        .output()
        .expect("Failed to install one or more apt packages");
}

fn update_apt() {
    log("Updating apt");
    let _ = Command::new("apt")
        .args(&["update", "-y"])
        .output()
        .expect("Failed to run apt update. This might be because you don't have apt installed.");
}

fn ensure_mono() {
    log("Ensuring mono");
    let _ = Command::new("apt")
        .args(&["install", "-y", "mono-complete"])
        .output()
        .expect("Failed to install mono-complete using apt");
}

fn ensure_python3() {
    log("Ensuring python 3.x");
    let _ = Command::new("apt")
        .args(&["install", "-y", "python3"])
        .output()
        .expect("Failed to install mono-complete using apt");
}

fn touch_hushlogin(home_dir: &String) {
    log("Touching ~/.hushlogin");
    let _ = File::create(PathBuf::from(&home_dir).join(".hushlogin"));
}

fn update_pip() {
    log("Updating pip");
    let _ = Command::new("python3")
        .args(&["-m", "pip", "install", "--upgrade", "pip"])
        .output()
        .expect("Failed to install/upgrade pip.");
}

fn configure_atuin(home_dir: &String) {
    log("Installing atuin configuration");

    ensure_directory_exists(PathBuf::from(&home_dir).join(".config/atuin").to_str().expect("Could not assemble the atuin config directory path"));

    let mut response = reqwest::blocking::get("https://raw.githubusercontent.com/jbrunton4/dotfiles/main/userhome/.config/atuin/config.toml")
                .expect("Couldn't find atuin configuration online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(PathBuf::from(&home_dir).join(".config/atuin/config.toml"))
            .expect("Could not open a file to write atuin config");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for atuin config");
        file.write_all(&buffer)
            .expect("Could not write atuin config");
    } else {
        panic!("logs.json was not found, but couldn't find the default file online")
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
    let _ = Command::new("apt")
        .args(&["install", "-y", "unzip"])
        .output()
        .expect("Failed to install unzip via apt");
    let _ = Command::new("bash")
        .arg("-c")
        .arg(r#"curl -s -sSL https://ohmyposh.dev/install.sh | bash -s"#)
        .output()
        .expect("Failed to install LunarVim");
}

fn install_thefuck() {
    log("Installing thefuck");
    let _ = Command::new("apt")
        .args(&[
            "install",
            "-y",
            "python3-dev",
            "python3-pip",
            "python3-setuptools",
        ])
        .output()
        .expect("Failed to install apt dependencies for thefuck");
    let _ = Command::new("python3")
        .args(&["-m", "pip", "install", "thefuck"])
        .output()
        .expect("Failed to install thefuck");
}

fn install_tmux(home_dir: &String) {
    log("Installing tmux");
    let _ = Command::new("apt")
        .args(&["install", "-y", "tmux"])
        .output()
        .expect("Failed to install tmux");
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
        .expect("Failed to install LunarVim");
}

fn apply_apt_fixes() {
    log("Applying apt fixes");
    let _ = Command::new("apt")
        .arg("upgrade")
        .output()
        .expect("Failed to remove redundant apts");

    let _ = Command::new("apt")
        .arg("autoremove")
        .output()
        .expect("Failed to remove redundant apts");

    let _ = Command::new("apt")
        .args(&["install", "-f"])
        .output()
        .expect("Failed to remove redundant apts");
}

fn set_wsl_default_user() {
    log("Setting default WSL user to wsl.conf");
    let mut response = reqwest::blocking::get(
        "https://raw.githubusercontent.com/jbrunton4/dotfiles/main/linuxroot/etc/wsl.conf",
    )
    .expect("Couldn't find wsl configuration online");
    if response.status().is_success() {
        let mut file = OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open("/etc/wsl.conf")
            .expect("Could not open /etc/wsl.conf");
        let mut buffer = Vec::new();
        response
            .read_to_end(&mut buffer)
            .expect("Could not read a response for wsl.conf");
        file.write_all(&buffer).expect("Could not write wsl.conf");
    } else {
        panic!("logs.json was not found, but couldn't find the default file online")
    }
}

fn install_discord(home_dir: &str) {
    let discord_installed =
        match fs::metadata(PathBuf::from(&home_dir).join(".brunt-dotfiles/install/discord")) {
            Ok(metadata) => metadata.is_dir(),
            Err(_) => false,
        };

    if discord_installed {
        log("Skipping discord install (already installed)");
    } else {
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
