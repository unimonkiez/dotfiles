# Zellij Config Notes

## macOS: Cmd+Alt+H (focus pane left) conflict

macOS fires `hideOtherApplications:` at the AppKit level for `Cmd+Option+H` before
any key event reaches the terminal. Alacritty cannot intercept it.

**Fix (one-time, system-level):**

1. System Settings → Keyboard → Keyboard Shortcuts → App Shortcuts
2. Click **+**
3. Application: **Alacritty** (or All Applications)
4. Menu Title: `Hide Others`
5. Assign a throwaway combo, e.g. `Cmd+Ctrl+Shift+H`

This frees up `Cmd+Option+H` so Alacritty forwards it to Zellij as a KKP sequence.

## Cmd+Shift+C — scrollback in nvim

Opens the pane's scrollback directly in nvim, focused on the last line.
Wrapper script: `~/.config/zellij/scripts/scrollback-nvim.sh` (`nvim + <tempfile>`)

Once in nvim, use normal vim motions to navigate/yank. `:q` to exit.
