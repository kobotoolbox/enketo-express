#!/bin/bash
set -e

cd ${ENKETO_SRC_DIR}/
python setup/docker/create_config.py
grunt
npm start
