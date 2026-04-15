# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -d "$HOME/tools/powerlevel10k" ]]; then
  mkdir -p "$HOME/tools"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/tools/powerlevel10k"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/tools/powerlevel10k/powerlevel10k.zsh-theme

if [[ ! -d "$HOME/tools/zsh-autocomplete" ]]; then
  mkdir -p "$HOME/tools"
  git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git "$HOME/tools/zsh-autocomplete"
fi
source ~/tools/zsh-autocomplete/zsh-autocomplete.plugin.zsh

  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# UV
. "$HOME/.local/bin/env"

# Rust
. "$HOME/.cargo/env"

eval "$(brew shellenv)"
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
autoload -U compinit
compinit


autoload -Uz add-zsh-hook
function _zellij_set_pane_title() {
    print -Pn "\e]2;%~\a"
    if [[ -n "$ZELLIJ" ]]; then
        command zellij action rename-tab "zsh"
    fi
}
function _zellij_set_cmd_title() {
    print -Pn "\e]2;${1%% *}\a"
    if [[ -n "$ZELLIJ" ]]; then
        command zellij action rename-tab "${1%% *}"
    fi
}
add-zsh-hook precmd _zellij_set_pane_title
add-zsh-hook preexec _zellij_set_cmd_title

