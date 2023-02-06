#!/bin/sh

# Note:
# Description: used to bulk delete branches
# Features:
#     - dynamic verbose tool with prompts
#     - choice of local or remote deletion
# To run: if file is on desktop then run $ bash ~/Desktop/bulk_git_branches_delete.sh

# Utility functions
leavingValues=("leave" "exit" "quit" "end")

# @param $1, the input to compare against leavingValues, if true, leaves program
userWantsToLeave () {
	if [[ " ${leavingValues[*]} " =~ " $1 " ]]; then
		echo "Goodbye, have a lovely day !"
	  exit 1
	fi
}

# @param $1, the type of deletion (remote, local or both)
# @param $2, the branch name to delete
deleteBranch () {
	echo -e "deleting branch name: $input\n"
	if [ "$1" = "l" ]; then
		echo -e "Local deletion...\n"
		env -i git branch -D $2
		echo -e "✅\n\n\n"
	elif [ "$deleteOption" = "r" ]; then
		echo -e "Remote deletion...\n"
		env -i git push -d origin $2
		echo -e "✅\n\n\n"
	elif [ "$deleteOption" = "a" ]; then
		echo -e "Local deletion...\n"
		env -i git branch -D $2
		echo -e "✅\n"
		echo -e "\nRemote deletion...\n"
		env -i git push -d origin $2
		echo -e "✅\n\n\n"
	else 
		echo -e "Wrong input ❌, please select one of 'l', 'r' or 'a'\n\n"
	fi
}

echo "At any point during this process type 'leave' to quit, or use the ever-so-popular 'Ctrl-C' command"

askPermissionBeforeDeletion=false

echo -e "'1' to run in safe mode (ask before deletion), else in swift mode by typing anything\n"
read permissionMode
userWantsToLeave $permissionMode
if [ "$permissionMode" = "1" ]; then
	askPermissionBeforeDeletion=true
	echo -e "You are running in safe mode\n"
else
	echo -e "You are running in swift mode\n"
fi

while :; do
	echo -e "\nEnter the name of the branch you wish to delete\n\tAlternatively type 'list' or 'listall' for 'git branch' and 'git branch -a' respectively\n"
	read input
	userWantsToLeave $input
	if [ "$input" = "list" ]; then
		echo -e "Interactive terminal being launched to list git branches as per your request:\n"
		env -i git branch
		echo -e "\n"
	elif [ "$input" = "listall" ]; then
		echo -e "Interactive terminal being launched to list all git branches as per your request:\n"
		env -i git branch -a
		echo -e "\n"
	else
		echo -e "\n'l' for local deletion, 'r' for remote deletion or 'a' for both\n"
		read deleteOption
		if [ "$permissionMode" = "1" ]; then
			echo -e "\nBranch to delete: $input\n"
			echo -n "!! Are you sure you want to delete this branch "
			if [ "$deleteOption" = "l" ]; then
				echo -e "locally ? Type 'y', any other value will skip\n"
			elif [ "$deleteOption" = "r" ]; then
				echo -e "remotely ? Type 'y', any other value will skip\n"
			elif [ "$deleteOption" = "a" ]; then
				echo -e "locally and remotely ? Type 'y', any other value will skip\n"
			fi
			read safeModeVerification
			userWantsToLeave $safeModeVerification
			if [ "$safeModeVerification" = "y" ]; then
				deleteBranch $deleteOption $input
			fi
		else
			deleteBranch $deleteOption $input
		fi
	fi
done
