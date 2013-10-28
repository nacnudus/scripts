# Create a new github repository called, for the sake of these instructions, ruhoh-site.  Don't create a readme or anything.

```
mkdir ruhoh-site
cd ruhoh-site
touch Gemfile
echo "source \"https://rubygems.org\"" >> Gemfile
echo "gem 'ruhoh', \"~> 2\"" >> Gemfile
bundle install
git clone https://github.com/ruhoh/theme-bootstrap-2.git theme-bootstrap-2
```

Create config.yml in ruhoh-site directory with these lines:

```
"theme-bootstrap-2" :
  "use" : "theme"
```
Make it a git directory:

```
cd ..
git init
git remote add origin https://github.com/nacnudus/ruhoh-site
git add .
git commit -m "Initial commit"
```

Publish to github:

```
ruhoh compile
cd compiled
git init
git add .
git commit -m "Initial github publication."
git push https://github.com/nacnudus/ruhoh-site.git master:gh-pages --force
rm -rf .git
```

Gitignore the compile directory and Gemfile.lock:

```
cd ..
echo "compiled" >> .gitignore
echo "*.lock" >> .gitignore
```
