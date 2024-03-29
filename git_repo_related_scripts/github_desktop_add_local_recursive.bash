#!/bin/bash

# Update all git directories below current directory or specified directory

HIGHLIGHT="\e[01;34m"
NORMAL='\e[00m'

function update {

	local d="$1"

	if [ -d "$d" ]; then

		#echo "Looking for $d/.ignore"
		if [ -e "$d/.ignore" ]; then
		
			printf "%b\n" "\n${HIGHLIGHT}Ignoring $d${NORMAL}"
		
		else
		
			cd "$d" > /dev/null
			if [ -d ".git" ]; then
				
				printf "%b\n" "\n${HIGHLIGHT}Adding `pwd`$NORMAL to Github Desktop"
				github.bat `pwd`
			elif [ ! -d .svn ] && [ ! -d CVS ]; then
				scan *
			fi
			cd .. > /dev/null
		fi
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
	printf "%b\n" "${HIGHLIGHT}Scanning ${PWD}${NORMAL}"
	scan *
}

if [ "$1" == "" ]; then

	updater

else
	
	for dir in "$@"; do
		updater "$dir"
	done
fi
