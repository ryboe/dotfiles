# ZSH OPTIONS
setopt append_history
setopt extended_glob
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt prompt_subst
setopt share_history

# KEY BINDINGS
bindkey -v

# ENV VARS
export EDITOR='code'
export FZF_ALT_C_COMMAND=" fd --type d --hidden . $HOME /usr /etc"
export FZF_CTRL_T_COMMAND="fd --type f --hidden . $HOME /usr /etc"
export HISTSIZE='10000'
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$PATH"
export PROMPT='%F{cyan}%B%40<..<%3~%b%f$(gitprompt) '
export RPROMPT="%?"
export RUSTFLAGS='--codegen target-cpu=native'
export SAVEHIST="$HISTSIZE"

# ALIASES
alias cat="bat"
alias ls="exa --color=auto --group-directories-first"
alias python="python3"

# SOURCES
source "/usr/local/opt/fzf/shell/completion.zsh"
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

# EVALS
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# FUNCTIONS
zle-keymap-select() {
	if [[ ${KEYMAP} == "vicmd" ]]; then
		echo -ne "\e[3 q"                # set cursor to blinking _
	elif [[ ${KEYMAP} == "main" ]]; then # main keymap is viins (INSERT mode)
		echo -ne "\e[5 q"                # set cursor to blinking |
	fi
}

zle -N zle-keymap-select

# ENABLE COMPLETIONS
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
	compinit
else
	compinit -C # avoid recompiling .zcompdump
fi
