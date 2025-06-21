@echo off
SET /P repo_url=Enter your GitHub repository URL: 

:: Initialize git repository
git init

:: Create .gitignore file
echo build/ > .gitignore
echo .dart_tool/ >> .gitignore
echo .idea/ >> .gitignore
echo .packages >> .gitignore
echo .flutter-plugins >> .gitignore
echo .flutter-plugins-dependencies >> .gitignore

:: Add all files to git
git add .

:: Commit the changes
git commit -m "Initial commit"

:: Add remote repository
git remote add origin %repo_url%

:: Push the changes
git push -u origin master
