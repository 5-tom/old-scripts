#!/bin/bash
set -e
cd $HOME

sudo apt install -y newsboat proxychains-ng sqlite3 sqlitebrowser
ln -s $HOME/Documents/dotnewsboat $HOME/.config/newsboat
echo "alias nb1='ssh root@filmsbytom.com -D 9060'" >> .zshrc
echo "alias nb2='proxychains newsboat -x reload'" >> .zshrc
echo "alias dump='cd \$HOME/.newsboat; nbdump; sqlite3 \$HOME/.newsboat/cache.db \"update rss_item set unread = 0\"'" >> .zshrc
sed -i "s/where unread = 1/where unread = 1 and feedurl = '\\\''https:\/\/www.<>.com\/rss\/'\\\''/" $HOME/.zshrc
sudo sed -i 's/socks4/#socks4/' /etc/proxychains4.conf
echo "socks5	127.0.0.1 9060" | sudo tee -a /etc/proxychains4.conf
