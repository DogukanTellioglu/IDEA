#!/bin/bash

# Check if the user provided a GitHub repository URL
if [ -z "$1" ]
then
  echo "Kullanım: ./upload_to_github.sh <GitHub Repository URL>"
  exit 1
fi

# GitHub repository URL
REPO_URL=$1

# Initialize git repository
git init

# Create .gitignore file for Flutter projects
echo "build/
.dart_tool/
.idea/
.packages
.flutter-plugins
.flutter-plugins-dependencies" > .gitignore

# Add all files to git
git add .

# Commit the changes
git commit -m 'İlk commit'

# Add remote repository
git remote add origin $REPO_URL

# Push the changes to GitHub
git push -u origin master

echo "Proje başarıyla GitHub'a yüklendi."
