<?php

$appDir = dirname(__FILE__) . "/";


require_once($appDir . "RTFoundation/Frameworks/Foundation/Foundation.php");
require_once($appDir . "Settings.php");
require_once($appDir . "Controllers/AbstractController.php");
require_once($appDir . "Controllers/CatalogsController.php");
require_once($appDir . "Controllers/ManifestsController.php");
require_once($appDir . "Controllers/PkgsController.php");
require_once($appDir . "Controllers/PkgsInfoController.php");
require_once($appDir . "Models/AbstractModel.php");
require_once($appDir . "Models/CatalogsModel.php");
require_once($appDir . "Models/ManifestsModel.php");
require_once($appDir . "Models/PkgsModel.php");
require_once($appDir . "Models/PkgsInfoModel.php");





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
