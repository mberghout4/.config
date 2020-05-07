cd ~/

sudo apt update
sudo apt upgrade

# Clone dot-files repository and link to /home
# {
    git clone https://github.com/mberghout4/.config ~/

    # bash
    ln -s ~/.config/bash/.bashrc ~/.bashrc
    ln -s ~/.config/bash/.bash_aliases ~/.bash_aliases
    ln -s ~/.config/bash/.bash_logout ~/.bash_logout

    # tmux
    ln -s ~/.config/tmux/.tmux.conf ~/.tmux.conf

    # VIM
    ln -s ~/.config/nvim/init.vim ~/.vimrc
# }

# Install/setup Software
# {
    # bash tools
    # {
        sudo apt install ack
        sudo apt install unzip
    # }

    # C++
    # {
        #sudo apt install g++
        sudo apt install build-essential
        sudo apt install cmake
        sudo apt install make
    # }

    # Python 3
    # {
        sudo apt install python3-dev
    # }

    # tmux
    # {
        sudo apt install tmux

        git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    # }

    # vim (Neovim)
    # {
        sudo apt install neovim

        git clone https://github.com/VundleVim/Vundle.vim ~/.config/nvim/bundle/
        nvim -c ":PluginInstall" -c ":qa"

        cd ~/.config/nvim/bundles/YouCompleteMe
        python3 install.py --clangd-completer
    # }
# }
