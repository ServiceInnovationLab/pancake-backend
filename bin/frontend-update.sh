#!/bin/bash

set -eu

APP_NAME="pancake-frontend"
BRANCH="master"

git clone https://github.com/ServiceInnovationLab/$APP_NAME.git --branch $BRANCH
cd $APP_NAME

node --version

echo "Installing npm dependencies"
npm install

# Set up config file
if [ $TRAVIS_BRANCH == "master" ]
then
  CONFIG_FILE="prod"
elif [ $TRAVIS_BRANCH == 'dev' ]
then
  CONFIG_FILE="staging"
else
  CONFIG_FILE="dev"
fi

echo "Setting config to use $CONFIG_FILE"

ln -s "config-${CONFIG_FILE}.js" "src/config.js"

CI=false npm run build

mv build ../public/app

cd ..
rm -rf $APP_NAME
