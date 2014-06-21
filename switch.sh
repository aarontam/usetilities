#!/bin/bash
if [ -z "$1" ]; then
	echo "Usage: switch.sh <branch-name> [\"<repo>...\"]"
	echo "<branch-name> Name of branch or tag to switch to for the specified repositories."
	echo "\"<repo>\"      Optional: space delimited list of repositories to change the branch/tag for. The defaults: enyo, lib/enyo-ilib, lib/layout, lib/moonstone, lib/spotlight"
else
	root_dir=~/Documents/git/
	if [ -z "$2" ]; then
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