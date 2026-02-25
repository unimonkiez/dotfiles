sym-link:
	mkdir -p ~/Library/Application\ Support/Cursor/User
	ln -sfv $(CURDIR)/vscode/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
	mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
	ln -sfv $(CURDIR)/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
	mkdir -p ~/.cursor
	ln -sfv $(CURDIR)/.cursor/rules ~/.cursor/rules