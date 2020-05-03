#!/bin/bash

# Skips directories that contain a file called .ignore

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'
now=`date`
CURRENT_DIRECTORY=`pwd`

function update {

	local d="$1"

	if [ -d "$d" ]; then
		
		cd "$d" > /dev/null

		if [ -d ".git" ]; then

			printf "%b\n" "\n${HIGHLIGHT}Processing `pwd`$NORMAL" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			
			# TODO : Check for pulll permission
			git pull | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			
			if [[ `git status --porcelain` ]]; then
				
				# Changes
				git status | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
				printf "`pwd`\n" >> $CURRENT_DIRECTORY/git_folders_with_changes.txt
			
			# else
			
				# No changes
				
			fi
			
			# git log origin/master..HEAD
			
			# git ls-remote /url/remote/repo
			# TODO : Check for own repository
			# git add . | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			# git commit -m "$now" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			# git push | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
			
		elif [ ! -d .svn ] && [ ! -d CVS ]; then

			printf "%b\n" "\n${HIGHLIGHT}Non Git Folder : `pwd`$NORMAL" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log

			# echo "Looking for $d/.ignore"| tee -a $CURRENT_DIRECTORY/git_backup_recursive.log

			# if [ -e "$d/.ignore" ]; then

				# printf "%b\n" "\n${HIGHLIGHT}Ignoring $d${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log

			# else

				# printf "`pwd`\n" >> $CURRENT_DIRECTORY/non_git_folders.txt
				# github .
				# scan *

			# fi
			
			# TODO : Avoid Android_Studio like place holder folders
			printf "`pwd`\n" >> $CURRENT_DIRECTORY/non_git_folders.txt
			# github .
			scan *
		fi

		cd .. > /dev/nul
	fi
	#echo "Exiting update: pwd=`pwd`"
}

function scan {
	
	#echo "`pwd`"
	#echo "About to scan $*"
	for x in $*; do
		update "$x"
	done
}

function updater {
	
	if [ "$1" != "" ]; then cd "$1" > /dev/null; fi
	printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}" | tee -a $CURRENT_DIRECTORY/git_backup_recursive.log
	scan *
}

if [ "$1" == "" ]; then
	updater
else
	for dir in "$@"; do
		updater "$dir"
	done
fi