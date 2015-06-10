#!/bin/bash
bold=`tput bold`
normal=`tput sgr0`
if [ -z "$1" ]; then
	echo "Usage: branch.sh <branch-name> <base-branch> <root-dir> [\"<repo>...\"]"
	echo "<branch-name> Name of branch to create and push for the specified repositories."
	echo "<base-branch> Name of base branch to branch off of."
	echo "<root-dir>    Optional: path to the root directory where the repositories are located. If not specified, the current directory is used."
	echo "\"<repo>\"      Optional: space delimited list of repositories to create the branch for. The defaults: enyo, lib/layout, lib/moonstone, lib/spotlight, lib/enyo-webos, lib/enyo-cordova, lib/enyo-ilib, lib/onyx, lib/canvas, lib/extra, bootplate, bootplate-moonstone, sampler, api-tool"
else
	if [ -z "$3" ]; then
		root_dir=${PWD}"/"
	else
		root_dir="$3"
	fi
	if [ -z "$4" ]; then
		repo_names=(enyo lib/layout lib/moonstone lib/spotlight lib/enyo-webos lib/enyo-cordova lib/enyo-ilib lib/onyx lib/canvas lib/extra bootplate bootplate-moonstone sampler api-tool)
	else
		IFS=', ' read -a repo_names <<< $4
	fi
	for i in ${repo_names[@]}; do
		printf "${bold}${i}${normal}\n"
		path=$root_dir${i}
		git -C $path fetch --tags && git -C $path checkout $2 && git -C $path pull
		git -C $path checkout -b $1 && git -C $path push origin -u $1:$1
		printf "\n"
	done
fi