FROM archlinux:latest

RUN pacman -Sy

RUN pacman --noconfirm -S git neovim go npm gcc

WORKDIR /root

COPY . .config/nvim

ENV XDG_CONFIG_HOME .config

CMD tail -f /dev/null

