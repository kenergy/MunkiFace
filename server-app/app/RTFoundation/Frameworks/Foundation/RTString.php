<?php
require_once(dirname(__FILE__) . "/RTObject.php");


/**
	\addtogroup Foundation
	@{
 */
define("RTCaseInsensitiveSearch", 1);
define("RTLiteralSearch", 2);
define("RTBackwardsSearch", 4);
define("RTAnchoredSearch", 8);
define("RTNumericSearch", 64);
define("RTDiacriticInsensitiveSearch", 128);


class RTString extends RTObject
{
	protected $_string;




	public function init()
	{
		parent::init();
		$this->_string = "";
		return $this;
	}



	/**
		Returns an empty string.
	 */
	public static function string()
	{
		return self::alloc()->init();
	}




	/**
		Returns a newly initialized string.
		\param $aString
		\returns RTString
	 */
	public static function stringWithString($aString)
	{
		return self::alloc()->initWithString($aString);
	}




	public static function stringWithFormat()
	{
		$str = call_user_func_array("sprintf", func_get_args());
		return self::stringWithString($str);
	}




	/**
		Initializes a new string.
		\param $aString
		\returns RTString
	 */
	public function initWithString($aString)
	{
		$this->init();
		$this->_string = $aString;
		return $this;
	}




	public function initWithFormat()
	{
		$this->_string = call_user_func_array("sprintf", func_get_args());
		return $this;
	}



	public function description()
	{
		return $this->_string;
	}




	/**
		Returns the Boolean value of the receiver's text.
		Returns YES on encountering one of 'Y', 'y', 'T', 't' or a digit 1-9. The
		method ignores any trailig characters. Returns NO otherwise.
		\returns BOOL
	 */
	public function boolValue()
	{
		$firstChar = strtolower(substr($this->_string, 0, 1));
		return $firstChar === 'y' || $firstChar === 't' || (is_numeric($firstChar)
		&& $firstChar > 0);
	}




	/**
		Returns a capitalized representation of the receiver.
		\returns RTString
	 */
	public function capitalizedString()
	{
		return RTString::stringWithString(strtoupper($this));
	}




	/**
		Returns one of RTOrderedAscending, RTOrderedSame, or RTOrderedDescending.
		\param $aString
		\returns int
	 */
	public function caseInsensitiveCompare($aString)
	{
		$ord = strcasecmp($this, $aString);
		return $ord < 0 ? RTOrderedAscending :
			($ord > 0 ? RTOrderedDescending : RTOrderedSame);
	}




	/**
		Returns the length of the sender.
		\returns int
	 */
	public function length()
	{
		return strlen($this->_string);
	}




	/**
		Returns the character at the given position.
	 */
	public function characterAtIndex($anIndex)
	{
		if ($anIndex < 0 || $anIndex >= $this->length())
		{
			return null;
		}

		return substr($this->_string, $anIndex, 1);
	}




	/**
		Returns a new RTString with the given format appended to the contents of the
		sender.
	 */
	public function stringByAppendingFormat()
	{
		$format = call_user_func_array(__CLASS__ . "::stringWithFormat", func_get_args());
		return RTString::stringWithString($this->_string . $format);
	}




	/**
		Returns a new RTString with the given string appended to the contents of the
		sender.
		\returns RTString
	 */
	public function stringByAppendingString($aString)
	{
		return self::stringWithString($this->_string . $aString);
	}




	/**
		Basically this is PHP's explode() function.
		\returns RTArray
	 */
	public function componentsSeparatedByString($aString)
	{
		return RTArray::arrayWithArray(explode($aString, $this->_string));
	}




	/**
		Returns a BOOL value indicating whether the beginning characters of the
		receiver match the given characters of $aPrefix or not. if aPrefix is
		empty, this method returns NO.
		\param $aPrefix
		\returns BOOL
	 */
	public function hasPrefix($aPrefix)
	{
		$range = RTMakeRange(0, strlen($aPrefix));
		if ($aPrefix == "")
		{
			return NO;
		}
		return $this->substringWithRange($range)->description()
			== $aPrefix;
	}




	/**
		Returns a BOOL value indicating whether the last characters of the
		receiver match the given characters. If aSuffix is empty, this method
		returns NO.
	 */
	public function hasSuffix($aSuffix)
	{
		$aSuffix = RTString::stringWithString($aSuffix);
		if ($aSuffix->length() > $this->length() || $aSuffix->length() == 0)
		{
			return NO;
		}
		$range = RTMakeRange(
			$this->length() - $aSuffix->length(),
			$aSuffix->length()
		);
		return
			$this->substringWithRange($range)->description()
			== $aSuffix->description();
	}




	/**
		Returns a new string containing the characters of the reciever that lie
		within the given range.
		\param $aRange
		\throws RTRangeException if any part of aRange lies beyond the end of
		the receiver.
		\returns RTString
	 */
	public function substringWithRange(RTRange $aRange)
	{
		if (	$aRange->length > $this->length()
				|| $aRange->location > $this->length()
		)
		{
			throw new RTRangeException();
		}
		return RTString::stringWithString(
			substr($this->_string, $aRange->location, $aRange->length)
		);
	}




	/**
		Finds and returns the range of the firt occurrence of a given string within
		the receiver.
		\param $aString
		\returns RTRange
	 */
	public function rangeOfString(RTString $aString)
	{
		$pos = strpos($this->description(), $aString->description());
		if ($pos === FALSE)
		{
			return RTMakeRange(0,0);
		}
		return RTMakeRange($pos, $aString->length());
	}




	/**
		Returns a new string in which all occurrences of a target string in the
		receiver are replaced by another given string.
		\param target
		\param replacement
		\returns RTString
	 */
	public function stringByReplacingOccurrencesOfString_withString(
		RTString $target,
		RTString $replacement
	)
	{
		return RTString::stringWithString(
			str_replace(
				$target->description(),
				$replacement->description(),
				$this->description()
			)
		);
	}
}


/** @} */
