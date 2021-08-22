#!/usr/bin/env zsh
set -euo pipefail

# Install command line tools
if ! command -v clang; then
	xcode-select --install
fi

# Install MacOS software updates
softwareupdate -iar

# Install brew
if ! command -v brew; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install brewed utils
rm -f Brewfile.lock.json
brew bundle install

# Enable docker completions
ln -sf /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion /usr/local/share/zsh/site-functions/_docker
ln -sf /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion /usr/local/share/zsh/site-functions/_docker-compose

# Create new SSH key
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
	op update
	eval "$(op signin boehning ryanboehning@gmail.com)"
	MACBOOK_MODEL="$(system_profiler -json SPHardwareDataType | jq -r '.SPHardwareDataType[0].machine_model')"
	SSH_KEY_UUID="$(op create item login --vault=Private --generate-password=letters,digits,20 title="$MACBOOK_MODEL SSH Key" | jq -r '.uuid')"
	SSH_KEY_PASSWORD=$(op get item "$SSH_KEY_UUID" | jq -r '.details.fields[] | select(.designation == "password").value')
	ssh-keygen -t ed25519 -N "$SSH_KEY_PASSWORD"
	ssh-add -K ~/.ssh/id_ed25519
fi

# Clone all the dotfiles
rm -rf /tmp/dotfiles
git clone https://github.com/ryboe/dotfiles.git /tmp

# Fetch configs from ryboe/dotfiles
cp -R /tmp/.config "$HOME"
cp /tmp/.ssh/config ~/.ssh/config
cp /tmp/.CFUserTextEncoding ~/.CFUserTextEncoding

# Install rust.
if ! command -v rustup; then
	rustup-init
fi
rustup toolchain install stable

# Install homemade CLI utils
mkdir -p ~/{go,rs}
export RUSTFLAGS='--codegen target-cpu=native'
cargo install --git https://github.com/ryboe/gitprompt.git
cargo install --git https://github.com/ryboe/update-shell-utils.git

# Reduce permissions on zsh dirs to avoid warning from compaudit
chmod go-w /usr/local/share/zsh /usr/local/share/zsh/site-functions

# Load shell config
cp /tmp/.zshrc ~/.zshrc
source ~/.zshrc

# Download bypass-paywalls-chrome. This will not install it.
rm -rf ~/Applications/bypass-paywalls-chrome-master
curl -sSL --retry 3 --max-time 30 https://github.com/iamadamdev/bypass-paywalls-chrome/archive/master.zip | tar -xzf - -C ~/Applications/

# Download Chrome installer. There is no brew cask for Chrome.
curl --progress --retry 3 --max-time 180 -LO https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
