<?php
require_once(dirname(__FILE__) . "/RTDictionary.php");




/**
	Provides a programmatic interface to an editable version of RTDictionary
	objects.
	\ingroup Foundation
 */
class RTMutableDictionary extends RTDictionary
{
	/**
		Adds to the receiving dictionary the entiries from another dictionary.
		\param $aDict
		\returns void
	 */
	public function addEntriesFromDictionary(RTDictionary $aDict)
	{
		$keys = $aDict->allKeys();
		$objects = $aDict->allValues();
		for($i = 0; $i < $keys->count(); $i++)
		{
			$this->_setObject_forKey(
				$objects->objectAtIndex($i),
				$keys->objectAtIndex($i)
			);
		}
	}




	/**
		Empties the dictionary of its entries.
	 */
	public function removeAllObjects()
	{
		for($i = $this->count()-1; $i >= 0; $i--)
		{
			$this->removeObjectForKey($this->allKeys()->objectAtIndex($i));
		}
	}




	/**
		Removes a given key and its associated value from the dictionary.
		\param $aKey
	 */
	public function removeObjectForKey($aKey)
	{
		$keyIndex = $this->allKeys()->indexOfObject($aKey);
		if ($keyIndex == RTNotFound)
		{
			return;
		}

		array_splice($this->_data, $keyIndex, 1);
	}




	/**
		Removes from the dictionary entries specified by elements in a given array.
		\param $anArray
	 */
	public function removeObjectsForKeys($anArray)
	{
		if (is_array($anArray))
		{
			$anArray = RTArray::arrayWithArray($anArray);
		}
		for($i = 0; $i < $anArray->count(); $i++)
		{
			$this->removeObjectForKey($anArray->objectAtIndex($i));
		}
	}




	/**
		Sets the contents of the receiving dictionary to the entries in a given
		dictionary.
		\param $aDictionary
	 */
	public function setDictionary(RTDictionary $aDictionary)
	{
		$this->_data = $aDictionary->phpArray();
	}




	/**
		Adds a given key-value pair to the dictionary.
		\warning If $anObject is an object (one created from a class) it must
		inherit from RTObject.
		\param $anObject
		\param $aKey
		\throws InvalidArgumentException if $anObject passed is_object($anObject)
		but not is_a($anObject, "RTObject").
	 */
	public function setObject_forKey($anObject, $aKey)
	{
		$this->_setObject_forKey($anObject, $aKey);
	}




	/*-------------------ArrayAccess implementations------------------------*/

	public function offsetSet($offset, $value)
	{
		$this->setObject_forKey($value, $offset);
	}




	public function offsetUnset($offset)
	{
		$this->removeObjectForKey($offset);
	}
}
