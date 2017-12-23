#! /usr/bin/env bash
set -e
###########################################################################
#
# Sublime Bootstrap Installer
# https://github.com/polymimetic/ansible-role-sublime
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/ansible-role-sublime/master/install.sh | bash
#
###########################################################################

if [ `id -u` = 0 ]; then
  printf "\033[1;31mThis script must NOT be run as root\033[0m\n" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/polymimetic/ansible-role-sublime.git"
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/ansible-role-sublime/master"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";     }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";     }      # green
function e_info()    { echo -e "\033[1;34m$@\033[0m";        }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m"; }      # magenta

###########################################################################
# Install Sublime
# https://www.sublimetext.com
#
# https://www.sublimetext.com/docs/3/linux_repositories.html
###########################################################################

install_sublime() {
  e_title "Installing Sublime"

  local sublime_files="${SCRIPT_PATH}/files/sublime-text"

  # Install sublime dependencies
  sudo apt-get install -yq apt-transport-https

  # Install sublime text
  if ! subl --version >/dev/null 2>&1; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install -yq sublime-text
  fi

  # Install Package Control
  if [[ ! -d "${HOME}/.config/sublime-text-3/Installed Packages" ]]; then
    mkdir -p "${HOME}/.config/sublime-text-3/Installed Packages"
  fi

  curl -L 'https://packagecontrol.io/Package%20Control.sublime-package' > "${HOME}/.config/sublime-text-3/Installed Packages/Package Control.sublime-package"

  # Install User Preferences
  if [[ ! -d "${HOME}/.config/sublime-text-3/Packages/User" ]]; then
    mkdir -p "${HOME}/.config/sublime-text-3/Packages/User"
  fi

  cp "${sublime_files}/Package Control.sublime-settings" "${HOME}/.config/sublime-text-3/Packages/User"
  cp "${sublime_files}/Preferences.sublime-settings" "${HOME}/.config/sublime-text-3/Packages/User"
  cp "${sublime_files}/Default.sublime-mousemap" "${HOME}/.config/sublime-text-3/Packages/User"

  # Install license file
  if [[ ! -d "${HOME}/.config/sublime-text-3/Local" ]]; then
    mkdir -p "${HOME}/.config/sublime-text-3/Local"
  fi

  cp "${sublime_files}/License.sublime_license" "${HOME}/.config/sublime-text-3/Local"

  # Test sublime installation
  test_version "subl --version" "Sublime Text"

  e_success "Sublime installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_sublime
}

program_start