mod alternate_terminal;
mod packages;
mod command_handler;

use packages::apts::*;
use packages::crates::*;
use packages::pips::*;
use packages::snaps::*;

use crossterm::event::{self, KeyCode, KeyEventKind};
use ratatui::layout::{Constraint, Direction};
use std::io::Result;

fn main() -> Result<()> {

    install_apts();
    install_crates();
    install_pips();
    install_snaps();
    return Ok(());

    let mut terminal = alternate_terminal::enter_alternate_terminal()?;

    let mut n: i32 = 0;
    let mut m: i32 = 0;

    let layout = ratatui::prelude::Layout::default()
        .direction(Direction::Vertical)
        .constraints(vec![
            Constraint::Percentage(50),
            Constraint::Percentage(50),
        ])
        .split(terminal.get_frame().size());

    alternate_terminal::draw(&mut terminal, &layout, &n, &m);

    loop {
        if event::poll(std::time::Duration::from_millis(16))? {
            if let event::Event::Key(key) = event::read()? {
                if key.kind == KeyEventKind::Press
                    && key.code == KeyCode::Char('q')
                {
                    break;
                }

                if key.kind == KeyEventKind::Press && key.code == KeyCode::Char('n') {
                    n += 1;
                    alternate_terminal::draw(&mut terminal, &layout, &n, &m);
                }

                if key.kind == KeyEventKind::Press && key.code == KeyCode::Char('m') {
                    m += 1;
                    alternate_terminal::draw(&mut terminal, &layout, &n, &m);
                }
            }
        }
    }

    alternate_terminal::leave_alternate_terminal()?;
    println!("{}", n);
    Ok(())
}

