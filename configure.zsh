#!/bin/zsh
set -euo pipefail

# install MacOS software updates
softwareupdate -ia

# install brew
if ! command -v brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# install brewed utils
rm -f Brewfile.lock.json
brew bundle install

# create new SSH key
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  echo "We'll need a password for the SSH key we're about to generate."
  echo "Please install 1Password before continuing."
  vared -p 'Press [return] when your SSH key password is generated in 1Password: '
  ssh-keygen -t ed25519
  ssh-add -K ~/.ssh/id_ed25519
fi

# load shell config
curl -sSL --retry 3 --max-time 10 --output ~/.zshrc https://raw.githubusercontent.com/ryboe/dotfiles/master/.zshrc

# shellcheck source=/Users/ryan/.zshrc
chmod go-w /usr/local/share/zsh /usr/local/share/zsh/site-functions
source ~/.zshrc

# install rust
if ! command -v rustup; then
  rustup-init
fi
rustup toolchain install stable

# fetch configs from ryboe/dotfiles
curl -ssL --retry 3 --max-time 10 --create-dirs --output ~/.config/git/config https://raw.githubusercontent.com/ryboe/dotfiles/master/.config/git/config
curl -sSL --retry 3 --max-time 10 --output ~/.config/git/ignore https://raw.githubusercontent.com/ryboe/dotfiles/master/.config/git/ignore
curl -sSL --retry 3 --max-time 10 --create-dirs --output ~/.ssh/config https://raw.githubusercontent.com/ryboe/dotfiles/master/.ssh/config
rm -f ~/.CFUserTextEncoding
curl -sSL --retry 3 --max-time 10 --output ~/.CFUserTextEncoding https://raw.githubusercontent.com/ryboe/dotfiles/master/.CFUserTextEncoding

# install homemade CLI utils
mkdir -p ~/{go,py,rs}
cargo install --git https://github.com/ryboe/gitprompt
cargo install --git https://github.com/ryboe/update-shell-utils

# Download bypass paywalls chrome. This will not install it.
rm -rf ~/Applications/bypass-paywalls-chrome-master
curl -sSL --retry 3 --max-time 30 https://github.com/iamadamdev/bypass-paywalls-chrome/archive/master.zip | tar -xzf - -C ~/Applications/

echo '
now install these:
  1password
  adguard
  amphetamine
  appcleaner
  bypass paywalls chrome
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
