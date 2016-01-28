#!/bin/bash

echo "Clearing out any default configurations."
rm -rf /etc/nginx/conf.d/*

# Check if the SSL certificate and key have been provided.
if [[ -e /tmp/secrets/ssl.crt ]] && [[ -s /tmp/secrets/ssl.crt ]] && [[ -e /tmp/secrets/ssl.key ]] && [[ -s /tmp/secrets/ssl.key ]] ; then
    echo "SSL certificate and key located. Activating HTTPS configuration."
    cp /tmp/nginx_site_https.conf /etc/nginx/conf.d/
else
    echo "No SSL certificate and key found. Activating plain HTTP configuration."
    cp /tmp/nginx_site_http.conf /etc/nginx/conf.d/
fi


nginx -g 'daemon off;' &
nginx_pid=$!
trap "echo 'SIGTERM recieved. Killing Nginx.' && kill -SIGTERM ${nginx_pid}" SIGTERM
wait "${nginx_pid}"
exit $(($? - 128 - 15)) # http://unix.stackexchange.com/questions/10231/when-does-the-system-send-a-sigterm-to-a-process#comment13523_10231
