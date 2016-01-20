#!/bin/bash

# Clear out any pre-existing Nginx sites.
rm -rf /etc/nginx/sites-enabled/*

# Check if the SSL certificate and key have been provided.
touch /tmp/secrets/ssl.crt /tmp/secrets/ssl.key
if [[ -s /tmp/secrets/ssl.crt ]] && [[ -s /tmp/secrets/ssl.key ]] ; then
    # Use the HTTPS site configuration.
    cp /tmp/nginx_site_https.conf /etc/nginx/sites-enabled/
else
    # Use the HTTP site configuration.
    cp /tmp/nginx_site_http.conf /etc/nginx/sites-enabled/
fi
