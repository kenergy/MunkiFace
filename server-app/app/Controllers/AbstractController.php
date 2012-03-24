<?php




abstract class AbstractController extends RTObject
{
	const ACTION_READ = 0;
	const ACTION_READ_HEADERS = 1;
	const ACTION_SET_OBJECT_FOR_KEY = 2;
	const ACTION_UNDEFINED = 3;
	protected static $_HTTPRequest;
	protected static $_action;




	public function getAction()
	{
		if (self::$_action == null)
		{
			$args = $this->HTTPRequest()->allKeys();
			if ($args->containsObject("read"))
			{
				self::$_action = self::ACTION_READ;
			}
			else if ($args->containsObject("readHeaders"))
			{
				self::$_action = self::ACTION_READ_HEADERS;
			}
			else if ($args->containsObject("setObject") &&
			$args->containsObject("forKey"))
			{
				self::$_action = self::ACTION_SET_OBJECT_FOR_KEY;
			}
			else
			{
				self::$_action = self::ACTION_UNDEFINED;
			}
		}
		return self::$_action;
	}




	public function HTTPRequest()
	{
		if (self::$_HTTPRequest == null)
		{
			self::$_HTTPRequest = HTTPRequest::sharedRequest();
		}
		return self::$_HTTPRequest;
	}
}
