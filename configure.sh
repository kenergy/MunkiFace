#!/bin/sh
PHP=`which php`

clear
echo "========================================================================"
echo
echo "                     MunkiFace configuration tool"
echo "                        modified: Feb 23, 2012"
echo
echo "========================================================================"
echo
echo
echo


if [ "${PHP}" == "" ]; then
	echo "Couldn't automatically locate PHP CLI on your system."
	echo
	echo
	echo
	exit;
fi


BASE_NAME=`dirname "${0}"`
"${PHP}" "${BASE_NAME}/configure-support/main.php"
