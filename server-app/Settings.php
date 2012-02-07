<?php



class Settings extends RTDictionary
{
	protected static $_INSTANCE;




	public static function sharedSettings()
	{
		if (self::$_INSTANCE == NULL)
		{
			self::$_INSTANCE = self::alloc()->initWithContentsOfFile(
				RTString::stringWithString(
					dirname(__FILE__) . "/Settings.plist"
				)
			);
		}
		return self::$_INSTANCE;
	}
}
