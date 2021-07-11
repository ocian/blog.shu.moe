#!/usr/bin/bash

./node_modules/.bin/hexo clean
./node_modules/.bin/hexo generate
echo "blog.shu.moe" > public/CNAME
cd public
git init .
git remote add origin https://ocian@github.com/ocian/blog.shu.moe.git
git branch main
git checkout main
git add .
git commit -m "update github pages"
git push origin main:gh-pages -f
