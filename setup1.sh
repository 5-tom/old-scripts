#!/usr/bin/env bash
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
#	location /webhook {
#		proxy_pass http://localhost:5000 ;
#		limit_except POST {
#			deny all ;
#		}
#	}
	location = /gb/ {
		include fastcgi_params ;
		fastcgi_param SCRIPT_FILENAME /var/www/gb/signatures ;
		fastcgi_pass unix:/run/fcgiwrap.socket ;
	}
	location = /gb/writesigs.sh {
		include fastcgi_params ;
		fastcgi_param SCRIPT_FILENAME /var/www/gb/writesigs.sh ;
		fastcgi_param QUERY_STRING $query_string ;
		fastcgi_pass unix:/run/fcgiwrap.socket ;
		gzip off ;
	}
	location ~^/gb/(.+)$ {
		root /var/www ;
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
ln -s /etc/nginx/sites-available/gotify /etc/nginx/sites-enabled
sed -i 's/# server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf
#uncomment cert lines
#systemctl reload nginx
mkdir /var/www/filmsbytom /var/www/gb
#/var/www/stripe
cp /var/www/html/index.nginx-debian.html /var/www/filmsbytom/

apt install fcgiwrap git
cd /var/www/gb
apt install libgd-dev recode
git clone https://github.com/flauntbot/captcha-gd
cd captcha-gd
apt install gcc make
make
chown www-data:www-data captcha-gd
mv captcha-gd /usr/local/bin/captcha
#push dir gb to web server using rsync
#chmod +x signatures
#chmod +x writesigs.sh
#chown -R www-data:www-data /var/www/gb

apt install curl newsboat sqlite3
