alias n='nvim'
alias vim='nvim'
alias G='git'

alias fw='fw_function() {

selected_file=$(rg $1 -l ~/Repos | fzf --preview "bat -n --color=always --line-range :500 {}") 

if [ -n "$selected_file" ]; then
    nvim "$selected_file"
fi
}

fw_function'