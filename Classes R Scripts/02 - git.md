# Introduction to Git and GitHub
### Work with Git and GitHub via the command line

```
# Open terminal / Git CMD
# cd path
git config -l
# git config --global user.name "[name]"
# git config --global user.email "[email address]"
git init

# Add README.md
git status
git add README.md
git status
git commit -m "initial commit"
git commit --help

# Change README.md
git status
git diff
git commit -am "Update Readme" # Add and commit
git log --abbrev-commit
git diff commit_number HEAD # or HEAD^ HEAD

git checkout commit_number # Switch to previous commit 
# Switch and delete commits via git reset --hard
# Look at README.md
git checkout master # Switch back
git log

# Create new repository via the GitHub web interface
git remote add origin https://github.com/chkern/git-example.git
git remote -v
git push -u origin master
# Refresh GitHub page and explore commits
git pull origin master

# Change README.md again
git commit -am "Some changes again"
git push 
```