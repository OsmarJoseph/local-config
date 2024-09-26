alias n='nvim'
alias vim='nvim'
alias G='git'
alias nrg='nrg_function() {

selected_file=$(rg $1 -l ~/Repos | fzf --preview "bat -n --color=always --line-range :500 {}") 

if [ -n "$selected_file" ]; then
    nvim "$selected_file"
fi
}

nrg_function'

alias nf='nf_function() {

selected_file=$(find ~/Repos -maxdepth 5 -path "*$1*" -type d ! -path "*/node_modules/*" ! -path "*/.git/*" | fzf)

if [ -n "$selected_file" ]; then
    cd "$selected_file"
    nvim "$selected_file"
fi
}

nf_function'


alias nfc='nfc_function() {

selected_file=$(find ~/Repos -maxdepth 5 -path "*$1*" -type d ! -path "*/node_modules/*" ! -path "*/.git/*" | fzf)

if [ -n "$selected_file" ]; then
    cd "$selected_file"
fi
}

nfc_function'
