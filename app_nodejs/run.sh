#!/bin/sh

#------------------
# VARIABLES
#------------------
SERVICE_DIR_BASE=/home/node/app

#------------------
# MAIN
#------------------

cd "$SERVICE_DIR_BASE" || exit 1
exec /usr/local/bin/node app.js
