.PHONY: brew link

brew:
	brew bundle
link:
	mkdir -p ~/Library/Application\ Support/Cursor/User
	ln -sfv $(CURDIR)/vscode/keybindings.json ~/Library/Application\ Support/Cursor/User/keybindings.json
	mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
	ln -sfv $(CURDIR)/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
	mkdir -p ~/.cursor
	ln -sfv $(CURDIR)/.cursor/rules ~/.cursor/rules
	ln -sfv $(CURDIR)/zsh/.zshrc ~/.zshrc
	ln -sfv $(CURDIR)/zsh/.p10k.zsh ~/.p10k.zsh
	ln -sfv $(CURDIR)/git/.gitconfig ~/.gitconfig
