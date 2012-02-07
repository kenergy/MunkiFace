<?php

require_once(dirname(__FILE__) . "/RTArray.php");



/**
	A mutable RTArray.
	\ingroup Foundation
 */
class RTMutableArray extends RTArray
{
	/**
		Adds an object to the receiver.
		\param $anObject
	 */
	public function addObject($anObject)
	{
		if (is_object($anObject) && is_a($anObject, "RTObject") == NO)
		{
			throw new InvalidArgumentException(
				"Cannot add an object to an RTMutableArray that doesn't inherit "
				. "from RTObject"
			);
		}
		$this->_data[] = $anObject;
	}




	/**
		Inserts a given object into the array's contents at a given index.
		\param $anObject
		\param $anIndex
		\throws InvalidArgumentException if $anObject is null
		\throws RTRangeException if $anIndex is greater than the number of elements
		in the array
	 */
	public function insertObject_atIndex($anObject, $anIndex)
	{
		if ($anObject === null)
		{
			throw new InvalidArgumentException(
				"Refusing to add 'null' to an exsting array");
		}
		if ($anIndex > $this->count())
		{
			throw new RTRangeException(
				"The specified index would create a fragmented array structure.");
		}

		$this->_data[$anIndex] = $anObject;
	}




	/**
		Appends the contents of the given array to the receiver.
		\param $anArray
	 */
	public function addObjectsFromArray($anArray)
	{
		if (is_array($anArray))
		{
			$anArray = RTArray::arrayWithArray($anArray);
		}
		
		if (is_a($anArray, "RTArray") == YES)
		{
			for($i = 0; $i < $anArray->count(); $i++)
			{
				$this->addObject($anArray->objectAtIndex($i));
			}
		}
		else
		{
			throw new InvalidArgumentException("RTArray::addObjectsFromArray expects "
			. "an array.");
		}
	}




	/**
		Removes all objects from the array.
	 */
	public function removeAllObjects()
	{
		$this->_data = array_slice($this->_data, 0, 0);
	}




	/**
		Removes the last object from the array.
	 */
	public function removeLastObject()
	{
		array_splice($this->_data, -1, 1);
	}
	
	
	
	
	/**
		Removes the first occourance of the object from the receiver.
		\param $anObject
	 */
	public function removeObject($anObject)
	{
		$idx = $this->indexOfObject($anObject);
		$this->removeObjectAtIndex($idx);
	}




	/**
		Removes the object at the given index.
		\param $anIndex
	 */
	public function removeObjectAtIndex($anIndex)
	{
		array_splice($this->_data, $anIndex, 1);
	}




	/**
		Removes from the receiving array the objects in another given array.
		\param $anArray
	 */
	public function removeObjectsInArray($anArray)
	{
		if (is_array($anArray) == YES)
		{
			$anArray = RTArray::arrayWithArray($anArray);
		}
		
		if (is_a($anArray, "RTArray") == YES)
		{
			for($i = 0; $i < $anArray->count(); $i++)
			{
				$this->removeObject($anArray->objectAtIndex($i));
			}
		}
		else
		{
			throw new InvalidArgumentException(
				"RTMutableArray::removeObjectsInArray expects an array");
		}
	}




	/**
		Removes from the array each of the objects within a given range.
		\param $aRange
	 */
	public function removeObjectsInRange(RTRange $aRange)
	{
		if (RTMaxRange($aRange) >= $this->count())
		{
			throw new RTRangeException("RTMaxRange of "
				. RTMaxRange($aRange) . " exceeds bounds of "
				. "0-" . ($this->count()-1));
		}
		for($i = $aRange->location; $i < RTMaxRange($aRange); $i++)
		{
			$this->removeObjectAtIndex($aRange->location);
		}
	}
	
	
	
	
	
	/*-------------------ArrayAccess implementations------------------------*/

	public function offsetSet($offset, $value)
	{
		if ($offset == null || $offset == $this->count())
		{
			$this->addObject($value);
		}
		else
		{
			$this->insertObject_atIndex($value, $offset);
		}
	}




	public function offsetUnset($offset)
	{
		$this->removeObjectAtIndex($offset);
	}
}
