#!/bin/bash

clear

echo "Vamos a crear un nuevo VHOST"

echo ""

sleep 1

echo ; read -p "Dime dominio a añadir: " DOMINIO

cd /usr/local/etc/nginx/conf.d && touch $DOMINIO.conf

mkdir /usr/local/www/public_html/$DOMINIO

ln -s /usr/local/www/phpMyAdmin/ /usr/local/www/public_html/$DOMINIO/phpmyadmin

chown -R www:www /usr/local/www/public_html/$DOMINIO

echo ""

echo "

server {
listen 8080;
listen [::]:8080;

server_name $DOMINIO;

root /usr/local/www/public_html/$DOMINIO;
index index.php index.html;
    
    # DNS resolver - you may want to change it to some other provider,
    # e.g. OpenDNS: 208.67.222.222
    # or Google: 8.8.8.8
    # (9.9.9.9 is https://quad9.net )
    resolver                   1.1.1.1;
    # allow POSTs to static pages
    error_page                 405    =200 \$uri;
    access_log                 /var/log/nginx/$DOMINIO-access.log;
    error_log                  /var/log/nginx/$DOMINIO-error.log;

        location / {
                # This is cool because no php is touched for static content.
                # include the "\$is_args\$args" so non-default permalinks doesn't break when using query string
                try_files \$uri \$uri/ /index.php\$is_args\$args;
        }

# send expire headers
location ~* ^.+\.(ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|rss|atom|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
    access_log off; # optional
    log_not_found off; # optional
    expires max;
}

location = ^/favicon.ico {
    access_log off;
    log_not_found off;
}

# robots noise...
location = ^/robots.txt {
    log_not_found off;
    access_log off;
    allow all;
}

# block access to hidden files (.htaccess per example)
location ~ /\. { access_log off; log_not_found off; deny all; }

        location ~ [^/]\.php(/|$) {
        root	/usr/local/www/public_html/$DOMINIO;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param SCRIPT_FILENAME \$request_filename;    
        include        fastcgi_params;
        	}
}
" >> $DOMINIO.conf

echo "VHOST para $DOMINIO creado correctamente"

echo ""

echo "Reiniciando NGINX"

sleep 2

service nginx restart

service php-fpm restart

echo ""

echo "Completado"
