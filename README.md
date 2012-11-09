Installation pre-requisites
===========================
* vim (duh)
* python
* ruby
* exuberant ctags


Interesting remaps
==================
* leaderkey is ,
* <leaderkey>o : toggle TabList
* <leaderkey>f : start Command-T search 
* <leaderkey>n : toggle nerdtree 


Installation of vim rcs
=======================
Somewhere where you keep your code::

    git clone https://ali@bitbucket.org/ali/dotfiles.git
    cd dotfiles 
    ./install.sh vim

Installation of other rcs (though, im not sure why you'd want to)
=================================================================
The install.sh script basically updated the submodules and then symlinks the appropriate rc file into your $HOME directory.
The mapping is basically::

    ./install.sh foo # foo will symlink _foo to ~/.foo 

Therefore::

    ./install.sh hgrc 
    ./install.sh zshrc 
    ./install.sh gitconfig 

etc..
