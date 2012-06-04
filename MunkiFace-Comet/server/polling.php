<?php
/**
	This file uses the WatchPath class to poll the entire munki repo for changes.
	Long polling means that this script will not respond to the client until there
	is something to say. Then, the client is expected to re-initiate the
	connection immediately to start the process over again. This provides a near
	realtime update to the client when anything changes on the server.

	If you call this script without an argument, it will return everything in the
	repo. If you pass the _GET variable "fromNow", it will only return data when
	something is modified, added or deleted 'from now' on.
*/
define("LIBRARY_PATH", dirname(__FILE__) . "/Library/");
require_once(dirname(__FILE__) . "/Settings.php");
require_once(LIBRARY_PATH . "WatchPath.php");
require_once(LIBRARY_PATH . "CFPropertyList/CFPropertyList.php");

$settings = Settings::sharedSettings();
$munkiRepo = $settings->objectForKey('munki_repo');
$settingsKeys = $settings->allKeys();

$plistExtensions = array();
$excludeExtensions = array();

if (in_array("plist_extensions", $settingsKeys))
{
	$plistExtensions = $settings->objectForKey("plist_extensions");
}

if (in_array("exclude_extensions", $settingsKeys))
{
	$excludeExtensions = $settings->objectForKey("exclude_extensions");
}


if (is_dir($munkiRepo) == FALSE)
{
	echo "Couldn't find munki repo at path '" . $munkiRepo . "'";
	exit;
}


$requestedModificationDate = isset($_GET['fromNow']) ? mktime() : 0;
$watchPath = new WatchPath($munkiRepo . "/*", $requestedModificationDate);
$changes = $watchPath->watch();

$output = array();
$shouldCheckPlistExt = count($plistExtensions) != 0;
$shouldCheckExcludeExt = count($excludeExtensions) != 0;
foreach($changes as $key=>$change)
{
	$output[$key] = array();
	foreach($change as $path=>$modificationDate)
	{
		if (!is_dir($path))
		{
			$ext = substr(strrchr($path, '.'), 1);

			// If there are any plist extensions set in the settings, and the current
			// file's extensions doesn't match one of the values, we'll skip it.
			if ($shouldCheckPlistExt && !in_array($ext, $plistExtensions))
			{
				continue;
			}

			// If there are any exclude extensions set in the settings, and the
			// current file's extensions does match one of the values, we'll skip it.
			if ($shouldCheckExcludeExt && in_array($ext, $excludeExtensions))
			{
				continue;
			}


			$newPath = str_replace($munkiRepo, "", $path);
			try
			{
				$file = new CFPropertyList($path);
				$output[$key][$newPath] = $file->toArray();
			}
			catch(Exception $e)
			{
				$output[$key][$newPath] = "(not a plist)";
			}
		}
	}
}
echo json_encode($output);
