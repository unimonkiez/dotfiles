.PHONY: brew brew-dump link

brew:
	brew bundle
brew-dump:
	rm -f $(CURDIR)/Brewfile
	brew bundle dump --file=$(CURDIR)/Brewfile
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
	ln -sfv $(CURDIR)/claude/claude_desktop_config.json ~/Library/Application\ Support/Claude/claude_desktop_config.json
	ln -sfv $(CURDIR)/pi ~/.pi
