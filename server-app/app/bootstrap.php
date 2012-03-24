<?php
ini_set('display_errors', 0);

$appDir = dirname(__FILE__) . "/";



define("MFParseError", 1);
define("MFInvalidTargetForAction", 2);



require_once($appDir . "Models/JSONException.php");
require_once($appDir . "RTFoundation/Frameworks/Foundation/Foundation.php");
require_once($appDir . "Settings.php");
require_once($appDir . "Controllers/AbstractController.php");
require_once($appDir . "Controllers/IndexController.php");
require_once($appDir . "Models/FileNameValidator.php");
require_once($appDir . "Models/AbstractModel.php");
require_once($appDir . "Models/ReadAction.php");





class HTTPRequest extends RTDictionary
{
	protected static $_INSTANCE;

	public static function sharedRequest()
	{
		if (self::$_INSTANCE == null)
		{
			self::$_INSTANCE = self::dictionaryWithPHPArray($_REQUEST);
		}
		return self::$_INSTANCE;
	}




	public function hasKey($aKey)
	{
		return $this->allKeys()->containsObject($aKey);
	}
}
