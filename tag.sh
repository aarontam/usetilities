#!/bin/bash
bold=`tput bold`
normal=`tput sgr0`
if [ -z "$1" ]; then
	echo "Usage: tag.sh <tag-name> <base> <root-dir> [\"<repo>...\"]"
	echo "<tag-name> Name of tag to create and push for the specified repositories."
	echo "<base>     Name of branch, a commit hash, or another tag to apply <tag-name> to."
	echo "<root-dir> Optional: path to the root directory where the repositories are located. If not specified, the current directory is used."
	echo "\"<repo>\"   Optional: space delimited list of repositories to create the tag for. The defaults: enyo, lib/layout, lib/moonstone, lib/spotlight, lib/enyo-webos, lib/enyo-cordova, lib/enyo-ilib, lib/onyx, lib/canvas, lib/extra, bootplate, bootplate-moonstone, sampler, api-tool"
else
	if [ -z "$3" ]; then
		root_dir=${PWD}"/"
	else
		root_dir="$3"
	fi
	if [ -z "$4" ]; then
		repo_names=(enyo lib/layout lib/moonstone lib/spotlight lib/enyo-webos lib/enyo-cordova lib/enyo-ilib lib/onyx lib/canvas lib/extra lib/mochi)
	else
		IFS=', ' read -a repo_names <<< $4
	fi
	for i in ${repo_names[@]}; do
		printf "${bold}${i}${normal}\n"
		path=$root_dir${i}
		git -C $path checkout $2 && git -C $path pull
		git -C $path tag -f -a $1 -m "Tagging $1" && git -C $path push origin $1
		printf "\n"
	done
fi