<?php




/**
	Provides methods to manipulate URLs.
	\ingroup Foundation
 */
class RTURL extends RTObject
{
	protected $_url;
	protected $_parsedUrl;

	public function initWithString($aString)
	{
		if (is_object($aString) && get_class($aString) != "RTString")
		{
			$aString = RTString::stringWithString(strval($aString));
		}
		parent::init();
		$this->_url = $aString;
		$parsedUrl = parse_url($aString);
		
		// @codeCoverageIgnoreStart
		if ($parsedUrl === NO)
		{
			throw new InvalidArgumentException("Unable to parse url '" . $aString .
			"'");
		}
		// @codeCoverageIgnoreEnd

		$this->_setDefaultValue_forKey_onArray("file", "scheme", $parsedUrl);
		$this->_setDefaultValue_forKey_onArray(null, "host", $parsedUrl);
		$this->_setDefaultValue_forKey_onArray(null, "port", $parsedUrl);
		$this->_setDefaultValue_forKey_onArray(null, "user", $parsedUrl);
		$this->_setDefaultValue_forKey_onArray(null, "pass", $parsedUrl);
		$this->_setDefaultValue_forKey_onArray("/", "path", $parsedUrl);
		$this->_setDefaultValue_forKey_onArray(null, "query", $parsedUrl);
		$this->_setDefaultValue_forKey_onArray(null, "fragment", $parsedUrl);
		
		$this->_parsedUrl = RTDictionary::dictionaryWithPHPArray($parsedUrl);

		return $this;
	}



	private function _setDefaultValue_forKey_onArray($aValue, $aKey, &$anArray)
	{
		if (!isset($anArray[$aKey]) ||
			(isset($anArray[$aKey]) && trim($anArray[$aKey]) == "")
		)
		{
			$anArray[$aKey] = $aValue;
		}
	}




	public static function URLWithString($aString)
	{
		return self::alloc()->initWithString($aString);
	}




	/**
		Returns the hostname of the receiving url, or null if one cannot be found as
		in the case of a filesystem url.
		\returns RTString
	 */
	public function host()
	{
		return $this->_parsedUrl->objectForKey('host');
	}




	/**
		Returns the fragment (the string following '#') of the URL, or null if there
		is none.
		\returns RTString
	 */
	public function fragment()
	{
		return $this->_parsedUrl->objectForKey("fragment");
	}




	/**
		Returns the last path component of the URL, which can be a file or a
		directory. If there isn't a last path component, and empty string will be
		returned.
		\returns RTString
	 */
	public function lastPathComponent()
	{
		return $this->path()->componentsSeparatedByString("/")->lastObject();
	}




	/**
		Returns the parameter string of the URL, which is everything following '?'
		and preceeding the optional '#'. Returns null if there are no parameters.
		\returns RTString
	 */
	public function parameterString()
	{
		return $this->_parsedUrl->objectForKey("query");
	}




	/**
		Returns the password of the given URL or null if there isn't one.
		\returns RTString
	 */
	public function password()
	{
		return $this->_parsedUrl->objectForKey("pass");
	}




	/**
		Returns the path of a URL or null if there is no path.
		\returns RTString
	 */
	public function path()
	{
		return $this->_parsedUrl->objectForKey("path");
	}




	/**
		Returns the components of the URLs path as an array.
		\returns RTArray
	 */
	public function pathComponents()
	{
		$path = RTString::stringWithString($this->path());
		$components = RTMutableArray::arrayWithArray(
			$path->componentsSeparatedByString("/")
		);
		if ($components->count() > 0)
		{
			$components->removeObjectAtIndex(0);
		}
		
		return RTArray::arrayWithArray($components);;
	}




	/**
		Returns the extension found on the last component of the url or an empty
		string if none can be found.
		\returns RTString
	 */
	public function pathExtension()
	{
		$file = RTString::stringWithString($this->pathComponents()->lastObject());
		return $file->componentsSeparatedByString(".")->lastObject();
	}




	/**
		Returns the port number used in the URL or null if one is not found.
		\returns int
	 */
	public function port()
	{
		return $this->_parsedUrl->objectForKey("port");
	}





	/**
		An alias of RTURL::parameterString()
	 */
	public function query()
	{
		return $this->_parsedUrl->objectForKey("query");
	}




	/**
		Returns the scheme used in the URL, such as 'http' or 'https'.
		\returns RTString
	 */
	public function scheme()
	{
		return $this->_parsedUrl->objectForKey("scheme");
	}




	/**
		Returns the username used in the URL or an empty string if one has not been
		specified.
		\returns RTString.
	 */
	public function user()
	{
		return $this->_parsedUrl->objectForKey("user");
	}



	/**
		Returns YES if the URL represents a path on the filesystem, NO if not.
		\returns BOOL
	 */
	public function isFileURL()
	{
		return $this->scheme()->caseInsensitiveCompare("file") === RTOrderedSame;
	}




	public function description()
	{
		$url = $this->scheme() . "://";
		if ($this->user() != "")
		{
			$url .= $this->user();
			$url .= $this->password() == "" ? "" : ":" . $this->password();
			$url .= "@";
		}
		$url .= $this->host() == "" ? "" : $this->host();
		$url .= $this->port() == "" ? "" : ":" . $this->port();
		$url .= $this->path() == "" ? "" : $this->path();
		$url .= $this->query() == "" ? "" : "?" . $this->query();
		$url .= $this->fragment() == "" ? "" : "#" . $this->fragment();
		return $url;
	}
}
