<?php

require_once(dirname(__FILE__) . "/RTObject.php");



/**
	Sadly, it's not a toll free bridge to PHP's native array structure, but it can
	be treated just like one.
	\ingroup Foundation
 */
class RTArray extends RTObject implements
																		ArrayAccess,
																		IteratorAggregate,
																		Countable
{
	protected $_data;


	/**
		Returns a fully initialized, empty RTArray.
		'array' is a reserved word in PHP, so we're using 'anArray' instead.
		\returns RTArray
	 */
	public static function anArray()
	{
		return self::alloc()->init();
	}




	/**
		Makes sure that the parent::init() method is called and that the internal
		storage structures are prepared.
	 */
	public function init()
	{
		parent::init();
		$this->_data = array();
		return $this;
	}




	/**
		Creates a new RTArray using the data found in $anArray
		\param $anArray An array to wrap
		\returns RTArray
	 */
	public static function arrayWithArray($anArray)
	{
		return self::alloc()->initWithArray($anArray);
	}




	/**
		Places a single object in an RTArray and returns it, ready for use.
		\param $anObject
		\returns RTArray
	 */
	public static function arrayWithObject($anObject)
	{
		if (is_object($anObject) && is_a($anObject, "RTObject") === NO)
		{
			throw new InvalidArgumentException(
				"RTArray cannot contain objects that do not inherit from RTObject."
				. " Found object of class '" . get_class($anObject) . "'"
			);
		}
		return self::alloc()->initWithArray(array($anObject));
	}




	/**
		Places all of the arguments in a newly initialized RTArray.
		\returns RTArray
	 */
	public static function arrayWithObjects()
	{
		return self::alloc()->initWithObjects(func_get_args());
	}




	/**
		Returns all of the objects stored in the sender separated by $aString.
		\param $aString example: ","
		\returns RTString
	 */
	public function componentsJoinedByString($aString)
	{
		$str = "";//implode($aString, $this->_data);
		for($i = 0; $i < count($this->_data); $i++)
		{
			$obj = $this->_data[$i];
			if (strlen(strval($str)) === 0)
			{
				$str .= strval($obj);
			}
			else
			{
				$str .= $aString . strval($obj);
			}
		}
		return RTString::stringWithString($str);
	}




	/**
		Initializes an RTArray populated with the data found in $anArray
		\param $anArray
		\returns RTArray
	 */
	public function initWithArray($anArray)
	{
		$this->init();
		if (is_array($anArray) === NO && is_a($anArray, "RTArray") === NO)
		{
			throw new InvalidArgumentException(
				"RTArray::initWithArray expects either a native PHP array or an "
				. "instance of RTArray, but found '" . gettype($anArray) . "'");
		}
		for($i = 0; $i < count($anArray); $i++)
		{
			$this->_addObject($anArray[$i]);
		}
		return $this;
	}




	/**
		A utility method that provides standardized filtering of incomming objects.
		Basically, it makes sure that any object added to the array is an instance
		of RTObject. An 'object' in this context literally means it passes the
		is_object() function.
		\param $anObject The object to add to the array
		\param $anIndex The index at which the object should be inserted
		\throws InvalidArgumentException if the object passes is_object() but is not
		an instance of RTObject.
	 */
	protected function _insertObject_atIndex($anObject, $anIndex)
	{
		if (is_object($anObject) && is_a($anObject, "RTObject") == NO)
		{
			throw new InvalidArgumentException(
				"RTArray can only contain primitives and objects that inherit from "
				. "RTObject. Found object of class '" . get_class($anObject) . "'");
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
		
		$this->_data[$anIndex] = $anObject;
	}





	/**
		Another utility method that simplifies the process of calling
		RTArray::_insertObject_atIndex by removing the requirement of an index.
	 */
	protected function _addObject($anObject)
	{
		$this->_insertObject_atIndex($anObject, $this->count());
	}




	/**
		Initializes the new RTArray and inserts all of the objects passed to this
		method.
		\returns RTArray
	 */
	public function initWithObjects()
	{
		$this->init();
		$objects = func_get_args();
		return $this->initWithArray($objects[0]);
	}




	/**
		Returns YES if the sender contains the given object. The comparison is done
		using strict methods, meaning "1" is not the same as 1.
		\param $anObject
		\returns BOOL
	 */
	public function containsObject($anObject)
	{
		for($i = 0; $i < $this->count(); $i++)
		{
			$obj = $this->objectAtIndex($i);
			if (is_object($obj) && is_object($anObject))
			{
				if ($obj == $anObject)
				{
					return YES;
				}
			}
			else if (is_object($obj) && is_a($obj, "RTObject"))
			{
				if ($obj->description() == $anObject)
				{
					return YES;
				}
			}
			else if ($obj == $anObject)
			{
				return YES;
			}
		}
		return NO;
	}




	/**
		Returns the number of objects contained within the sender.
		\returns int
	 */
	public function count()
	{
		return count($this->_data);
	}




	/**
		Returns the string value of the sender in JSON format.
		\returns string
	 */
	public function description()
	{
		$output = array();
		foreach($this->_data as $obj)
		{
			if (is_a($obj, "RTObject"))
			{
				if (is_a($obj, "RTArray") || is_a($obj, "RTDictionary"))
				{
					$output[] = $obj->description();
				}
				else
				{
					$output[] = '"' . $obj->description() . '"';
				}
			}
			else if (is_bool($obj))
			{
				$output[] = ($obj == YES ? 'true' : 'false');
			}
			else
			{
				$output[] = $obj;
			}
		}
		return "[" . implode(",", $output) . "]";
	}




	/**
		Returns the first object contained within the sender, or null of there are
		no objecs.
		\returns object
	 */
	public function firstObject()
	{
		return $this->objectAtIndex(0);
	}




	/**
		Returns the last object contained within the sender, or null if there are no
		objects.
		\returns object
	 */
	public function lastObject()
	{
		$idx = count($this->_data) - 1;
		if ($idx >= 0)
		{
			return $this->_data[$idx];
		}
		return null;
	}




	/**
		Returns the object at index $anIndex.
		\throws RTRangeException if $anIndex is greater than or equal to the value
		returned by RTArray::count()
		\param $anIndex The numeric index to search for
		\returns object
	 */
	public function objectAtIndex($anIndex)
	{
		if ($anIndex >= $this->count())
		{
			throw new RTRangeException(
				sprintf("Index %d is greater than max index %d", $anIndex,
				$this->count()-1)
			);
		}
		return $this->_data[$anIndex];
	}




	/**
		Returns the lowest index whose corresponding array value is equal to a given
		object. If the object isn't found, RTNotFound will be returned.
		\param $anObject
		\returns int
	 */
	public function indexOfObject($anObject)
	{
		$idx = RTNotFound;
		for($i = 0; $i < $this->count(); $i++)
		{
			$obj = $this->objectAtIndex($i);
			if (is_object($obj) && is_object($anObject))
			{
				if ($obj->description() === $anObject->description())
				{
					$idx = $i;
					break;
				}
			}
			else if (is_object($obj) && is_a($obj, "RTObject"))
			{
				if ($obj->description() === $anObject)
				{
					$idx = $i;
					break;
				}
			}
			else if ($obj === $anObject)
			{
				$idx = $i;
				break;
			}
		}
		return $idx;
	}




	/**
		Initializes a newly allocated array with the contents of the file specified
		by a given path. The contents of the file must be JSON.
		\param $aPath
		\returns RTArray
	 */
	public function initWithContentsOfFile($aPath)
	{
		$this->init();
		$url = RTURL::URLWithString($aPath);
		if ($url->isFileURL() && (!is_file($aPath) || !is_readable($aPath)))
		{
			$this->_data = array();
			return $this;
		}

		$contents = @file_get_contents($aPath);
		if ($contents !== NO)
		{
			$data = json_decode($contents);
			if (is_array($data))
			{
				$this->initWithArray(json_decode($contents));
			}
		}
		return $this;
	}




	/**
		Returns true if the two arrays are the same, which means they have the same
		number of objects and each object at each index is strictly the same type
		and value.
		\param $anArray
		\returns BOOL
	 */
	public function isEqualToArray(RTArray $anArray)
	{
		if ($this->count() == $anArray->count())
		{
			for($i = 0; $i < $this->count(); $i++)
			{
				$left = $this->objectAtIndex($i);
				$right = $anArray->objectAtIndex($i);
				if (is_object($left) && is_object($right))
				{
					if ($left->description() !== $right->description())
					{
						return NO;
					}
				}
				else if ($left !== $right)
				{
					return NO;
				}
			}
			return YES;
		}
		return NO;
	}




	/**
		Returns a new array containing the receiving array's elements that fall
		within the limits specified by a given range.
		\param $aRange
		\returns RTArray
	 */
	public function subarrayWithRange(RTRange $aRange)
	{
		$array = array();
		for($i = $aRange->location; $i <= $aRange->location + $aRange->length; $i++)
		{
			$array[] = $this->objectAtIndex($i);
		}
		return RTArray::arrayWithArray($array);
	}




	public function writeToFile($aPath)
	{
		file_put_contents($aPath, $this->description());
	}




	/**
		Returns the components stored in the sender as a native PHP array.
		\returns array
	 */
	public function phpArray()
	{
		return $this->_data;
	}




	/*-------------------ArrayAccess implementations------------------------*/

	public function offsetExists($offset)
	{
		if (!is_int($offset))
		{
			return NO;
		}
		return $offset >= 0 && $offset < $this->count();
	}




	public function offsetGet($offset)
	{
		return $this->objectAtIndex($offset);
	}




	public function offsetSet($offset, $value)
	{
		throw new Exception("Cannot alter an immutable RTArray instance.");
	}




	public function offsetUnset($offset)
	{
		throw new Exception("Cannot alter an immutable RTArray instance.");
	}




	public function getIterator()
	{
		return RTArrayIterator::alloc()->initWithArray($this);
	}
}









/**
	Defines a PHP-compatible iterator for RTArray data structures
 */
class RTArrayIterator extends RTObject implements Iterator
{
	protected $_data;
	protected $_pointer;

	public function initWithArray(RTArray $anArray)
	{
		$this->init();
		$this->_data = $anArray;
		$this->_pointer = 0;
		return $this;
	}




	public function current()
	{
		return $this->_data->objectAtIndex($this->_pointer);
	}




	public function key()
	{
		return $this->_pointer;
	}




	public function next()
	{
		$this->_pointer++;
	}




	public function rewind()
	{
		$this->_pointer = 0;
	}




	public function valid()
	{
		return $this->_pointer >= 0 && $this->_pointer < $this->_data->count();
	}
}
