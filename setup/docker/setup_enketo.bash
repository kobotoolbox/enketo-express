#!/bin/bash
set -e

cd ${ENKETO_SRC_DIR}/

# Create a config. file if necessary.
python setup/docker/create_config.py

# Build.
grunt
