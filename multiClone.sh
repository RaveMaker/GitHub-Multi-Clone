#!/bin/sh

# Clone all User or Organization repositories from GitHub
#
# by RaveMaker - http://ravemaker.net
#
# GitHub Limitations:
# For unauthenticated requests, the rate limit allows you to make up to 60 requests per hour.

# Settings
REPOSNUM="10" # How many repos do you have on this account
DESTFOLDER="/MyGitRepositories/" # Where to Clone
USERORG="1/2" # Select mode - User=1 Organization=2
GITNAME="User/Organization Name" # User or Organization Name from GitHub url

# CONST
REPOSLIST="repos-list.txt"
GITURLUSER="https://api.github.com/users/"
GITURLORG="https://api.github.com/orgs/"

# User mode or Org Mode
if [ $USERORG=="1" ]
then
    GITTOCLONE=$GITURLUSER$GITNAME
elif [ $USERORG=="2" ]
then
    GITTOCLONE=$GITURLORG$GITNAME
else
    echo "Please select mode"
    exit;
fi

# Create repos list and destination folder
mkdir $DESTFOLDER
cd $DESTFOLDER
echo > $REPOSLIST
echo > $REPOSLIST.2

# Get repos from GitHub
COUNT=`echo $(( $REPOSNUM / 30 ))`
let "COUNT += 1"
COUNTER=1
while [  $COUNTER -le $COUNT ]; do
    wget $GITTOCLONE/repos?page=$COUNTER
    cat repos?page=$COUNTER | grep git_url >> $REPOSLIST.2
    rm -f repos?page=$COUNTER
    let "COUNTER += 1"
done

# Cut repos list to URLs only

cat $REPOSLIST.2 | sed 's/"git_url": "//' | sed 's/",//' | sed '/^$/d' | sed 's/git:\/\/github.com\///' > $REPOSLIST
rm -f $REPOSLIST.2

# Clone GitHub repositories from URLs list file
for REPO in `cat $REPOSLIST`
do
   SSHREPO="git@github.com:"$REPO
   git clone $SSHREPO
   echo "#########################################"
   echo $SSHREPO
   echo "#########################################"
done
echo ""
echo $GITNAME " repositories count:"
wc -l $REPOSLIST
echo ""
