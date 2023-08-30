#!/bin/bash
set -e

logfile="/.devcontainer/init.log"
echo "Booting up project $PROJECT_NAME" > $logfile

if [ ! -f "go.mod" ]; then
    echo "Initializing go module for $PROJECT_NAME" >> $logfile
    go mod init $PROJECT_NAME
    go mod tidy
fi

echo "Finished booting up project $PROJECT_NAME" >> $logfile

sleep infinity