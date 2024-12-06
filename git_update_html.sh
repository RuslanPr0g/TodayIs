#!/bin/bash

TODAY=$(date +"%A, %B %d, %Y")

echo "$TODAY" > index.html

git add .
git commit -m "Update HTML with today's date: $TODAY"
git push origin master