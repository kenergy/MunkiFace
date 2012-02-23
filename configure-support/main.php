<?php
define("SERVER_APP_DIR", dirname(dirname(__FILE__)) . "/server-app/");
define("CLIENT_APP_DIR", dirname(dirname(__FILE__)) . "/client-app/");
define("SERVER_PLIST", SERVER_APP_DIR . "/Settings.plist");
define("CLIENT_PLIST", CLIENT_APP_DIR . "/Info.plist");


require_once SERVER_APP_DIR
	. "app/RTFoundation/Frameworks/Foundation/Foundation.php";
require_once dirname(__FILE__) . "/server.php";
require_once dirname(__FILE__) . "/client.php";


if (version_compare(PHP_VERSION, "5.3.0") < 0)
{
	echo "MunkiFace currently requires PHP v5.3.0 or higher. Found version "
		. PHP_VERSION . "\n";
	exit;
}




/**
	Presents the user with a yes or no prompt and returns a BOOL value.
 */
function confirmWithPrompt($aPrompt)
{
	$answer = "";
	while($answer != 'y' && $answer != 'n')
	{
		$answer = strtolower(readline($aPrompt . " [y/n]: "));
	}

	return $answer == 'y';
}




function displayCurrentValue($key, $val)
{
	echo "\n\n[" . $key . "]\n  :: " . $val . "\n";
}




// SERVER SIDE CONFIGURATION
$server = Server::alloc()->init();
$detectedPath = $server->detectRepoPathFromMunki();
displayCurrentValue("Munki Repo Path", $detectedPath);
if (is_dir($detectedPath))
{
	$server->setRepoPath($detectedPath);
}
else
{
	$path = readline("Where is your Munki Repo?: ");
	while(!is_dir($path))
	{
		echo "That doesn't appear to be a valid directory.\n";
		$path = readline("Where is your Munki Repo?: ");
	}
	echo "\n\n" . $detectedPath . "\n";
	$server->setRepoPath($path);
}




// CLIENT SIDE CONFIGURATION
$client = Client::alloc()->init();
displayCurrentValue("Munki Server URI", $client->readMunkiURI());
$changeMunkiURI = confirmWithPrompt(
	"Would you like to change the Munki Server URI?");

if ($changeMunkiURI == TRUE)
{
	$reachable = FALSE;
	while ($reachable == FALSE)
	{
		$uri = readline("Enter the fqdn for your munki server: ");
		$reachable = $client->URIIsReachable($uri . "/catalogs/all");
		if ($reachable == FALSE)
		{
			echo "\n  - Error contacting server\n";
		}
	}
	$client->setMunkiURI($uri);
}




displayCurrentValue("MunkiFace Server URI", $client->readMunkiFaceURI());
$changeMunkiFaceURI =confirmWithPrompt(
	"Would you like to change the MunkiFace Server URI?");
if ($changeMunkiFaceURI == TRUE)
{
	$reachable = FALSE;
	while ($reachable == FALSE)
	{
		$uri = readline("Enter the fqdn for your MunkiFace server: ");
		$reachable = $client->URIIsReachable($uri . "/index.php");
		if ($reachable == FALSE)
		{
			echo "\n  - Error contacting server\n";
		}
	}
	$client->setMunkiURI($uri);
	$client->setMunkiFaceURI($uri);
}




echo "\n\n\n ---DONE----\n\n\n";
