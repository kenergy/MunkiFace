<?php
require_once(dirname(__FILE__) . "/RTObjectTest.php");



class RTDictionaryTest extends RTObjectTest
{
	protected $dictionary;



	public function setUp()
	{
		$this->dictionary = RTDictionary::alloc()->init();
	}




	public function testDictionary()
	{
		$dict = RTDictionary::dictionary();
		$this->assertTrue(is_object($dict));
		$this->assertTrue(is_a($dict, "RTDictionary"));
	}




	public function testDictionaryWithDictionary()
	{
		$dict = RTDictionary::dictionaryWithDictionary($this->dictionary);
		$this->assertTrue(is_object($dict));
		$this->assertTrue(is_a($dict, "RTDictionary"));
	}



	public function testDictionaryWithObject_forKey()
	{
		$dict = RTDictionary::dictionaryWithObject_forKey("42", "one");
		$this->assertEquals(1, $dict->count());
		$this->assertEquals("42", $dict->objectForKey("one"));
		$this->assertEquals("one", $dict->allKeys()->objectAtIndex(0));
	}




	public function testDictionaryWithObjects_andKeys()
	{
		$objects = array("42", 42, YES, NO);
		$keys = array("one", "two", "three", "four");
		$dict = RTDictionary::dictionaryWithObjects_andKeys($objects, $keys);
		$this->assertEquals(count($objects), $dict->allValues()->count());
		$this->assertEquals(count($keys), $dict->allKeys()->count());
		for($i = 0; $i < count($objects); $i++)
		{
			$expectedValue = $objects[$i];
			$expectedKey = $keys[$i];
			$actualKey = $dict->allKeys()->objectAtIndex($i);
			$actualValue = $dict->objectForKey($actualKey);
			$this->assertEquals($expectedValue, $actualValue);
			$this->assertEquals($expectedKey, $actualKey);
		}
	}




	public function testInit()
	{
		$this->assertSame(0, count(RTDictionary::dictionary()->phpArray()));
	}




	public function testInitWithContentsOfFile()
	{
		$file = RTString::stringWithString(
			dirname(__FILE__) . "/_files/sample.xml.plist"
		);
		$dict = RTDictionary::alloc()->initWithContentsOfFile($file);
		$this->assertEquals(7, $dict->count());
		$this->assertSame(1965, $dict->objectForKey("Year Of Birth"));
		$this->assertSame(1087932223, $dict->objectForKey("Date Of Graduation"));
		$this->assertEquals("RTArray",
			$dict->objectForKey("Pets Names")->className());
		$this->assertEquals(0, $dict->objectForKey("Pets Names")->count());
		$this->assertEquals("PEKBpYGlmYFCPA==",
			base64_encode($dict->objectForKey("Picture")));
		$this->assertEquals("Springfield", $dict->objectForKey("City Of Birth"));
		$this->assertEquals("John Doe", $dict->objectForKey("Name"));
		$kidsNames = $dict->objectForKey("Kids Names");
		$this->assertEquals("RTArray", $kidsNames->className());
		$this->assertEquals(2, $kidsNames->count());
		$this->assertEquals("John", $kidsNames->objectAtIndex(0));
		$this->assertEquals("Kyra", $kidsNames->objectAtIndex(1));
	}




	public function testInitWithObjects_forKeys()
	{
		$dict = RTDictionary::alloc()->initWithObjects_forKeys(
			array(42, "42", YES, NO),
			array("one", "two" , "three", "four")
		);
		$this->assertSame(4, count($dict->phpArray()));
	}




	public function testInitWithObjects_forKeysWithNonArrays()
	{
		try
		{
			$dict = RTDictionary::alloc()->initWithObjects_forKeys("42", "one");
		}
		catch(InvalidArgumentException $e)
		{
			return;
		}
		$this->fail(
			"RTDictionary::initWithObjectsForKeys should have thrown an "
			. "InvalidArgumentException when either parameter is not an array"
		);
	}





	public function testInitWithObjects_forKeysWithUnmatchedArrays()
	{
		$objects = array(42);
		$keys = array("one", "two");
		try
		{
			$dict = RTDictionary::alloc()->initWithObjects_forKeys($objects, $keys);
		}
		catch (InvalidArgumentException $e)
		{
			return;
		}
		$this->fail(
			"RTDictionary::initWithObjects_forKeys should throw an "
			. "InvalidArgumentException when the number of keys != the number of "
			. "objects"
		);
	}




	public function testDescription()
	{
		$dict = RTDictionary::dictionaryWithObjects_andKeys(
			array("42", 43, NO),
			array("one", "two", "three")
		);
		$this->assertEquals(
			'{"one":"42","two":43,"three":false}',
			$dict->description()
		);
	}




	public function testDescriptionWithNestedArrays()
	{
		$anArray = RTArray::arrayWithObjects("one", "two");
		$objects = array(42, $anArray);
		$keys = array("one", "two");
		$dict = RTDictionary::dictionaryWithObjects_andKeys($objects, $keys);

		$phpArray = json_decode($dict->description());
		$dictTwo = RTDictionary::dictionaryWithPHPArray($phpArray);
		$this->assertEquals($dict->description(), $dictTwo->description());
	}




	public function testDescriptionWithNestedDictionary()
	{
		$aDict = RTDictionary::dictionaryWithObject_forKey("42", "one");
		$objects = array(42, $aDict);
		$keys = array("one", "two");
		$dict = RTDictionary::dictionaryWithObjects_andKeys($objects, $keys);

		$this->assertEquals('{"one":42,"two":{"one":"42"}}', $dict->description());
	}




