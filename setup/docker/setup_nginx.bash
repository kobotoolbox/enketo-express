#!/bin/bash

# Clear out any pre-existing Nginx sites.
rm -rf /etc/nginx/sites-enabled/*

# Check if the SSL certificate and key have been provided.
if [[ -s /tmp/ssl.crt ]] && [[ -s /tmp/ssl.key ]] ; then
    # Use the HTTPS site configuration.
    cp /tmp/nginx_site_https.conf /etc/nginx/sites-enabled/
else
    # Use the HTTP site configuration.
    cp /tmp/nginx_site_http.conf /etc/nginx/sites-enabled/
fi

# "Reload" the Nginx service if already running.
if sv status nginx &>/dev/null ; then
    sv reload nginx
fi
