#!/bin/bash

echo "This script returns a number of files in a specific directory and its subderictories."
read -p "Please, enter the directory's path: " DIRECTORY

FILES_NUMBER=$(ls -R $DIRECTORY | wc -l)

echo "Directory ${DIRECTORY} contains ${FILES_NUMBER} files."
