#!/bin/bash
bold=`tput bold`
normal=`tput sgr0`
if [ -z "$1" ]; then
	echo "Usage: switch.sh <branch-name> <root-dir> [\"<repo>...\"]"
	echo "<branch-name> Name of branch or tag to switch to for the specified repositories."
	echo "<root-dir>    Optional: path to the root directory where the repositories are located. If not specified, the current directory is used."
	echo "\"<repo>\"      Optional: space or comma delimited (relative) paths of repositories to change the branch/tag for. If not specified, will attempt to change the repos in the current directory."
else
	if [ -z "$2" ]; then
		root_dir=${PWD}"/"
	else
		root_dir="$2"
	fi
	if [ -z "$3" ]; then
		repo_names=(*)
	else
		IFS=', ' read -a repo_names <<< $3
	fi
	for i in ${repo_names[@]}; do
		printf "${bold}${i}${normal}\n"
		path=$root_dir${i}
		git -C $path fetch --tags && git -C $path checkout $1 && git -C $path pull
		printf "\n"
	done
fi