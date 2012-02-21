<?php
require_once (dirname(__FILE__) . "/app/bootstrap.php");

$request = HTTPRequest::sharedRequest();

$controller = $request->objectForKey("controller");

switch ($controller)
{
	case "pkgs":
		PkgsController::alloc()->init();
		break;
	case "catalogs":
		CatalogsController::alloc()->init();
		break;
	case "pkgsinfo":
		PkgsInfoController::alloc()->init();
		break;
	default:
		echo "I don't know what you want me to tell you right now.";
}
