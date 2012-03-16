<?php
require_once (dirname(__FILE__) . "/app/bootstrap.php");

$settings = Settings::sharedSettings();

$munkiRepoIsReadable = NO;
$softwareRepoURLIsReachable = NO;
$plistExtension = "";
$excludeExtensions = array();


$munkiRepo = $settings->objectForKey("munki-repo");
$softwareRepoURL = $settings->objectForKey("SoftwareRepoURL");
$plistExtensions = $settings->objectForKey("plist_extensions");
$excludeExtensions = $settings->objectForKey("exclude_extensions");

if (is_dir($munkiRepo) && is_readable($munkiRepo))
{
	$munkiRepoIsReadable = YES;
}


$headers = get_headers($softwareRepoURL, 1);
$h = $headers[0];
if (strpos($h, "200") !== NO || strpos($h, "301") !== NO)
{
	$softwareRepoURLIsReachable = YES;
}


echo "<h1>Settings.plist</h1>";
echo "<h2>munki_repo</h2>";
echo " - '" . $munkiRepo . "'<br />";
echo " - is " . ($munkiRepoIsReadable == YES ? '' : '<b>not</b> ') . " readable<br />";

echo "<h2>SoftwareRepoURL</h2>";
echo " - '" . $softwareRepoURL . "'<br />";
echo " - is " . ($softwareRepoURLIsReachable ? '' : '<b>not</b> ') . "reachable<br />";

echo "<h2>plist_extensions</h2>";
if ($plistExtensions->count() > 0)
{
	echo "MunkiFace will <b>only inclue</b> files ending with the following patterns:"
		. "<ul>";
	foreach($plistExtensions as $ext)
	{
		echo "<li>" . $ext . "</li>";
	}
	echo "</ul>";
}
else
{
	echo " - All files will be iincluded according to this rule.";
}



echo "<h2>excluded_extensions</h2>";
if ($excludeExtensions->count() > 0)
{
	echo "MunkiFace will <b>ignore</b> files ending with the following patterns:"
		. "<ul>";
	foreach($excludeExtensions as $ext)
	{
		echo "<li>" . $ext . "</li>";
	}
	echo "</ul>";
}
else
{
	echo " - No files will be ignored according to this rule.";
}
