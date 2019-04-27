# ZSH OPTIONS
setopt extended_glob
setopt prompt_subst

# KEY BINDINGS
bindkey -v

# ENV VARS
export FZF_ALT_C_COMMAND="fd --type directory --hidden '.' ${HOME} /etc /usr /tmp /var /Applications"
export FZF_CTRL_T_COMMAND="fd --type file --hidden --exclude .git '.' ${HOME} /etc /usr /tmp /var /Applications /sbin"
export PROMPT='%F{cyan}%B%40<..<%3~%b%f$(gitprompt) '
export RPROMPT="%?"
export RUSTFLAGS='--codegen target-cpu=native'
export PATH="$HOME/bin:$HOME/.cargo/bin:$HOME/Library/Python/3.7/bin:$PATH"
export GOBIN="$HOME/bin"

# ALIASES
alias ls="exa --color=auto --group-directories-first"

# SOURCES
source "/usr/local/opt/fzf/shell/completion.zsh"
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

# FUNCTIONS
qq() {
    clear

    logpath="$TMPDIR/q"
    if [[ -z "$TMPDIR" ]]; then
        logpath="/tmp/q"
    fi

    if [[ ! -f "$logpath" ]]; then
        echo 'Q LOG' > "$logpath"
    fi

    tail -100f -- "$logpath"
}

rmqq() {
    logpath="$TMPDIR/q"
    if [[ -z "$TMPDIR" ]]; then
        logpath="/tmp/q"
    fi
    if [[ -f "$logpath" ]]; then
        rm "$logpath"
    fi
    qq
}

zle-keymap-select zle-line-init() {
    if [[ "${TERM}" == "linux" ]]; then
        if [[ "${KEYMAP}" == "vicmd" ]]; then
            echo -ne "\e[?2c"                    # '\e[?2c' sets cursor to _
        elif [[ "${KEYMAP}" == "main" ]]; then  # main keymap is viins (INSERT mode)
            echo -ne "\e[?6c"                    # '\e[?6c' sets cursor to block
        fi
        return
    fi

    if [[ "${KEYMAP}" == "vicmd" ]]; then
        echo -ne "\e[4 q"                    # '\e[4 q' sets cursor to _
    elif [[ "${KEYMAP}" == "main" ]]; then  # main keymap is viins (INSERT mode)
        echo -ne "\e[6 q"                    # '\e[6 q' sets cursor to |
    fi
}

zle -N zle-keymap-select
zle -N zle-line-init

autoload -Uz compinit
compinit
