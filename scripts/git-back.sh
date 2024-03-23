RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check for git repo
if [ -d ".git" ] || git rev-parse --git-dir > /dev/null 2>&1
then
    : # pass
else
    echo -e "${RED}FATAL:${NC} Not a git repository"
    exit 1
fi

# Check for branch head
if git symbolic-ref -q HEAD > /dev/null 2>&1
then
    : # pass
else
    echo -e "${RED}FATAL:${NC} Not a branch head"
    exit 1
fi

git_backup(){
    # Store info about the current state
    old_branch=$(git rev-parse --abbrev-ref HEAD)
    latest_commit_message=$(git log -1 --pretty=%B)
    latest_commit_hash=$(git rev-parse HEAD)

    # Compute info about the new state
    new_branch="backup/${old_branch}/$(date +%s%N)"
    new_commit_message="Backup atop ${latest_commit_hash} at $(date)"

    # Create the backup
    git reset
    git checkout -b $new_branch
    git add .
    git commit -m "$new_commit_message"
    new_commit_hash=$(git rev-parse HEAD)

    # Revert working state to pre-backup state
    git checkout $old_branch
    git cherry-pick -n $new_branch
    git reset
}

git_backup >> /dev/null 2>&1
echo -e "${GREEN}Success${NC}"
echo "Created backup of working state"
echo "  at ${new_commit_hash:0:7} in ${new_branch}"
echo "  atop ${latest_commit_hash:0:7} on ${old_branch}"