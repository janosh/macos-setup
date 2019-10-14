install_brew() {
  renew_sudo
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
}

install_brew_clis() {
  brew install zsh --without-etcdir
  # Install zsh_plugins.
  brew install
    zsh-autosuggestions \
    zsh-completions \
    zsh-history-substring-search \
    zsh-syntax-highlighting \

  # Install yarn package manager.
  brew install yarn --without-node

  # Install other CLIs.
  brew install
    rsync \
    ffmpeg \
    git \
    handbrake \
    imagemagick \
    mas \
    trash \
    rename \
    exiftool \
    aspell \
    exiftool \
    node \
}

install_brew_casks() {
  renew_sudo # to make the Caskroom on first install
  brew cask install \
    iterm2 \
    visual-studio-code \
    google-chrome \
    deckset \
    ghostscript \
    imageoptim \
    typora \
    appcleaner \
    dropbox \
    skype \
    transmission \
    vlc \
    handbrake \
    franz \
    nordvpn \
    coconutbattery \
    tuneinstructor \
    google-photos-backup-and-sync \
    alfred \
    texpad \
    miniconda \
    zotero \
    transmit \
    daisydisk \
    keka \
    # slack \
    # 1password \
    # moneymoney \
    # telegram \
}

install_mas_apps() {
  readonly local mas_apps = (
    'Magnet=441258766' \
    'Aperture=408981426' \
    'Final Cut Pro=424389933' \
    'Keynote=409183694' \
    'MoneyMoney=872698314' \
    'Slack=803453959' \
    'Affinity Designer=824171161' \
    '1Password=443987910' \
    'Gemini=463541543' \
    'PDFScanner=410968114' \
    'Pages=409201541' \
    'WeTransfer=1114922065' \
    'Yoink=457622435' \
    'Numbers=409203825' \
    'Copied=1026349850' \
    'PopClip=445189367' \
    'Telegram=747648890' \
  )

  mas signin "${mas_email}" "${mas_password}"

  for app in "${mas_apps[@]}"; do
    local app_id="${app#*=}"
    mas install "${app_id}"
  done
}

install_other_apps() {
  # install JS CLIs
  yarn global add gatsby-cli gatsby-dev-cli netlify-cli jest-cli contentful-cli eslint

  # oh my zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}