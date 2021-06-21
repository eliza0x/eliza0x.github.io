npm run build
mv dist ..
git add .
git commit
git push
git checkout master
rm -rf static
mv ../dist/* .
git add .
git commit
git push
git checkout source
