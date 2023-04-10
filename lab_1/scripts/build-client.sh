#!/bin/bash

COMPRESSED_FILE="client-app"

#Install dependencies
echo "Installing depencencies..."
npm i

#Building the project
echo "Building the project..."
case $ENV_CONFIGURATION in
    production) ng build --configuration=$ENV_CONFIGURATION ;;
    *) npm run build ;;
esac

#Compressing all the files in one archive
cd ./dist
if [[ -f "${COMPRESSED_FILE}.zip" ]]; then
    echo "Removing the existing file ${COMPRESSED_FILE}..."
    rm "$COMPRESSED_FILE.zip"
fi
echo "Compressing all the files..."
zip -r $COMPRESSED_FILE ./app
cd ..
echo "Done..."