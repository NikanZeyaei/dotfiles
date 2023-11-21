if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-vi-mode
	zsh-nvm
	sudo
)

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 2 10); do time $shell -i -c exit; done
}

source $ZSH/oh-my-zsh.sh
alias vim="nvim"
alias p="sudo pacman"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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

