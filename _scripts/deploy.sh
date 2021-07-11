#!/usr/bin/bash

./node_modules/.bin/hexo clean
./node_modules/.bin/hexo build
cd public
git init .
git branch main
git checkout main
git add .
git commit -m "update github pages"
git push origin main:gh-pages
