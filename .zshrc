source /home/nikan/.bash_profile
source /home/nikan/.bashrc

export BROWSER='/usr/bin/firefox' 

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
plugins=(
	autoswitch_virtualenv
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-history-substring-search
	zsh-vi-mode
	zsh-nvm
	sudo
)

bindkey '^[[1;5B' history-substring-search-up
bindkey '^[[1;5A' history-substring-search-down

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 2 10); do time $shell -i -c exit; done
}

zmodload zsh/zprof

source $ZSH/oh-my-zsh.sh
alias vim="nvim"
alias p="sudo pacman"
alias b="sudo bluetoothctl"
alias copy='xsel -ib'
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR=nvim

# source /usr/share/nvm/init-nvm.sh

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

setopt autocd		# Automatically cd into typed directory.

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export LOCAL_SCRIPTS=$HOME/.local/bin
export BOB=$HOME/.local/share/bob/nvim-bin
export DOOM=$HOME/.config/emacs/bin
export FLYCTL=$HOME/.fly
export PATH=$PATH:$GOBIN:$LOCAL_SCRIPTS:$BOB:$DOOM:$FLYCTL/bin

eval $(thefuck --alias)
fpath=(~/.zsh.d/ $fpath)

# bun completions
[ -s "/home/nikanzeyaei/.bun/_bun" ] && source "/home/nikanzeyaei/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=false

ZVM_CURSOR_STYLE_ENABLED=false

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:/home/nikan/.spicetify
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
