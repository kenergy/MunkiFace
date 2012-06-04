<?php

require_once(dirname(__FILE__) . "/Library/CFPropertyList/CFPropertyList.php");
/**
	\defgroup server-app Server Application
	The server application documentation group represents members written in PHP
	which make up the server-side logic.
	@{
 */
/**
	Reads the settings from ../Resources/Settings.plist and makes the contents
	available to the rest of the application.
 */
class Settings
{
	protected $_data;
	protected static $_instance;

	private function __construct()
	{
		$d = new CFPropertyList(
			dirname(dirname(__FILE__)) . "/Resources/Settings.plist");
		$this->_data = $d->toArray();
		self::$_instance = $this;
	}


	public static function sharedSettings()
	{
		if (self::$_instance == null)
		{
			$temp = new Settings();
		}
		return self::$_instance;
	}




	public function allKeys()
	{
		return array_keys($this->_data);
	}




	public function objectForKey($aKey)
	{
		if (!isset($this->_data[$aKey]))
		{
			return null;
		}
		return $this->_data[$aKey];
	}
}

/** @} */
