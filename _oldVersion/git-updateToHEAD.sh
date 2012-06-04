#!/bin/sh
#
# This is a very simple tool (perhaps too simple if the config files ever
# update) that makes a backup of your current configuration files, Info.plist
# and Settings.plist. It then performs a 'pull' command on the MunkiFace repo
# and restores the config files. This is meant primarily for testers and
# developers that need to update from github frequently but don't want to go
# through the hassle of updating their config files each time.
#
# Last updated: 3.14.12
#

git=`which git`
baseDir=`dirname "${0}"`
configDir="${baseDir}/saved_configs"

if [ "${git}" == "" ]; then
	echo "Couldn't find 'git'"
	exit 1
fi

if [ -e "${configDir}" ]; then
	rm -rf "${configDir}"
fi

echo "Backing up current configs...\c"
mkdir "${configDir}"
cp "${baseDir}/server-app/Settings.plist" "${configDir}"
cp "${baseDir}/client-app/Info.plist" "${configDir}"
echo "DONE"

echo "Syncing HEAD...\c"
gitResults=`git fetch origin`
gitResults="${gitResults} `git reset --hard origin/master`"
echo "DONE"

echo "Restoring config files...\c"
cp "${configDir}/Info.plist" "${baseDir}/client-app/"
cp "${configDir}/Settings.plist" "${baseDir}/server-app/"
rm -rf "${configDir}"
echo "DONE"

currentVersion=`git log -n 1 | head -n 1 | sed "s/commit //"`


echo ""
echo ""
echo "git said:"
echo "----------------------------------------------------------"
echo "${gitResults}"
echo "----------------------------------------------------------"
echo ""
echo "----------------------------------------------------------"
echo "Current commit: ${currentVersion}"
echo "----------------------------------------------------------"
echo ""
echo ""
