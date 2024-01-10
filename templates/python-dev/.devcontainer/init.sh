#!/bin/bash
set -e

logfile="/.devcontainer/init.log"
echo "Booting up project $PROJECT_NAME" > $logfile

# Install dependencies
pip install --no-cache-dir -r requirements.txt

chown -R $USER:$USER /app

echo "Finished booting up project $PROJECT_NAME" >> $logfile

sleep infinity