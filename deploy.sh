#!/bin/bash
set -e

if [[ -n $(git status -s) ]]; then
  >&2 echo "Error: Working directory not clean"
  exit 1
fi

# >&2 echo "Generating glyphs"
# ./generate.sh

SHA=`git rev-parse --verify HEAD`

cp -r example example_new

git checkout gh-pages || git checkout --orphan gh-pages
rm .git/index

mv example_new example

git config user.name "Deploy bot"
git config user.email "none@example.com"

git add -f glyphs
git add -f example

if [ -n "`git diff --staged`" ]; then
  git commit -m "Deploy to GitHub Pages: ${SHA}"
  git push origin gh-pages
else
  >&2 echo "Nothing to deploy"
fi

git checkout master -f
