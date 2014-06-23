#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: switch.sh <branch-name> <root-dir> [\"<repo>...\"]"
	echo "<branch-name> Name of branch or tag to switch to for the specified repositories."
	echo "<root-dir>    Optional: path to the root directory where the repositories are located. If not specified, the current directory is used."
	echo "\"<repo>\"      Optional: space delimited list of repositories to change the branch/tag for. The defaults: enyo, lib/enyo-ilib, lib/layout, lib/moonstone, lib/spotlight"
else
	if [ -z "$2" ]; then
		root_dir=pwd
	else
		root_dir="$2"
	fi
	if [ -z "$3" ]; then
		repo_names=(enyo lib/enyo-ilib lib/layout lib/moonstone lib/spotlight)
	else
		IFS=', ' read -a repo_names <<< $2
	fi
	for i in ${repo_names[@]}; do
		printf "\n${i}\n"
		path=$root_dir${i}
		git -C $path checkout $1 && git -C $path pull
	done
fi