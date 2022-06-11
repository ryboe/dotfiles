#!/usr/bin/env zsh
set -euo pipefail

bail_if_email_not_set() {
	if [[ -z $EMAIL ]]; then
		echo 'Please set $EMAIL to your email address and try again.'
		exit 1
	fi
}

bail_if_op_env_vars_not_set() {
	if [[ -z $OP_SECRET_KEY ]]; then
		echo 'Please set $OP_SECRET_KEY and try again.'
		echo 'The secret key is 40 uppercase alphanumeric characters and hyphens.'
		exit 1
	fi

	if [[ -z $OP_MASTER_PASSWORD ]]; then
		echo 'Please set $OP_MASTER_PASSWORD and try again.'
		exit 1
	fi
}

update_macos() {
	# Install MacOS software updates
	softwareupdate -iar

	# Install command line tools
	if ! command -v clang; then
		xcode-select --install
	fi
}

install_brew_pkgs() {
	# Install brew
	if ! command -v brew; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	else
		brew update
	fi

	brew bundle install --no-lock
}

enable_docker_completions() {
	ln -sf /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion /opt/homebrew/share/zsh/site-functions/_docker
}

log_in_to_1password() {
	if ! op whoami &>/dev/null; then
		if ! eval $(echo $OP_MASTER_PASSWORD | op account add --address=boehning.1password.com --email=$EMAIL --secret-key=$OP_SECRET_KEY --signin); then
			echo 'Invalid $OP_MASTER_PASSWORD or $OP_SECRET_KEY'
			exit 1
		fi
	fi
}

github_cli_login() {
	if ! gh auth status; then
		local GITHUB_PAT=$(op item get GitHub --fields=commandline.personalaccesstoken)
		echo $GITHUB_PAT | gh auth login --git-protocol=https --with-token
	fi
}

# create_ssh_key_if_necessary() {
# 	# Create this directory so multiple SSH sessions can share a single
# 	# connection.
# 	mkdir -p ~/.ssh/sockets

#   op signin
# 	# TODO: creating an SSH key using op currently isn't possible
# 	MACBOOK_MODEL="$(sysctl -n hw.model)"
# 	op item create --category=sshkey --title="$MACBOOK_MODEL SSH Key" --generate-password=20,letters,digits 'Key Type=ed25519'
# }

fetch_dotfiles() {
	# Clone all the dotfiles
	rm -rf /tmp/dotfiles
	git clone --depth 1 https://github.com/ryboe/dotfiles.git /tmp

	# Fetch configs from ryboe/dotfiles
	if [[ ! -d ~/.config ]]; then
		cp -R /tmp/.config "$HOME"
	fi

	if [[ ! -f ~/.config/git/config ]]; then
		cp /tmp/.config/git/config ~/.config/git/config
	fi

	if [[ ! -f ~/.config/git/ignore ]]; then
		cp /tmp/.config/git/ignore ~/.config/git/ignore
	fi

	if [[ ! -f ~/.ssh/config ]]; then
		cp /tmp/.ssh/config ~/.ssh/config
	fi

	if [[ ! -f ~/.CFUserTextEncoding ]]; then
		cp /tmp/.CFUserTextEncoding ~/.CFUserTextEncoding
	fi
}

add_seedbox_to_ssh_config() {
	if ! rg --fixed-strings 'Host seedbox' ~/.ssh/config; then
		local SEEDBOX_JSON=$(op item get Seedbox --format=json)
		local SEEDBOX_HOST=$(echo $SEEDBOX_JSON | jq -r '.urls[] | select(.primary == true).href')
		local SEEDBOX_USERNAME=$(echo $SEEDBOX_JSON | jq -r '.fields[] | select(.id == "username").value')
		echo '' >>~/.ssh/config
		echo 'Host seedbox' >>~/.ssh/config
		echo "	HostName $SEEDBOX_HOST" >>~/.ssh/config
		echo "	User $SEEDBOX_USERNAME" >>~/.ssh/config
	fi
}

install_rust() {
	if ! command -v rustup; then
		rustup-init
		rustup toolchain install stable
	else
		rustup update
	fi
}

reduce_permissions_on_zsh_dirs() {
	# Avoid warning from compaudit
	chmod go-w /opt/homebrew/share/zsh /opt/homebrew/share/zsh/site-functions
}

load_zsh_shell_config() {
	# Load shell config
	cp /tmp/.zshrc ~/.zshrc
	source ~/.zshrc
}

make_code_dir() {
	mkdir -p ~/code
}

install_gitprompt() {
	export RUSTFLAGS='--codegen target-cpu=native'
	cargo install --git=https://github.com/ryboe/gitprompt.git
}

set_screenshots_to_jpg() {
	# Save screenshots in ~/Downloads instead of ~/Desktop
	defaults write com.apple.screencapture location "$HOME/Screenshots"

	# JPEG screenshots
	if defaults read com.apple.screencapture type != "jpeg"; then
		defaults write com.apple.screencapture type jpeg
		killall SystemUIServer
	fi
}

download_chrome_installer() {
	# There is no brew cask for Chrome.
	curl -ssL --retry 3 --max-time 180 --progress -O https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
}

download_bypass_paywalls_chrome() {
	# This will download and extract it, not install it.
	rm -rf ~/Applications/bypass-paywalls-chrome-master
	curl -sSL --retry 3 --max-time 30 https://github.com/iamadamdev/bypass-paywalls-chrome/archive/master.zip | tar -xzf - -C ~/Applications/
}

main() {
	bail_if_email_not_set

	bail_if_op_env_vars_not_set

	update_macos

	install_brew_pkgs

	enable_docker_completions

	log_in_to_1password

	# TODO: enable this when SSH keys can be created through the 1password CLI
	# create_ssh_key_if_necessary

	github_cli_login

	fetch_dotfiles

	add_seedbox_to_ssh_config

	install_rust

	make_code_dir

	reduce_permissions_on_zsh_dirs

	install_gitprompt

	load_zsh_shell_config

	download_chrome_installer

	download_bypass_paywalls_chrome
}

main
