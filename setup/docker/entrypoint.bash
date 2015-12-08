#!/bin/bash
cd /srv/enketo-express
python setup/docker/create_config.py
npm start
