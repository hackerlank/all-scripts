#!/bin/bash 

wget -O taglist_44.zip  http://nchc.dl.sourceforge.net/project/vim-taglist/vim-taglist/4.4/taglist_44.zip

sudo cp plugin/taglist.vim /usr/share/vim/vim74/plugin/ 
sudo cp doc/taglist.txt /usr/share/vim/vim74/doc/

sudo yum -y install ctags
