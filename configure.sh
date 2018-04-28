#!/usr/bin/env bash

set -euo pipefail

# install MacOS software updates
sudo softwareupdate -ia

# install brew
if [[ ! -x "$(command -v brew)" ]]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install brewed utils
brew install bash coreutils curl fzf go neovim python shellcheck shfmt tree
brew install findutils --with-default-names
brew install git --with-curl --with-pcre2
brew install zsh --with-pcre --with-unicode9

# install vim-plug
curl --create-dirs -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install rustup
if [[ ! -x "$(command -v rustup)" ]]; then
	curl https://sh.rustup.rs -sSf | sh
	rustup toolchain install stable
fi

# install fzf keybindings and fuzzy completions
/usr/local/opt/fzf/install

# fetch configs from y0ssar1an/dotfiles
curl --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/git/config >"$HOME/.config/git/config"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/git/ignore >"$HOME/.config/git/ignore"
curl --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/nvim/colors/solarized.vim >"$HOME/.config/nvim/colors/solarized.vim"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.config/nvim/init.vim >"$HOME/.config/nvim/init.vim"
curl --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.ssh/config >"$HOME/.ssh/config"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.CFUserTextEncoding >"$HOME/.CFUserTextEncoding"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/.zshrc >"$HOME/.zshrc"

# create new SSH key
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
	ssh-keygen -t ed25519
	ssh-add -K ~/.ssh/id_ed25519
fi

# fetch sublime configs
curl --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/errfat.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/errfat.sublime-snippet"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/errfatf.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/errfatf.sublime-snippet"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/errnil.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/errnil.sublime-snippet"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/fclose.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/fclose.sublime-snippet"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/qq.sublime-snippet >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/qq.sublime-snippet"
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/Preferences.sublime-settings >"$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
curl --create-dirs -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/sublime/GoSublime.sublime-settings >"$HOME/Library/Application Support/Sublime Text 3/Packages/GoSublime/GoSublime.sublime-settings"

# start/enable local godoc service
curl -sL https://raw.githubusercontent.com/y0ssar1an/dotfiles/master/local.godoc.plist >"$HOME/Library/LaunchAgents/local.godoc.plist"
sudo chown root:wheel "$HOME/Library/LaunchAgents/local.godoc.plist"
sudo launchctl load -w "$HOME/Library/LaunchAgents/local.godoc.plist"

# install go utils
mkdir ~/go/{bin,pkg,src}
go get -u github.com/y0ssar1an/gitprompt
go get -u github.com/y0ssar1an/update-shell-utils
go get -u -d github.com/magefile/mage
cd "$HOME/go/src/github.com/magefile/mage"
go run bootstrap.go

echo '
now install these:
  amphetamine
  appcleaner
  chrome
  docker for mac
  dropbox
  IINA
  image optim
  iterm2 beta (enable metal rendered)
  spectacle
  sublime text dev
  the unarchiver
  transmission
'
