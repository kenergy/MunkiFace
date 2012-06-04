<?php

require_once(dirname(__FILE__) . "/RTObject.php");





/**
	A utility function that returns YES if the given array contains at least one
	non-numeric key.
	\param $anArray
	\returns BOOL
	\ingroup Foundation
 */
function RTPHPArrayIsRTDictionary($anArray)
{
	$anArray = (array)$anArray;
	$keys = array_keys($anArray);
	foreach($keys as $key)
	{
		if (is_numeric($key) == NO)
		{
			return YES;
		}
	}
	return NO;
}







/**
	A utility function that returns YES if the given array contains only numeric
	keys.
	\param $anArray
	\returns BOOL
	\ingroup Foundation
 */
function RTPHPArrayIsRTArray($anArray)
{
	return !RTPHPArrayIsRTDictionary($anArray);
}



/**
	Declares a programmatic interface to objects that manage associations of keys
	and values.
	\ingroup Foundation
 */
class RTDictionary extends RTObject implements ArrayAccess, IteratorAggregate
{
	protected $_data;

	public function init()
	{
		parent::init();
		$this->_data = array();
		return $this;
	}




	/**
		Creates and returns an empty dictionary.
		\returns RTDictionary
	 */
	public static function dictionary()
	{
		return self::alloc()->init();
	}




	/**
		Creates and returns a dictionary using the contents of the file
		specified.
		\param $aPath
		\returns RTDictionary
		\note This method will return null if the file is malformed, or if the
		top element is anything but a dictionary.
	 */
	public static function dictionaryWithContentsOfFile(RTString $aPath)
	{
		return self::alloc()->initWithContentsOfFile($aPath);
	}




	/**
		Creates and returns a dictionary using the contents of the file found at
		the specified URL.
		\param $aURL
		\returns RTDictionary
		\note This method will return null if the file is malformed, or if the
		top element is anything but a dictionary.
	 */
	public static function dictionaryWithContentsOfURL(RTURL $aURL)
	{
		return self::alloc()->initWithContentsOfURL($aURL);
	}




	/**
		Creates and returns a dictionary using the keys and values from another
		given dictionary.
		\param $aDict
		\returns RTDictionary
	 */
	public static function dictionaryWithDictionary(RTDictionary $aDict)
	{
		return self::alloc()->initWithDictionary($aDict);
	}




	/**
		Creates and returns a dictionary containing a given key and value.
		\param $anObject
		\param $aKey
		\returns RTDictionary
	 */
	public static function dictionaryWithObject_forKey($anObject, $aKey)
	{
		return self::alloc()->initWithObjects_forKeys(
			array($anObject),
			array($aKey)
		);
	}




	/**
		Creats and returns a dictionary containing entries constructed from the
		contents of an array of keys and an array of values.
		\param $objects
		\param $keys
		\returns RTDictionary
	 */
	public static function dictionaryWithObjects_andKeys($objects, $keys)
	{
		return self::alloc()->initWithObjects_forKeys($objects, $keys);
	}




	/**
		Initializes a newly allocated dictionary using the contents found in the
		file at the given path. If the plist doens't exist or cannot be read,
		an empty dictionary will be returned.
		\param $aPath
		\returns RTDictionary
		\note This method will return null if the file is malformed, or if the
		top element is anything but a dictionary.
	 */
	public function initWithContentsOfFile(RTString $aPath)
	{
		if (file_exists($aPath))
		{
			$plist = new CFPropertyList($aPath);
			$plist = $plist->toArray();
			if (RTPHPArrayIsRTDictionary($plist) == NO)
			{
				return RTArray::arrayWithArray($plist);
			}
			return $this->initWithPHPArray($plist);
		}
		return $this->init();
	}




	/**
		Initializes a newly allocated dictionary using the contents found in the
		file at the given URL.
		\param $aURL
		\returns RTDictionary
		\note This method will return null if the file is malformed, or if the
		top element is anything but a dictionary.
	 */
	public function initWithContentsOfURL(RTURL $aURL)
	{
		$path = $aURL->description();
		return $this->initWithContentsOfFile($path);
	}




