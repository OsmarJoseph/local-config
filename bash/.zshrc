# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

export ZSH="$HOME/.oh-my-zsh"
plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
export VISUAL='nvim'
export OPENAI_API_HOST="api.openai.com"

if [ -f ~/secrets.sh ]; then
    . ~/secrets.sh
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export PATH="$PATH:/Users/osmarjoseph/development/flutter/bin"

export ANDROID_HOME="/Users/$USER/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH:$HOME/scripts"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# fzf
eval "$(fzf --zsh)"

source $HOME/.config/tmux/plugins/tokyonight.nvim/extras/fzf/tokyonight_night.sh

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--color=bg+:-1 \
--color=bg:-1 \
--color=gutter:-1"


show_file_or_dir_preview="if [ -d {} ]; then ls -a {} | tail -n +3 | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git --exclude node_modules --exclude Library"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'ls -a {} | tail -n +3'"
#
# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'ls -a {} | tail -n +3' "$@" ;;
    export|unset) fzf --preview "eval 'echo $'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git --exclude node_modules --exclude Library . "$1"
}

## Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git --exclude node_modules --exclude Library . "$1"
}

# powerlevel10k
source $HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

setopt VI

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

export FZF_COMPLETION_TRIGGER=''
bindkey '^@' complete-word # ctrl+space to autocomplete
bindkey '^I^I' autosuggest-accept
bindkey '^T' fzf-completion
bindkey '^D' fzf-cd-widget

export ZSH_AUTOSUGGEST_STRATEGY=(
    history
    completion
)

run_sessionnizer() {
  sessionizer
}

zle -N run_sessionnizer

bindkey '^Z' run_sessionnizer
# Custom widget to delete everything behind the cursor
delete_to_start_of_line() {
  zle kill-region
  zle backward-kill-line
}
zle -N delete_to_start_of_line
bindkey '^U' delete_to_start_of_line

bindkey -M vicmd '^[f' vi-forward-word
#
# Custom Ctrl+A: Exit Insert Mode, then move to the beginning of the line
function ctrl_a_to_beginning() {
    zle vi-cmd-mode       # Switch to Command Mode
    zle vi-beginning-of-line # Move to the beginning of the line
}
zle -N ctrl_a_to_beginning

# Custom Ctrl+E: Exit Insert Mode, then move to the end of the line
function ctrl_e_to_end() {
    zle vi-cmd-mode       # Switch to Command Mode
    zle vi-end-of-line    # Move to the end of the line
}
zle -N ctrl_e_to_end

bindkey -r '^A'
bindkey -r '^E'
# Bind in vi Insert Mode
bindkey -M viins '^A' ctrl_a_to_beginning
bindkey -M viins '^E' ctrl_e_to_end

# Bind in vi Command Mode
bindkey -M vicmd '^A' vi-beginning-of-line
bindkey -M vicmd '^E' vi-end-of-line

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Bat
export BAT_THEME="base16-256"

# --- TheFuck ---

eval $(thefuck --alias)
eval $(thefuck --alias fk)


eval "$(gh copilot alias -- zsh)"

set -o ignoreeof 
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/osmarjoseph/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
