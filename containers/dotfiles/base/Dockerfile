FROM dotfiles:ubuntu

RUN bin/install_dependencies.sh && \
    bin/install_dotfiles.sh && \
    bin/install_powerline_fonts.sh && \
    bin/os_specific.sh
