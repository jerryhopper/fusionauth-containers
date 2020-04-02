#!/bin/sh

cd ~/dev/inversoft/fusionauth/fusionauth-app
sb bundle --zipOnly
cd - || exit 1
cp ~/dev/inversoft/fusionauth/fusionauth-app/build/bundles/fusionauth-app-*.zip fusionauth-app.zip
docker build -t fusionauth/fusionauth-app:dev .
