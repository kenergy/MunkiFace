<?php
require_once(dirname(__FILE__) . "/bootstrap.php");
require_once(LIBRARY_PATH . "Resource.php");



$validActions = array("mv", "mkdir", "rm");


// make sure we've got some valid parameters to work with
$action = isset($_GET['action']) ? $_GET['action'] : null;
$target = isset($_GET['target']) ? $_GET['target'] : null;
$fromTarget = isset($_GET['fromTarget']) ? $_GET['fromTarget'] : null;
$toTarget = isset($_GET['toTarget']) ? $_GET['toTarget'] : null;

if (!in_array($action, $validActions))
{
	throw new RuntimeException("Invalid action '" . $action . "' specified");
}



$resource = new Resource();
$result = FALSE;
switch ($action)
{
	case "mv":
		if ($fromTarget == null || $toTarget == null)
		{
			throw new RuntimeException(
				"Can't move without both a fromTarget and a toTarget");
		}
		$result = $resource->movePath_toPath($fromTarget, $toTarget);
		break;
	
	case "mkdir":
		if ($target == null)
		{
			throw new RuntimeException("Can't create dir without a target path");
		}
		$result = $resource->createDirectory($target);
		break;
	
	case "rm":
		if ($target == null)
		{
			throw new RuntimeException("Can't remove an empty target");
		}
		$result = $resource->deleteResource($target);
		break;
}


echo $result == TRUE ? "YES" : "NO";
