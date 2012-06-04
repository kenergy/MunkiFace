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
$softwareRepoURLIsReachable = strpos($h, "200") == YES || strpos($h, "301") == YES;


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




echo "<h2>munki_repo Permissions</h2>";
echo "<h3>Read Permissions</h3>";
$dirs = array(
	$munkiRepo . "/manifests",
	$munkiRepo . "/pkgsinfo",
	$munkiRepo . "/catalogs"
);


function scandirr($aDir)
{
	$root = scandir($aDir);
	$results = array();
	foreach($root as $node)
	{
		$nodePath = $aDir . "/" . $node;
		if (strpos($node, ".") === 0)
		{
			continue;
		}
		if (is_file($nodePath))
		{
			$result[] = $nodePath;
			continue;
		}
		foreach(scandirr($nodePath) as $subNodes)
		{
			$result[] = $subNodes;
		}
	}
	return $result;
}

echo '<ul>';
foreach ($dirs as $dir)
{
	$parentDir = array($dir);
	$scanDirs = array_merge($parentDir, scandirr($dir));
	$didFindError = NO;
	foreach($scanDirs as $d)
	{
		if (is_readable($d) === NO)
		{
			$didFindError = YES;
			echo '<li><span class="error">' . $d . '</span></li>';
		}
	}
}
if ($didFindError == NO)
{
	echo '<li><span class="ok">MunkiFace as read rights to '
		.implode(", ", $dirs) . '</span></li>';
}
echo '</ul>';


echo "<h3>Write Permissions</h3>";
echo '<ul>';
foreach ($dirs as $dir)
{
	$parentDir = array($dir);
	$scanDirs = array_merge($parentDir, scandirr($dir));
	$didFindError = NO;
	foreach($scanDirs as $d)
	{
		if (is_writable($d) === NO)
		{
			$didFindError = YES;
			echo '<li><span class="error">' . $d . '</span></li>';
		}
	}
}
if ($didFindError == NO)
{
	echo '<li><span class="ok">MunkiFace as read rights to '
		.implode(", ", $dirs) . '</span></li>';
}
echo '</ul>';
?>

</div>
</body>
</html>
