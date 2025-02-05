#!/bin/sh

# Navigate to the Git repository directory
cd /var/mobile/qhtx

# Add all changes to the staging area
git add --all

# Commit the changes with a message "Init"
git commit -m "Init"

# Push the changes to the remote repository
git push

# Print a message indicating the process is complete
echo "Changes have been added, committed, and pushed successfully!"