	public function testAllKeys()
	{
		$keys = RTArray::arrayWithObjects("_keyOne", "_keyTwo");
		$objects = RTArray::arrayWithObjects("test", null);
		
		$dict = RTDictionary::alloc()->initWithObjects_forKeys($objects, $keys);
		$this->assertEquals($keys->count(), $dict->allKeys()->count());
		$this->assertTrue($keys->isEqualToArray($dict->allKeys()));
	}




	public function testAllValues()
	{
		$keys = RTArray::arrayWithObjects("one", "two", "three");
		$objects = RTArray::arrayWithObjects("42", 42, NO);
		$dict = RTDictionary::dictionaryWithObjects_andKeys($objects, $keys);
		$this->assertEquals($objects->count(), $dict->allValues()->count());
		$this->assertTrue($objects->isEqualToArray($dict->allValues()));
	}




	public function testCount()
	{
		$expectedCount = count($this->dictionary->phpArray());
		$actualCount = $this->dictionary->count();
		$this->assertEquals($expectedCount, $actualCount);
	}




	public function testInitWithDictionary()
	{
		$objects = array("42", 42, YES, NO);
		$keys = array("one", "two", "three", "four");
		$dictOne = RTDictionary::alloc()->initWithObjects_forKeys($objects, $keys);
		$dictTwo = RTDictionary::alloc()->initWithDictionary($dictOne);
		$this->assertSame($dictOne->count(), $dictTwo->count());
		$keys = $dictOne->allKeys();
		for($i = 0; $i < $keys->count(); $i++)
		{
			$this->assertSame(
				$dictOne->objectForKey($keys->objectAtIndex($i)),
				$dictTwo->objectForKey($keys->objectAtIndex($i))
			);
		}
	}




	public function testKeyForObject()
	{
		$objects = array("42", 42, YES, NO);
		$keys = array("one", "two", "three", "four");
		$dict = RTDictionary::dictionaryWithObjects_andKeys($objects, $keys);
		$this->assertEquals("three", $dict->keyForObject(YES));
	}




	public function testObjectForKey()
	{
		$objects = array("42", 42);
		$keys = array("one", "two");
		$dict = RTDictionary::alloc()->initWithObjects_forKeys($objects, $keys);
		$this->assertEquals("42", $dict->objectForKey("one"));
		$this->assertEquals(42, $dict->objectForKey("two"));
	}




	public function testObjectForKeyWithInvalidKey()
	{
		$objects = array("42", 42);
		$keys = array("one", "two");
		$dict = RTDictionary::alloc()->initWithObjects_forKeys($objects, $keys);
		$this->assertNull($dict->objectForKey("three"));
	}




	public function testIsEqualToDictionary()
	{
		$dictOne = RTDictionary::alloc()->initWithObjects_forKeys(
			array("42"),
			array("one")
		);
		$dictTwo = RTDictionary::alloc()->initWithDictionary($dictOne);
		$dictThree = RTDictionary::alloc()->initWithObjects_forKeys(
			array("43"),
			array("one"));
		$this->assertTrue($dictOne->isEqualtoDictionary($dictTwo));
		$this->assertFalse($dictOne->isEqualtoDictionary($dictThree));
		$this->assertFalse($dictTwo->isEqualtoDictionary($dictThree));
	}




	public function testInitWithPHPArray()
	{
		$array = array(
			"one" => "42",
			"two" => 42,
			"three" => YES,
			"four" => RTArray::arrayWithObjects("42", 42, YES, NO)
		);
		$dict = RTDictionary::alloc()->initWithPHPArray($array);
		$this->assertEquals(4, $dict->count());

		$rtArray = RTArray::arrayWithObject($array);
		$dict = RTDictionary::alloc()->initWithPHPArray($rtArray);
		$this->assertEquals(1, $dict->count());
	}




	public function testRTPHPArrayIsRTDictionary()
	{
		$this->assertTrue(RTPHPArrayIsRTDictionary(array(
			"one" => "42"
		)));
		$this->assertFalse(RTPHPArrayIsRTDictionary(array(42)));
	}




	public function testRTPHPArrayIsRTArray()
	{
		$this->assertTrue(RTPHPArrayIsRTArray(array(42)));
		$this->assertFalsE(RTPHPArrayIsRTArray(array(
			"one" => 42
		)));
	}




	public function testArrayAccessImplementation()
	{
		$dict = RTDictionary::alloc()->initWithPHPArray(array(
			"one" => "42",
			"two" => 42,
			"three" => YES,
			"four" => "blah"
		));
		$this->assertTrue(isset($dict["one"]));
		$this->assertFalse(isset($dict["five"]));
		$keys = $dict->allKeys();
		for($i = 0; $i < $keys->count(); $i++)
		{
			$key = $keys->objectAtIndex($i);
			$this->assertSame($dict[$key], $dict->objectForKey($key));
		}




		try
		{
			$dict["five"] = "test";
			$this->fail(
				"Should not be able to set a new value for an immutable dictionary.");
		}
		catch (Exception $e)
		{
			try
			{
				unset($dict["one"]);
				$this->fail(
					"Should not be able to remove an object from an immutable dictionary.");
			}
			catch (Exception $e)
			{
				return;
			}
		}
	}




	public function testIteratorImplementation()
	{
		$dict = RTDictionary::alloc()->initWithPHPArray(array(
			"one" => "42",
			"two" => 42,
			"three" => YES,
			"four" => "blah"
		));
		foreach($dict as $key => $val)
		{
			$this->assertSame($val, $dict->objectForKey($key));
		}
	}
}
