<?php
ini_set('display_errors', 0);

$appDir = dirname(__FILE__) . "/";



define("MFParseError", 1);
define("MFInvalidTargetForActionError", 2);
define("MFSecurityError", 3);
define("MFUnknownActionError", 4);
define("MFPermissionsError", 5);
define("MFAuthDriverError", 6);
define("MFBadRequestTypeError", 400);
define("MFUnauthorizedError", 401);



require_once($appDir . "Models/JSONException.php");
require_once($appDir . "RTFoundation/Frameworks/Foundation/Foundation.php");
require_once($appDir . "Models/HTTPRequest.php");
require_once($appDir . "Settings.php");
require_once($appDir . "Authentication/AuthenticationController.php");
require_once($appDir . "Controllers/AbstractController.php");
require_once($appDir . "Controllers/IndexController.php");
require_once($appDir . "Controllers/MFTargetController.php");
require_once($appDir . "Models/FileNameValidator.php");
require_once($appDir . "Models/AbstractModel.php");
require_once($appDir . "Models/ReadAction.php");
require_once($appDir . "Models/ReadHeadersAction.php");
require_once($appDir . "Models/SetAction.php");
