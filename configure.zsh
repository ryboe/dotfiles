#!/bin/zsh
set -euo pipefail

# install MacOS software updates
sudo softwareupdate -ia

# create new SSH key
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  ssh-keygen -t ed25519
  ssh-add -K ~/.ssh/id_ed25519
fi

# install brew
if [[ ! -x "$(command -v brew)" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# install brewed utils
brew bundle install

# load shell config
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.zshrc >"$HOME/.zshrc"

# shellcheck source=/Users/ryan/.zshrc
source ~/.zshrc

# install rust
rustup toolchain install stable

# fetch configs from y0ssar1an/dotfiles
curl --retry 3 --retry-delay 0 --retry-max-time 30 --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/git/config >"$HOME/.config/git/config"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/git/ignore >"$HOME/.config/git/ignore"
curl --retry 3 --retry-delay 0 --retry-max-time 30 --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.ssh/config >"$HOME/.ssh/config"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.CFUserTextEncoding >"$HOME/.CFUserTextEncoding"

# install CLI utils
mkdir ~/rs
cargo install --git https://github.com/y0ssar1an/gitprompt
cargo install --git https://github.com/y0ssar1an/update-shell-utils

echo '
now install these:
  appcleaner
  bypass paywalls chrome
  chrome
  code
  discord
  docker
  folx
  IINA
  imageoptim
  iterm2
  rectangle
  the unarchiver
  transmission
  zoom
'
