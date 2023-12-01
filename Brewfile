# frozen_string_literal: true

# set arguments for all 'brew install --cask' commands
cask_args appdir: '~/Applications', require_sha: true

# 'brew install'
brew 'imagemagick'
brew 'qpdf'
brew 'ruby-build'

# install only on specified OS
brew 'tree' if OS.mac?
brew 'gnutls' if OS.mac?
brew 'gnupg' if OS.mac?
brew 'glibc' if OS.linux?

# 'brew install --cask'
# cask "google-chrome"
cask 'ngrok'
cask 'pgadmin4'
cask 'another-redis-desktop-manager'