	/**
		Initializes a newly allocated dictionary with entries constructed from the
		contents of the objects and keys arrays.
		\param $objects An array of obejcts
		\param $keys An array of keys
		\returns RTDictionary
	 */
	public function initWithObjects_ForKeys($objects, $keys)
	{
		$this->init();

		$objectsIsArray = is_array($objects) || is_a($objects, "RTArray");
		$keysIsArray = is_array($keys) || is_a($keys, "RTArray");
		if ($objectsIsArray == NO || $keysIsArray == NO)
		{
			throw new InvalidArgumentException(
				"Objects and Keys given to RTDictionary::initWithObjectsForKeys must "
				. "both be arrays."
			);
		}

		if (is_a($objects, "RTArray") == NO)
		{
			$objects = RTArray::arrayWithArray($objects);
		}

		if (is_a($keys, "RTArray") == NO)
		{
			$keys = RTArray::arrayWithArray($keys);
		}

		if ($keys->count() != $objects->count())
		{
			throw new InvalidArgumentException(
				"Number of keys doesn't match the number of objects"
			);
		}

		for($i = 0; $i < $objects->count(); $i++)
		{
			$this->_setObject_forKey(
				$objects->objectAtIndex($i),
				$keys->objectAtIndex($i)
			);
		}
		return $this;
	}




	/**
		Provides a common set of logic filters for adding new items to the
		dictionary. This prevents invalid items from being added, such as objects
		that do not inherit from RTObject. The reason that object that do not
		inherit from RTObject are forbidden its that there is no way to assure a
		valid string representation can be derived from such objects. For example,
		there is no programatic way to convert an instance of stdClass to a string.
		Sure we would iterate over the properties and values of an object, but let's
		say you have a custom class that only uses private properties. We could
		alsos test for the ability of an object to be converted to a string, but by
		enforcing this requirement, that's already done.
	 */
	protected function _setObject_forKey($anObject, $aKey)
	{
		if (is_object($anObject) && is_a($anObject, "RTObject") == NO)
		{
			throw new InvalidArgumentException(
				"Objects added to an RTDictionary must inherit from RTObject."
			);
		}

		if (is_null($aKey) == YES)
		{
			throw new InvalidArgumentException(
				"Keys in an RTDictionary cannot be null"
			);
		}
		else if (is_object($aKey) && is_a($aKey, "RTObject"))
		{
			$aKey = $aKey->description();
		}


		if (is_array($anObject))
		{
			if (RTPHPArrayIsRTDictionary($anObject))
			{
				$anObject = RTDictionary::dictionaryWithPHPArray($anObject);
			}
			else
			{
				$anObject = RTArray::arrayWithArray($anObject);
			}
		}
		else if (is_string($anObject))
		{
			$anObject = RTString::stringWithString($anObject);
		}

		$this->_data[$aKey] = $anObject;
	}




	/**
		Returns a new array containing the dictionary's keys.
		\returns RTArray
	 */
	public function allKeys()
	{
		return RTArray::arrayWithArray(array_keys($this->_data));
	}




	/**
		Returns a new array containing the dictionary's values.
		\returns RTArray
	 */
	public function allValues()
	{
		return RTArray::arrayWithArray(array_values($this->_data));
	}




	/**
		Returns the number of entries in the dictionary.
		\returns int
	 */
	public function count()
	{
		return count($this->_data);
	}




	/**
		Returns the JSON representation of the key value pairs stored in the
		receiving dictionary.
		\returns string
	 */
	public function description()
	{
		$output = array();
		foreach($this->_data as $key => $obj)
		{
			$key = '"' . $key . '":';
			if (is_a($obj, "RTObject"))
			{
				if (is_a($obj, "RTArray") || is_a($obj, "RTDictionary"))
				{
					$output[] = $key . $obj->description();
				}
				else if (is_a($obj, "RTString"))
				{
					$output[] = $key . json_encode($obj->description());
				}
				else
				{
					$output[] = $key . '"' . $obj->description() . '"';
				}
			}
			else if (is_bool($obj))
			{
				$output[] = $key . ($obj == YES ? 'true' : 'false');
			}
			else
			{
				$output[] = $key . $obj;
			}
		}
		return "{" . implode(",", $output) . "}";
	}




	/**
		Returns the JSON encoded value of the dictionary.
		\returns string
	 */
	public function asJSON()
	{
		return json_encode($this->phpArray());
	}




