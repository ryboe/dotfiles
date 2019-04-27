#!/usr/bin/env bash

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
brew install bash curl exa fd fzf go git git-lfs python ripgrep shellcheck shfmt tree zsh

# load shell config
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.zshrc >"$HOME/.zshrc"
source ~/.zshrc

# install rust
if [[ ! -x "$(command -v rustup)" ]]; then
	curl https://sh.rustup.rs -sSf | sh
	rustup toolchain install stable
fi

# fetch configs from y0ssar1an/dotfiles
curl --retry 3 --retry-delay 0 --retry-max-time 30 --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/git/config >"$HOME/.config/git/config"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/git/ignore >"$HOME/.config/git/ignore"
curl --retry 3 --retry-delay 0 --retry-max-time 30 --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.ssh/config >"$HOME/.ssh/config"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.CFUserTextEncoding >"$HOME/.CFUserTextEncoding"

# fetch sublime configs
curl --retry 3 --retry-delay 0 --retry-max-time 30 --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/errfat.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/errfat.sublime-snippet"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/errfatf.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/errfatf.sublime-snippet"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/errnil.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/errnil.sublime-snippet"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/fclose.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/fclose.sublime-snippet"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/qq.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/qq.sublime-snippet"
curl --retry 3 --retry-delay 0 --retry-max-time 30 -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/Preferences.sublime-settings >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"

# install CLI utils
mkdir ~/{bin,go,rs}
cd rs
git clone https://github.com/y0ssar1an/gitprompt
git clone https://github.com/y0ssar1an/update-shell-utils
cd gitprompt
cargo install
cd ../update-shell-utils
cargo install
cd

echo '
now install these:
  amphetamine
  appcleaner
  chrome
  docker for mac
  dropbox
  IINA
  image optim
  iterm2
  spectacle
  sublime text
  the unarchiver
  qbittorrent
'
