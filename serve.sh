#!/usr/bin/env bash

touch "/usr/local/etc/nginx/sites-enabled/$1"
echo "server {
    listen 80;
    server_name $1;
    root \"$2\";
    index index.html index.htm index.php;
    charset utf-8;
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }
    access_log off;
    error_log  /usr/local/var/log/nginx/$1-error.log error;
    sendfile off;
    client_max_body_size 100m;
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
    }
    location ~ /\.ht {
        deny all;
    }
}
" >> "/usr/local/etc/nginx/sites-enabled/$1"
sudo nginx -s stop
sudo nginx