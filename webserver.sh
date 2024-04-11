#!/usr/bin/env bash
#ssh-copy-id -i ./id_rsa.pub root@filmsbytom.com
set -e

localectl set-locale LANG=en_GB.UTF-8
apt update
apt upgrade
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
systemctl reload sshd
apt install nginx

while read
do
	printf '%s\n' "$REPLY"
done <<'EOF' > /etc/nginx/sites-available/filmsbytom
server {
	server_name filmsbytom.com ;
	root /var/www/filmsbytom ;
	index index.html index.htm index.nginx-debian.html ;
	location / {
		try_files $uri $uri/ =404 ;
	}
	location /kodi {
		autoindex on ;
		alias /var/www/kodi/ ;
		#auth_basic "" ;
		#auth_basic_user_file /etc/nginx/myusers ;
	}
#	listen [::]:443 ssl ipv6only=on ;
#	listen 443 ssl ;
#	ssl_certificate /etc/letsencrypt/live/filmsbytom.com/fullchain.pem ;
#	ssl_certificate_key /etc/letsencrypt/live/filmsbytom.com/privkey.pem ;
#	include /etc/letsencrypt/options-ssl-nginx.conf ;
#	ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem ;
}
EOF

while read
do
	printf '%s\n' "$REPLY"
done <<'EOF' > /etc/nginx/sites-available/default
#ssl_certificate /etc/letsencrypt/live/filmsbytom.com/fullchain.pem ;
#ssl_certificate_key /etc/letsencrypt/live/filmsbytom.com/privkey.pem ;
server {
	listen 80 ;
	listen [::]:80 ;
#	listen 443 ssl ;
	server_name ~^(www\.)?(?<domain>.+)$ ;
	return 301 https://$domain$request_uri ;
}
EOF

echo "#rtmp {
#	server {
#		listen 1935;
#		chunk_size 4096;
#		allow publish YOUR_PUBLIC_IP;
#		allow play YOUR_PUBLIC_IP;
#		deny play all;
#		deny publish all;

#		application live {
#			live on;
#			record off;
#		}
#	}
#}" >> /etc/nginx/nginx.conf

apt install ufw
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable

apt install python3-certbot-nginx
#put filmsbytom.com here:
certbot certonly --nginx --register-unsafely-without-email
certbot certonly --nginx --register-unsafely-without-email --expand -d filmsbytom.com,www.filmsbytom.com
#default is already linked
ln -s /etc/nginx/sites-available/filmsbytom /etc/nginx/sites-enabled
sed -i 's/# server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf
#uncomment cert lines
#systemctl reload nginx
mkdir /var/www/filmsbytom /var/www/kodi
cp /var/www/html/index.nginx-debian.html /var/www/filmsbytom/
