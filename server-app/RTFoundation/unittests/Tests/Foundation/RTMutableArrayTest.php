<?php
require_once(dirname(__FILE__) . "/RTArrayTest.php");




class RTMutableArrayTest extends RTArrayTest
{

	public function setUp()
	{
		parent::setUp();
		self::$array = RTMutableArray::arrayWithArray(self::$fixture);
	}


	public function testAddObject()
	{
		$obj = RTObject::alloc()->init();
		$originalCount = self::$array->count();
		self::$array->addObject($obj);
		$this->assertEquals($originalCount + 1, self::$array->count());
	}




	public function testAddObjectThatIsNotAnRTObject()
	{
		try
		{
			self::$array->addObject(new stdClass);
		}
		catch(InvalidArgumentException $e)
		{
			return;
		}
		$this->fail("RTMutableArray::addObject should have thrown an "
			. "InvalidArgumentException when given an object that does "
			. "not inhert from RTObject");
	}




	public function testAddObjectsFromArrayWithPHPArray()
	{
		$mArray = RTMutableArray::anArray();
		$array = array(42, "42", YES);
		$mArray->addObjectsFromArray($array);
		$this->assertEquals(3, $mArray->count());
	}




	public function testAddObjectsFromArrayWithRTArray()
	{
		self::$array->removeAllObjects();
		$array = RTArray::arrayWithObjects(42, "42", YES);
		self::$array->addObjectsFromArray($array);
		$this->assertEquals(3, self::$array->count());
	}




	public function testAddObjectsFromArrayWithNonArrayThrowsException()
	{
		$array = "test";
		try
		{
			self::$array->addObjectsFromArray($array);
		}
		catch (InvalidArgumentException $e)
		{
			return;
		}
		$this->fail(
			"RTMutableArray::addObjectsWithArray should throw an "
			. "InvalidArgumentException when given a non-array"
		);
	}




	public function testRemoveAllObjects()
	{
		self::$array->removeAllObjects();
		self::$array->addObject("test");
		$this->assertEquals(1, self::$array->count());
		self::$array->removeAllObjects();
		$this->assertEquals(0, self::$array->count());
	}




	public function testRemoveLastObject()
	{
		$array = RTMutableArray::arrayWithObjects(42, YES);
		$array->removeLastObject();
		$this->assertEquals(1, $array->count());
		$this->assertEquals(42, $array->lastObject());
	}




	public function testRemoveObject()
	{
		self::$array->removeAllObjects();
		self::$array->addObjectsFromArray(array(42, "42", YES, NO));
		self::$array->removeObject("42");
		$this->assertEquals(3, self::$array->count());
		$this->assertEquals(42, self::$array->objectAtIndex(0));
		$this->assertEquals(YES, self::$array->objectAtIndex(1));
		$this->assertEquals(NO, self::$array->objectAtIndex(2));
	}




	public function testRemoveObjectAtIndex()
	{
		$mArray = RTMutableArray::anArray();
		$mArray->addObjectsFromArray(array(42, "42", YES, NO));
		$this->assertEquals(4, $mArray->count());
		$mArray->removeObjectAtIndex(2);
		$this->assertEquals(3, $mArray->count());
		$this->assertEquals(42, $mArray->objectAtIndex(0));
		$this->assertEquals("42", $mArray->objectAtIndex(1));
		$this->assertEquals(NO, $mArray->objectAtIndex(2));
	}




	public function testRemoveObjectsInArrayWithPHPArray()
	{
		$mArray = RTMutableArray::anArray();
		$mArray->addObjectsFromArray(array("42", 42, TRUE, FALSE));
		$mArray->removeObjectsInArray(array("42", TRUE));
		$this->assertEquals(2, $mArray->count());
		$this->assertSame(42, $mArray->objectAtIndex(0));
		$this->assertEquals(FALSE, $mArray->objectAtIndex(1));
	}




	public function testRemoveObjectsInArrayWithRTArray()
	{
		$mArray = RTMutableArray::anArray();
		$mArray->addObjectsFromArray(array("42", 42, TRUE, FALSE));
		$mArray->removeObjectsInArray(RTArray::arrayWithObjects("42", TRUE));
		$this->assertEquals(2, $mArray->count());
		$this->assertSame(42, $mArray->objectAtIndex(0));
		$this->assertEquals(FALSE, $mArray->objectAtIndex(1));
	}




	public function testRemoveObjectsInArrayWithNonArrayThrowsException()
	{
		self::$array->addObjectsFromArray(array("42", 42, TRUE, FALSE));
		try
		{
			self::$array->removeObjectsInArray("42");
		}
		catch(InvalidArgumentException $e)
		{
			return;
		}
		$this->fail(
			"RTMutableArray::removeObjectsInArray should thrown an invalid argument "
			. "exception when given a non array."
		);
	}




	public function testRemoveObjectsInRange()
	{
		$range = RTMakeRange(1, 2);
		self::$array->removeAllObjects();
		self::$array->addObjectsFromArray(array("42", 42, YES, NO));
		self::$array->removeObjectsInRange($range);
		$this->assertEquals(2, self::$array->count());
		$this->assertEquals("42", self::$array->objectAtIndex(0));
		$this->assertEquals(NO, self::$array->objectAtIndex(1));
	}




	public function testRemoveObjectsInRangeWithInvalidRange()
	{
		$range = RTMakeRange(0, 40);
		try
		{
			self::$array->removeObjectsInRange($range);
		}
		catch(RTRangeException $e)
		{
			return;
		}
		$this->fail(
			"RTMutableArray::removeObjectsInRange should throw RTRangeException when "
			. "the specified range is out of bounds"
		);
	}




	public function testArrayAccessImplementation()
	{
		parent::testArrayAccessImplementation();
		$array = RTMutableArray::arrayWithArray(array("42", 42, YES, NO));
		$this->assertFalse(isset($array[4]));
		$array[] = 54;
		$this->assertSame(54, $array[4]);
		$array[5] = 55;
		$this->assertSame(55, $array[5]);
		$array[4] = 53;
		$this->assertSame(53, $array[4]);
		unset($array[4]);
		$this->assertSame(55, $array[4]);
	}




	public function testInsertObject_atIndex()
	{
		$array = RTMutableArray::arrayWithArray(array("42", 42, YES, NO));
		try
		{
			$array->insertObject_atIndex(null, 0);
			$this->fail(
				"Should not be able to insert a null object");
		}
		catch (InvalidArgumentException $e)
		{
			try
			{
				$array->insertObject_atIndex("object", $array->count()+1);
				$this->fail(
					"Should not be able to add an object using an out of bounds index.");
			}
			catch (RTRangeException $e)
			{
				return;
			}
		}
		return fail("Expected specific exceptions to be thrown.");
	}
}
