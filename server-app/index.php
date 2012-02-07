<?php
require_once (dirname(__FILE__) . "/bootstrap.php");

$request = RTDictionary::dictionaryWithPHPArray($_REQUEST);

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
