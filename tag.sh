#!/bin/bash
bold=`tput bold`
normal=`tput sgr0`
if [ -z "$1" ]; then
	echo "Usage: tag.sh <tag-name> <base> <root-dir> [\"<repo>...\"]"
	echo "<tag-name> Name of tag to create and push for the specified repositories."
	echo "<base>     Name of branch, a commit hash, or another tag to apply <tag-name> to."
	echo "<root-dir> Optional: path to the root directory where the repositories are located. If not specified, the current directory is used."
	echo "\"<repo>\"   Optional: space or comma delimited (relative) paths of repositories to create the tag for. If not specified, will attempt to tag the repos in the current directory."
else
	if [ -z "$3" ]; then
		root_dir=${PWD}"/"
	else
		root_dir="$3"
	fi
	if [ -z "$4" ]; then
		repo_names=(*)
	else
		IFS=', ' read -a repo_names <<< $4
	fi
	for i in ${repo_names[@]}; do
		printf "${bold}${i}${normal}\n"
		path=$root_dir${i}
		# delete local tag if it already exists
		if git -C $path rev-parse $1 >/dev/null 2>&1
		then
			printf "Deleting existing tag $1\n"
			git -C $path tag -d $1
		fi
		git -C $path fetch --tags && git -C $path checkout $2 && git -C $path pull
		printf "Tagging $1\n"
		git -C $path tag -f -a $1 -m "Tagging $1" && git -C $path push origin $1
		printf "\n"
	done
fi