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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# UV
. "$HOME/.local/bin/env"
