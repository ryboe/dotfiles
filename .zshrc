# ZSH OPTIONS
setopt append_history       # each session will append to ~/.zsh_history instead of replacing it
setopt extended_glob        # enable inverse globs and other glob tricks, e.g ls [^foo]bar
setopt hist_find_no_dups    # don't display dups if you find them in .zsh_history during a ctrl+r search
setopt hist_ignore_all_dups # remove older command if it's a dup of the most recent command
setopt hist_ignore_space    # don't record commands in history if they start with a space
setopt hist_reduce_blanks   # trim unnecessary whitespace
setopt hist_save_no_dups    # remove dups on save
setopt prompt_subst         # enable $(gitprompt) in prompt string (see $PROMPT)
setopt share_history        # all zsh sessions share ~/.zsh_history. makes ctrl+r searches better

# KEY BINDINGS
bindkey -v # use vim commands in the line editor

# ENV VARS
export EDITOR='code'
export FZF_ALT_C_COMMAND=" fd --type d --hidden . $HOME /usr /etc"
export FZF_CTRL_T_COMMAND="fd --type f --hidden . $HOME /usr /etc"
export HISTSIZE='10000'
export PATH="$HOME/.cargo/bin:$HOME/go/bin:$PATH"
export PROMPT='%F{cyan}${PWD/#$HOME/~}%f %F{yellow}$(gitprompt)%f '
export RPROMPT='%?'
export RUSTFLAGS='--codegen target-cpu=native'
export SAVEHIST="$HISTSIZE"

# ALIASES
alias brewup='brew update; brew upgrade; brew cleanup --prune=all'
alias cat='bat'
alias ls='exa --color=auto --group-directories-first'

# SOURCES
source "/opt/homebrew/opt/fzf/shell/completion.zsh"
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
source "$HOME/.iterm2_shell_integration.zsh"

# FUNCTIONS
seedboxls() {
	ssh seedbox -- ls "Downloads/$1"
}

seedboxdl() {
	if [[ -z $SEEDBOX_USERNAME ]]; then
		export SEEDBOX_USERNAME=$(op read op://Private/Seedbox/username)
	fi

	local filepath="$1"
	if [[ -z $filepath ]]; then
		echo "please pass the filepath of the file you want to download (relative to /home/${SEEDBOX_USERNAME}/Downloads)"
		exit 1
	fi

	# --human-readable  numbers are human readable
	# --protect-args    don't let remote shell interpret string (will split on spaces)
	# --progress        show a progress bar
	rsync --verbose --human-readable --protect-args --progress "seedbox:/home/${SEEDBOX_USERNAME}/Downloads/${filepath}" "$HOME/Downloads"
}

zle-keymap-select() {
	if [[ ${KEYMAP} == "vicmd" ]]; then
		echo -ne "\e[3 q"                # set cursor to blinking _
	elif [[ ${KEYMAP} == "main" ]]; then # main keymap is viins (INSERT mode)
		echo -ne "\e[5 q"                # set cursor to blinking |
	fi
}

zle-line-init() {
	echo -ne '\e[5 q'
}

zle -N zle-keymap-select
zle -N zle-line-init

# ENABLE COMPLETIONS
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
	compinit
	compdump
else
	compinit -C # avoid recompiling .zcompdump
fi
