use std::process::Command; 

pub fn run_command(command: String) {
    let result = Command::new("/bin/bash")
        .arg("-c")
        .arg(&command)
        .output();

    match result {
        Ok(output) => {
            println!("{}", String::from_utf8_lossy(&output.stdout));
            println!("{}", String::from_utf8_lossy(&output.stderr));
        },
        Err(ex) => {
            println!("Error while executing command \"{}\": \n{}", command, ex);
        }
    }
}

