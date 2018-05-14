#!/bin/bash

set -euv


APP_NAME="pancake-frontend"
BRANCH="feature/deployment"

git clone https://github.com/ServiceInnovationLab/$APP_NAME.git --branch $BRANCH
cd $APP_NAME

nvm install $(cat .nvmrc)
node --version

npm install
npm run build

rm -r public/app
mv build ../public/app

cd ..
rm -r $APP_NAME
