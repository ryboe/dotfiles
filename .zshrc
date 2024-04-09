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

# HOMEBREW
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}"
export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"

# ENV VARS
export BUILDX_GIT_LABELS='full' # apply OCI labels to images built with buildx
export EDITOR='code'
export FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
export HISTSIZE='50000'
export PATH="${HOME}/.cargo/bin:${HOME}/go/bin:${HOME}/.docker/bin:${HOME}/.local/bin:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:${PATH}"
export RUSTFLAGS='--codegen target-cpu=native'
export SAVEHIST="${HISTSIZE}"
export SSH_AUTH_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# SECRETS
export BC_API_KEY='op://Private/Bridgecrew API Key/credential' # for checkov

# ALIASES
alias cat='bat'
alias checkov='op run -- checkov'
alias ls='eza --color=auto --group-directories-first'

# SOURCES
source "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc"
source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"

# FUNCTIONS
digany() {
	local domain=$1
	for record_type in A AAAA CAA CERT CNAME DNAME MX NS PTR SOA SRV TXT; do
		dig +noall +answer +multiline ${domain} ${record_type};
	done
}

up() {
	brew update
	brew upgrade --greedy
	pip list --outdated --format=json | jq -r '.[].name' | xargs -I {} pip3 install --upgrade {}
	if docker info &>/dev/null; then
		docker image pull moby/buildkit:buildx-stable-1
	fi
	go install mvdan.cc/gofumpt@latest
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
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
	compinit
	compdump
else
	compinit -C # avoid recompiling .zcompdump
fi
