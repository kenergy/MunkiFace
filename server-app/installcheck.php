<!doctype html>
<html>
<head>
	<title>MunkiFace Server Install Check</title>
	<?php include dirname(__FILE__) . "/app/Resources/style.php";?>
</head>
<body>
<div id="body">

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

$munkiRepoIsReadable = is_dir($munkiRepo) && is_readable($munkiRepo);


$headers = get_headers($softwareRepoURL, 1);
$h = $headers[0];
$softwareRepoURLIsReachable = strpos($h, "200") !== NO || strpos($h, "301") !== NO;


echo "<h1>Settings.plist</h1>
<a href='index.php'>Want to design your own client using MunkiFace Server?</a>

<h2>munki_repo</h2>
<span class='" . ($munkiRepoIsReadable == YES ? 'ok' : 'error') . "'>"
	. $munkiRepo . "</span>

<h2>SoftwareRepoURL</h2>
<span class='" . ($softwareRepoURLIsReachable ? 'ok':'error') . "'>"
	. $softwareRepoURL . "</span>


<h2>plist_extensions</h2>";

if ($plistExtensions->count() > 0)
{
	echo "MunkiFace will <b>only include</b> files ending with the following patterns:"
		. "<ul>";
	foreach($plistExtensions as $ext)
	{
		echo "<li>" . $ext . "</li>";
	}
	echo "</ul>";
}
else
{
	echo " - All files will be included according to this rule.";
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
?>

</div>
</body>
</html>
