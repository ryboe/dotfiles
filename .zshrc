#!/usr/local/bin/zsh

# ZSH OPTIONS
setopt extended_glob
setopt prompt_subst

# KEY BINDINGS
bindkey -v

# ENV VARS
export EDITOR="nvim"
export FPATH="${HOME}/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/zsh/site-functions:${FPATH}"
export FZF_DEFAULT_OPTS='
  --color=bg+:#073642,bg:#002b36,spinner:#719e07,hl:#586e75
  --color=fg:#839496,header:#586e75,info:#cb4b16,pointer:#719e07
  --color=marker:#719e07,fg+:#839496,prompt:#719e07,hl+:#719e07
'
export FZF_ALT_C_COMMAND="mdfind 'kind:folder'"
export FZF_CTRL_T_COMMAND="rg --files ${HOME} /etc /usr"
export HISTFILE="${HOME}/.histfile"
export HISTSIZE=1000
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/opt/findutils/libexec/gnuman:${MANPATH}"
export PATH="${HOME}/go/bin:${HOME}/.cargo/bin:/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
export PROMPT='%F{cyan}%B%40<..<%3~%b%f$(gitprompt) '
export RPROMPT="%?"
export SAVEHIST=1000
export VISUAL="${EDITOR}"

# ALIASES
alias ls="ls --color=auto --group-directories-first"

# SOURCES
source "/usr/local/opt/fzf/shell/completion.zsh"
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

# FUNCTIONS
cdl() {
	cd "$1" || exit
	ls
}

qq() {
	clear
	"${HOME}/go/src/github.com/y0ssar1an/q/q.sh"
}

rmqq() {
	if [[ -f "${TMPDIR}/q" ]]; then
		rm "${TMPDIR}/q"
	fi
	qq
}

zle-keymap-select zle-line-init() {
	if [[ "${KEYMAP}" == "vicmd" ]]; then
		echo -ne "\e[4 q"					# '\e[4 q' sets cursor to _
	elif [[ "${KEYMAP}" == "main" ]]; then  # main keymap is viins (INSERT mode)
		echo -ne "\e[6 q"					# '\e[6 q' sets cursor to |
	fi
}
zle -N zle-keymap-select
zle -N zle-line-init
