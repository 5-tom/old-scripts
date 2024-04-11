#!/bin/bash
set -e
cd $HOME

sudo apt install -y taskwarrior
ln -s $HOME/Documents/dottask $HOME/.config/task
echo "data.location=/home/tom/.config/task" >> $HOME/.taskrc
echo "dateformat=D-M-y" >> $HOME/.taskrc
echo "color.tag.WHENPAID=white underline on blue" >> $HOME/.taskrc
