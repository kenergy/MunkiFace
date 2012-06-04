<?php
require_once(dirname(__FILE__) . "/RTObjectTest.php");



class RTArrayTest extends RTObjectTest
{
	protected static $fixture;
	protected static $array;

	public function setUp()
	{
		self::$fixture = array(
			"42",
			42,
			YES,
			NO
		);

		self::$array = RTArray::arrayWithArray(self::$fixture);
	}

	public function testAnArrayConstructor()
	{
		$this->assertTrue(is_object(self::$array));
	}




	public function testArrayWithArray()
	{
		$this->assertTrue(is_object(self::$array));
	}




	public function testArrayWithObject()
	{
		$a = RTArray::arrayWithObject("This is a test");
		$this->assertTrue(is_object($a));
		$this->assertEquals($a->count(), 1);
		$this->assertEquals($a->objectAtIndex(0), "This is a test");
	}




	public function testArrayWithObjectThrowsExceptionWithNonRTObject()
	{
		try
		{
			$obj = new stdClass;
			$array = RTArray::arrayWithObject($obj);
		}
		catch(InvalidArgumentException $e)
		{
			return;
		}
		$this->fail(
			"RTArray::arrayWithObject should throw an exception when given an object "
			. "that doesn't inherit from RTObject");
	}




	public function testInitWithObjects()
	{
		$a = RTArray::alloc()->initWithArray(self::$fixture);
		$this->assertTrue(is_object($a));
	}



	public function testInitWithObjectsThrowsException()
	{
		try
		{
			RTArray::alloc()->initWithArray("This is not an array");
		}
		catch(Exception $e)
		{
			return;
		}
		$this->fail('RTArray::initWithArray should throw an exception when passed a non-array');
	}




	public function testInitWithArrayThrowsExceptionWithNonRTObjects()
	{
		$objs = array(42, "42", new stdClass, null, NO);
		try
		{
			$array = RTArray::alloc()->initWithArray($objs);
		}
		catch (InvalidArgumentException $e)
		{
			return;
		}
		$this->fail(
			"RTArray::initWithArray should throw an exception when the array "
			. "contains an object that does not inherit from RTObject");
	}




	public function testInitWithArrayOfArrays()
	{
		$objs = array(
			array("123", "456"),
			array("abc", "def")
		);
		$a = RTArray::alloc()->initWithArray($objs);
		$this->assertEquals(2, $a->count());
		$elem1 = $a->objectAtIndex(0);
		$elem2 = $a->objectAtIndex(1);
		$this->assertEquals(2, $elem1->count());
		$this->assertEquals(2, $elem2->count());
	}




	public function testComponentsJoinedByString()
	{
		$parts = self::$array->phpArray();
		$str = implode(",", $parts);
		$this->assertEquals(
			self::$array->componentsJoinedByString(","),
			$str
		);
	}




	public function testContainsObject()
	{
		foreach(self::$fixture as $obj)
		{
			$this->assertTrue(self::$array->containsObject($obj));
		}
	}




	public function testCount()
	{
		$rawCount = count(self::$fixture);
		$this->assertEquals($rawCount, self::$array->count());
	}




	public function testDescriptionIsJsonEncoded()
	{
		$rawJson = json_encode(self::$fixture);
		$this->assertSame($rawJson, self::$array->description());
	}




	public function testDescription()
	{
		$array = RTArray::arrayWithObjects(
			RTArray::arrayWithObjects("one"),
			"two"
		);
		$this->assertEquals('[["one"],"two"]', $array->description());
	}




	public function testDescriptionWithComplexDataStructures()
	{
		$nativeArray = array(
			array(
				"negative number" => -1,
				"zero" => 0,
				"positive number" => 1,
				"PHP string" => "a native string",
				"RTString" => RTString::stringWithString("an RTString instance"),
				"RTDictionary" => RTDictionary::dictionaryWithObject_forKey(YES, "aBool"),
				"aBoolean YES" => YES,
				"aBoolean NO" => NO,
				"null" => null,
				"Empty RTArray", RTArray::anArray()
			),
			RTString::stringWithString("Another RTString"),
			42,
			null
		);
	
		$array = RTArray::arrayWithArray($nativeArray);
		$this->assertSame(
			'[{"negative number":-1,"zero":0,"positive number":1,'
			. '"PHP string":"a native string","RTString":"an RTString instance",'
			. '"RTDictionary":{"aBool":true},"aBoolean YES":true,"aBoolean NO":false,'
			. '"null":,"0":"Empty RTArray","1":[]},"Another RTString",42,]',
			$array->description()
		);
	}




	public function testLastObject()
	{
		$this->assertSame(self::$fixture[count(self::$fixture)-1],
		self::$array->lastObject());
	}




	public function testLastObjectOnEmptyArray()
	{
		$array = RTArray::anArray();
		$this->assertNull($array->lastObject());
	}




