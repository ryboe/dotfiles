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
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install brewed utils
brew install bash curl exa fd fzf go git git-lfs htop jq python ripgrep shellcheck shfmt tree zsh

# load shell config
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.zshrc >"$HOME/.zshrc"

# shellcheck source=/Users/ryan/.zshrc
source ~/.zshrc

# install rust
if [[ ! -x "$(command -v rustup)" ]]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	rustup toolchain install stable
fi

# fetch configs from y0ssar1an/dotfiles
curl --retry 3 --retry-delay 0 --retry-max-time 30 --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/git/config >"$HOME/.config/git/config"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/git/ignore >"$HOME/.config/git/ignore"
curl --retry 3 --retry-delay 0 --retry-max-time 30 --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.ssh/config >"$HOME/.ssh/config"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.CFUserTextEncoding >"$HOME/.CFUserTextEncoding"

# install CLI utils
mkdir ~/{bin,rs}
cargo install --git https://github.com/y0ssar1an/gitprompt
cargo install --git https://github.com/y0ssar1an/update-shell-utils

echo '
now install these:
  appcleaner
  code
  etcher
  firefox
  IINA
  imageoptim
  iterm2
  rectangle
  the unarchiver
  qbittorrent
'
