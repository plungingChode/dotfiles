use std::{
    io::{self, BufRead, BufReader},
    process::{self, Command, Stdio},
    time::SystemTime,
};

const SINK: &str = "@DEFAULT_SINK@";
// https://fontawesome.com/icons/volume-high
const VOLUME_ICON: &str = "";
// https://fontawesome.com/icons/headphones
const HEADPHONES_ICON: &str = "";
// https://fontawesome.com/icons/volume-xmark
const MUTE_ICON: &str = "";

const MUTED_COLOR: &str = "#808080";
const DEFAULT_COLOR: &str = "#BBBBBB";

fn main() {
    print_i3blocks_status();
    pactl_subscribe();
}

fn print_i3blocks_status() {
    let volume = current_volume().unwrap_or(-1);
    let muted = is_muted().unwrap_or(false);
    let headphones = using_headphones().unwrap_or(false);

    let (icon, color) = match (headphones, muted) {
        (true, false) => (HEADPHONES_ICON, DEFAULT_COLOR),
        (true, true) => (HEADPHONES_ICON, MUTED_COLOR),
        (false, false) => (VOLUME_ICON, DEFAULT_COLOR),
        (false, true) => (MUTE_ICON, MUTED_COLOR),
    };

    let full_text = format!(
        " <span face='Font Awesome 6 Free'>{}</span> {}% ",
        icon,
        volume
    );

    println!(r#"{{"full_text":"{}", "color":"{}"}}"#, full_text, color);
}

fn current_volume() -> Result<i8, io::Error> {
    let stdout = Command::new("pactl")
        .arg("get-sink-volume")
        .arg(SINK)
        .output()?
        .into_stdout_string();

    // formatted as
    // Volume: front-left .... / 99% / ...
    let volume = stdout
        .split("/")
        .nth(1)
        .unwrap_or("-1%")
        .chars()
        .filter(|c| c.is_digit(10))
        .collect::<String>()
        .parse::<i8>()
        .unwrap_or(-1);

    Ok(volume)
}

fn is_muted() -> Result<bool, io::Error> {
    let stdout = Command::new("pactl")
        .arg("get-sink-mute")
        .arg(SINK)
        .output()?
        .into_stdout_string();

    let muted = stdout.starts_with("Mute: yes");
    Ok(muted)
}

fn using_headphones() -> Result<bool, io::Error> {
    let stdout = Command::new("pactl")
        .arg("get-default-sink")
        .output()?
        .into_stdout_string();

    Ok(stdout.contains("Jabra"))
}

fn pactl_subscribe() -> ! {
    let cmd = Command::new("pactl")
        .arg("subscribe")
        .stdout(Stdio::piped())
        .spawn()
        .expect("couldn't subscribe to pactl");

    let mut last_update = SystemTime::now();
    let mut reader = BufReader::new(cmd.stdout.unwrap());
    loop {
        let mut buf = String::new();
        match reader.read_line(&mut buf) {
            Ok(..) => {
                let time_since_update = SystemTime::now()
                    .duration_since(last_update)
                    .unwrap()
                    .as_millis();

                if time_since_update < 300 {
                    continue;
                } else {
                    last_update = SystemTime::now();
                }
                if buf.contains("sink") || buf.contains("server") {
                    notify_i3blocks();
                }
                print_i3blocks_status();
            }
            Err(..) => {}
        }
    }
}

fn notify_i3blocks() {
    Command::new("pkill")
        .arg("-RTMIN+10")
        .arg("i3blocks")
        .output()
        .expect("couldn't notify i3blocks");
}

trait OutputExt {
    fn into_stdout_string(self) -> String;
}

impl OutputExt for process::Output {
    fn into_stdout_string(self) -> String {
        String::from_utf8(self.stdout).unwrap()
    }
}
