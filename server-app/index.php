<?php
require_once (dirname(__FILE__) . "/app/bootstrap.php");

$request = HTTPRequest::sharedRequest();

$controller = $request->objectForKey("controller");

switch ($controller)
{
	case "manifests":
		ManifestsController::alloc()->init();
		break;
	case "pkgs":
		PkgsController::alloc()->init();
		break;
	case "catalogs":
		CatalogsController::alloc()->init();
		break;
	case "pkgsinfo":
		PkgsInfoController::alloc()->init();
		break;
	case "readFile":
		// This is a meta controller, and it just allows the caller to get the
		// contents of a plist by providing the full path to the file relative to
		// the munki repo directory.
		$munkiDir = Settings::sharedSettings()->objectForKey("munki-repo");
		echo RTDictionary::dictionaryWithContentsOfFile(
			RTString::stringWithString(
				$munkiDir . "/" . $request->objectForKey("file")
			)
		);
		break;
	case "settings":
		echo Settings::sharedSettings();
		break;
	default:
		include dirname(__FILE__) . "/app/help.php";
}
