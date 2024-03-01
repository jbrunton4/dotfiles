use crossterm::{
    terminal::{
        disable_raw_mode, enable_raw_mode, EnterAlternateScreen,
        LeaveAlternateScreen,
    }, ExecutableCommand
};
use ratatui::{
    prelude::{CrosstermBackend, Terminal}, widgets::{Block, Borders, Paragraph}}
    ;
use std::{io::{stdout, Result, Stdout}, rc::Rc};

pub fn enter_alternate_terminal() -> Result<Terminal<CrosstermBackend<Stdout>>> {
    stdout().execute(EnterAlternateScreen)?;
    enable_raw_mode()?;
    let mut terminal = Terminal::new(CrosstermBackend::new(stdout()))?;
    terminal.clear()?;
    Ok(terminal)
}

pub fn leave_alternate_terminal() -> Result<()> {
    stdout().execute(LeaveAlternateScreen)?;
    disable_raw_mode()?;
    Ok(())
}

pub fn draw<'a, 'b>(terminal: &mut Terminal<CrosstermBackend<Stdout>>, layout: &Rc<[ratatui::layout::Rect]>, n: &i32, m: &i32) {
    terminal.draw(|frame| {
        frame.render_widget(
            Paragraph::new(format!("n={}", n))
            .block(Block::new().borders(Borders::ALL)),
            layout[0]);
        frame.render_widget(
            Paragraph::new(format!("m={}", m))
            .block(Block::new().borders(Borders::ALL)),
            layout[1]);
    }).expect("Could not draw terminal");
}
