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
		Returns a new string made by appending to the receiver a given string. Path
		separators will be automatically calculated and added where appropriate.
		\param $aString
		\returns RTString
	 */
	public function stringByAppendingPathComponent(RTString $aString)
	{
		if ($this->length() == 0)
		{
			return $aString;
		}

		if ($this->hasSuffix("/") && $aString->hasPrefix("/"))
		{
			$aString = $aString->substringFromIndex(1);
		}
		else if ($this->hasSuffix("/") == NO && $aString->hasPrefix("/") == NO)
		{
			$aString = RTString::stringWithString("/")->stringByAppendingString($aString);
		}
		return $this->stringByAppendingString($aString);
	}




	/**
		Returns the last path component of the receiver.
		The following table illustrates the effect of \c lastPathComponent on a
		variety of different paths:
		<table>
			<tr>
				<th>Receiver's String Value</th>
				<th>String Returned</th>
			</tr>
			<tr>
				<td>"/tmp/scratch.tiff"</td>
				<td>"scratch.tiff</td>
			</tr>
			<tr>
				<td>"/tmp/scratch"</td>
				<td>"scratch"</td>
			</tr>
			<tr>
				<td>"/tmp/"</td>
				<td>"tmp"</td>
			</tr>
			<tr>
				<td>"scratch"</td>
				<td>"scratch"</td>
			</tr>
			<tr>
				<td>"/"</td>
				<td>"/"</td>
			</tr>
		</table>
		\returns RTString
	 */
	public function lastPathComponent()
	{
		$str = RTString::stringWithString($this);

		// String is "/"
		if ($str->isEqualToString("/"))
		{
			return RTString::stringWithString("/");
		}
		
		if ($str->hasPrefix("/"))
		{
			$str = $str->substringFromIndex(1);
		}
		if ($str->hasSuffix("/"))
		{
			$str = $str->substringToIndex($str->length()-2);
		}

		$components = $str->componentsSeparatedByString("/");
		
		// String is "scratch", "tmp"
		if ($components->count() == 1)
		{
			return $components->firstObject();
		}

		// String is "tmp/scratch", "tmp/scratch.tiff"
		return $components->lastObject();
	}




	/**
		Returns a Boolean value that indicates whether a given string is equal to
		the reveiver using a literal comparison.
		\returns BOOL
	 */
	public function isEqualToString($aString)
	{
		return $this->description() === (string)$aString;
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
		if ($aPrefix == "")
		{
			return NO;
		}
		if (strpos($this->description(), (string)$aPrefix) === 0)
		{
			return YES;
		}
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
		Returns a new string containing the characters of the receiver from the one
		at a given index to the end.
	 */
	public function substringFromIndex($anIndex)
	{
		$range = RTMakeRange($anIndex, $this->length()-$anIndex);
		return $this->substringWithRange($range);
	}




	/**
		Returns a new string containing the characters of the receiver up to, but
		not including, the one at a given index.
	 */
	public function substringToIndex($anIndex)
	{
		$range = RTMakeRange(0, $anIndex);
		return $this->substringWithRange($range);
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
