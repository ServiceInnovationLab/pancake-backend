#!/bin/bash

set -euv


APP_NAME="pancake-frontend"
BRANCH="feature/deployment"

git clone https://github.com/ServiceInnovationLab/$APP_NAME.git --branch $BRANCH
cd $APP_NAME

node --version

npm install
CI=false npm run build

#rm -r public/app
mv build ../public/app

cd ..
rm -rf $APP_NAME