	public function testObjectAtIndex()
	{
		try
		{
			for($i = 0; $i <= self::$array->count(); $i++)
			{
				$this->assertEquals(self::$array->objectAtIndex($i), self::$fixture[$i]);
			}
		}
		catch(RTRangeException $e)
		{
			return;
		}
		$this->fail("Expected RTRangeException");
	}




	public function testIndexOfObject()
	{
		$objects = array("one", "two", YES, NO, null, "twenty");
		$array = RTArray::arrayWithArray($objects);
		for($i = 0; $i < count($objects); $i++)
		{
			$obj = $objects[$i];
			$this->assertEquals($i, $array->indexOfObject($objects[$i]),
				"Expected '" . $obj . "' to be at index '" . $i . "'");
		}
	}




	public function testIndexOfObjectWhenObjectDoesNotExist()
	{
		$this->assertSame(RTNotFound, self::$array->indexOfObject("sadhbasdfkhj"));
	}




	public function testInitWithContentsOfFile()
	{
		$file = "/tmp/phpunittmp";
		self::$array->writeToFile($file);
		$array = RTArray::alloc()->initWithContentsOfFile($file);
		unlink($file);
		$this->assertTrue($array->isEqualToArray(self::$array));
	}




	public function testInitWithContentsOfFileWhenFileDoesNotExist()
	{
		$array = RTArray::alloc()->initWithContentsOfFile("/tmp/should/not.exist");
		$this->assertNotEquals($array, self::$array);
		$this->assertTrue(is_object($array));
		$this->assertEquals("RTArray", $array->className());
		$this->assertEquals(0, $array->count());
	}




	public function testInitWithContentsOfFileWhenFileIsNotParsable()
	{
		$file = "/tmp/phpunttmp";
		file_put_contents($file, "√");
		$array = RTArray::alloc()->initWithContentsOfFile($file);
		unlink($file);
		$this->assertTrue(is_object($array));
		$this->assertTrue(is_a($array, "RTArray"));
		$this->assertEquals(0, $array->count());
	}




	public function testIsEqualToArray()
	{
		$array = RTArray::arrayWithArray(self::$array);
		$this->assertTrue($array->isEqualToArray(self::$array));
	}




	public function testIsEqualToArrayWithDifferentArray()
	{
		$array = RTArray::anArray();
		$this->assertFalse($array->isEqualToArray(self::$array));
	}



	public function testIsEqualToArrayWithSimilarArray()
	{
		$tmpArray = array();
		for($i = 0; $i < self::$array->count(); $i++)
		{
			$tmpArray[] = "nil";
		}

		$similarArray = RTArray::arrayWithArray($tmpArray);
		$this->assertSame($similarArray->count(), self::$array->count());
		$this->assertFalse(self::$array->isEqualToArray($similarArray));
	}




	public function testIsEqualToArrayWithNonmatchingPrimitiveDataTypes()
	{
		$objects = array("test", 42, "42", TRUE, FALSE);
		$array = RTArray::arrayWithArray($objects);
		$objects[1] = 43;
		$similarArray = RTArray::arrayWithArray($objects);
		$this->assertFalse($array->isEqualToArray($similarArray));
	}




	public function testSubarrayWithRange()
	{
		$array = self::$array->subarrayWithRange(RTMakeRange(0, 1));
		$this->assertTrue(is_object($array));
		$this->assertEquals("RTArray", $array->className());
		$this->assertEquals(2, $array->count());
		for($i = 0; $i < $array->count(); $i++)
		{
			$this->assertEquals($array->objectAtIndex($i), self::$fixture[$i]);
		}
	}




	public function testWriteToFile()
	{
		$path = "/tmp/phpunit.testing";
		self::$array->writeToFile($path);
		$this->assertTrue(is_file($path));
		unlink($path);
	}




	public function testArrayAccessImplementation()
	{
		$array = RTArray::arrayWithArray(array(
			"test","one","two","three","mic check"
		));
		$this->assertFalse(isset($array[-1]));
		$this->assertFalse(isset($array["0"]));
		$this->assertFalse(isset($array[$array->count()]));
		for($i = 0; $i < $array->count(); $i++)
		{
			$this->assertTrue(isset($array[$i]));
			$this->assertEquals($array[$i], $array->objectAtIndex($i));
		}
	}




	public function testArrayAccessIsImmutable()
	{
		try
		{
			self::$array[0] = "test";
			$this->fail(
				"Should not have been able to set a value on an immutable array");
		}
		catch (Exception $e)
		{
			try
			{
				unset(self::$array[0]);
				$this->fail(
				"Should not have been able to remove an object from an immutable array.");
			}
			catch(Exception $e)
			{
				return;
			}
		}
	}




	public function testIteratorImplementation()
	{
		$array = RTArray::arrayWithArray(array(
			"test","one","two","three","mic check"
		));
		foreach($array as $key => $val)
		{
			$this->assertEquals($val, $array->objectAtIndex($key));
		}
	}
}
