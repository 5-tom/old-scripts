## for local testing of fcgiwrap

```
sudo apt install fcgiwrap nginx

sudo nano /etc/nginx/nginx.conf
	user www-data; --becomes--> user tom;

sudo nano /etc/init.d/fcgiwrap
	FCGI_USER="www-data" --becomes--> ..."tom"
	FCGI_GROUP="www-data"  --becomes--> ..."tom"
	...
	FCGI_SOCKET_OWNER="www-data" --becomes--> ..."tom"
	FCGI_SOCKET_GROUP="www-data" --becomes--> ..."tom"

sudo nano /usr/lib/systemd/system/fcgiwrap.service
	User=www-data --becomes--> User=tom
	Group=www-data --becomes--> Group=tom
```

fcgiwrap starts as user `www-data` (see above). `www-data` doesn't have write permissions in /var, so cgi scripts inside /var cannot modify files. solution (create a home dir and grant write permissions to `www-data` inside it):

```
mkdir /home/www-data
cp /var/www/x /home/www-data/
chown -R www-data:www-data /home/www-data
```
