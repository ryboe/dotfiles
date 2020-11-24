#!/bin/zsh
set -euo pipefail

# Install MacOS software updates
softwareupdate -iar

# Install brew
if ! command -v brew; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install brewed utils
rm -f Brewfile.lock.json
brew bundle install

# Create new SSH key
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
	echo "We'll need a password for the SSH key we're about to generate."
	echo "Please install 1Password before continuing."
	vared -p 'Press [return] when your SSH key password is generated in 1Password: '
	ssh-keygen -t ed25519
	ssh-add -K ~/.ssh/id_ed25519
fi

# Load shell config
curl -sSL --retry 3 --max-time 10 --output ~/.zshrc https://raw.githubusercontent.com/ryboe/dotfiles/master/.zshrc

# Reduce permissions on zsh dirs to avoid warning from compaudit
chmod go-w /usr/local/share/zsh /usr/local/share/zsh/site-functions
source ~/.zshrc

# Install rust.
if ! command -v rustup; then
	rustup-init
fi
rustup toolchain install stable

# Fetch configs from ryboe/dotfiles
curl -ssL --retry 3 --max-time 10 --create-dirs --output ~/.config/git/config https://raw.githubusercontent.com/ryboe/dotfiles/master/.config/git/config
curl -sSL --retry 3 --max-time 10 --output ~/.config/git/ignore https://raw.githubusercontent.com/ryboe/dotfiles/master/.config/git/ignore
curl -sSL --retry 3 --max-time 10 --create-dirs --output ~/.ssh/config https://raw.githubusercontent.com/ryboe/dotfiles/master/.ssh/config
rm -f ~/.CFUserTextEncoding
curl -sSL --retry 3 --max-time 10 --output ~/.CFUserTextEncoding https://raw.githubusercontent.com/ryboe/dotfiles/master/.CFUserTextEncoding

# Install homemade CLI utils
mkdir -p ~/{go,py,rs}
cargo install --git https://github.com/ryboe/gitprompt
cargo install --git https://github.com/ryboe/update-shell-utils

# Download bypass-paywalls-chrome. This will not install it.
rm -rf ~/Applications/bypass-paywalls-chrome-master
curl -sSL --retry 3 --max-time 30 https://github.com/iamadamdev/bypass-paywalls-chrome/archive/master.zip | tar -xzf - -C ~/Applications/

# Enable docker completions. These symlinks will be broken until docker is installed.
ln -sf /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion /usr/local/share/zsh/site-functions/_docker
ln -sf /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion /usr/local/share/zsh/site-functions/_docker-compose

echo '
now install these:
  1password
  adguard
  amphetamine
  appcleaner
  bypass-paywalls-chrome
  chrome
  code
  discord
  docker
  dropbox
  folx
  IINA
  imageoptim
  iterm2
  rectangle
  the unarchiver
  zoom
'
