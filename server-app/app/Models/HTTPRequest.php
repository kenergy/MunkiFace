<?php
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




	public function requestMethod()
	{
		return $_SERVER["REQUEST_METHOD"];
	}




	public function allServerVars()
	{
		return RTDictionary::dictionaryWithPHPArray($_SERVER);
	}




	/**
		Looks for any content in the body of the request and if it is of type
		application/json, it will be parsed into an RTDictionary and returned.
		Otherwise, the raw content will be returned.
	 */
	public function requestBody()
	{
		$body = @file_get_contents(STDIN);
		if ($body->length() > 0)
		{
			$parsedBody = @json_decode($body, YES);
			if ($parsedBody != NULL)
			{
				$body = RTDictionary::dictionaryWithPHPArray($parsedBody);
			}
		}
		return $body;
	}
}

var_dump($_SERVER);
