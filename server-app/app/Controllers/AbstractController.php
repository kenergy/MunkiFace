<?php




abstract class AbstractController extends RTObject
{
	protected static $_HTTPRequest;




	public function HTTPRequest()
	{
		if (self::$_HTTPRequest == null)
		{
			self::$_HTTPRequest = HTTPRequest::sharedRequest();
		}
		return self::$_HTTPRequest;
	}
}