	/**
		Creates a newly allocated dictionary by placing in it the keys and values
		contained in another given dictionary.
		\param $aDict
		\returns RTDictionary
	 */
	public function initWithDictionary(RTDictionary $aDict)
	{
		$this->init();
		$this->_data = $aDict->phpArray();
		return $this;
	}




	/**
		Returns the object represented by the given key.
		\param $aKey
		\returns mixed
	 */
	public function objectForKey($aKey)
	{
		if ($this->allKeys()->containsObject($aKey))
		{
			if (is_object($aKey))
			{
				return $this->_data[$aKey->description()];
			}
			else
			{
				return $this->_data[$aKey];
			}
		}
		return null;
	}




	/**
		Returns the first key found that represents the object, or null of the
		object isn't in this dictionary.
		\param $anObject
		\returns mixed
	 */
	public function keyForObject($anObject)
	{
		$idx = $this->allValues()->indexOfObject($anObject);
		if ($idx != RTNotFound)
		{
			return $this->allKeys()->objectAtIndex($idx);
		}
		return null;
	}




	/**
		Returns YES if the receiving dictionary and aDict have the same number of
		entries and for a given key, the corresponding objecs are also the same.
		\param $aDict
		\returns BOOL
	 */
	public function isEqualToDictionary(RTDictionary $aDict)
	{
		return ($this->count() == $aDict->count())
			&& ($this->allKeys()->isEqualToArray($aDict->allKeys()))
			&& ($this->allValues()->isEqualToArray($aDict->allValues()));
	}




	/**
		Returns the native PHP array representation of this dictionary.
		\returns array
	 */
	public function phpArray()
	{
		$arr = array();
		while(list($key, $val) = each($this->_data))
		{
			if (is_object($val) && (is_a($val, "RTArray") || is_a($val,
				"RTDictionary")))
			{
				$val = $val->phpArray();
			}
			else if (is_object($val) && is_a($val, "RTObject"))
			{
				$val = $val->description();
			}
		
			$arr[$key] = $val;
		}
		return $arr;
	}




	/**
		Creates and returns a new dictionary using the keys and values found in the
		given PHP array.
		\param $anArray
		\returns RTDictionary
	 */
	public static function dictionaryWithPHPArray($anArray)
	{
		return self::alloc()->initWithPHPArray($anArray);
	}




	/**
		Adds the key value pairs from the given array to the receiving dictionary.
		\param $anArray
		\returns RTDictionary
	 */
	public function initWithPHPArray($anArray)
	{
		if(is_a($anArray, "RTArray"))
		{
			$anArray = $anArray->phpArray();
		}
		$this->init();
		foreach($anArray as $key => $val)
		{
			$this->_setObject_forKey($val, $key);
		}
		return $this;
	}




	public function writeToFile($aPath)
	{
		$plist = new CFPropertyList();
		$td = new CFTypeDetector();
		$struct = $td->toCFType($this->phpArray());
		$plist->add($struct);
		$plist->saveXML($aPath);
	}




	/*-------------------ArrayAccess implementations------------------------*/

	public function offsetExists($offset)
	{
		return $this->allKeys()->containsObject($offset);
	}




	public function offsetGet($offset)
	{
		return $this->objectForKey($offset);
	}




	public function offsetSet($offset, $value)
	{
		throw new Exception("Cannot alter an immutable RTDictionary instance.");
	}




	public function offsetUnset($offset)
	{
		throw new Exception("Cannot alter an immutable RTDictionary instance.");
	}




	public function getIterator()
	{
		return RTDictionaryIterator::alloc()->initWithDictionary($this);
	}
}









/**
	Defines a PHP-compatible iterator for RTDictionary data structures
 */
class RTDictionaryIterator extends RTObject implements Iterator
{
	protected $_data;
	protected $_keyIterator;

	public function initWithDictionary(RTDictionary $aDict)
	{
		$this->init();
		$this->_data = $aDict;
		$this->_keyIterator = $this->_data->allKeys()->getIterator();
		return $this;
	}




	public function current()
	{
		$key = $this->_keyIterator->current();
		return $this->_data->objectForKey($key);
	}




	public function key()
	{
		return $this->_keyIterator->current()->description();
	}




	public function next()
	{
		$this->_keyIterator->next();
	}




	public function rewind()
	{
		$this->_keyIterator->rewind();
	}




	public function valid()
	{
		return $this->_keyIterator->valid();
	}

}
