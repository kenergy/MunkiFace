<?php
require_once(dirname(__FILE__) . "/RTDictionaryTest.php");




class RTMutableDictionaryTest extends RTDictionaryTest
{

	public function setUp()
	{
		$this->dictionary = RTMutableDictionary::dictionaryWithObjects_andKeys(
			array("42", 42, YES, NO),
			array("one", "two", "three", "four")
		);
	}





	public function testDictionary()
	{
		$this->assertTrue($this->dictionary->className() == "RTMutableDictionary");
	}



	public function testAddEntriesFromDictionary()
	{
		$emptyDict = RTMutableDictionary::dictionary();
		
		$this->assertEquals(0, $emptyDict->count());
		$emptyDict->addEntriesFromDictionary($this->dictionary);
		$this->assertEquals($this->dictionary->count(), $emptyDict->count());
	}




	public function testAddEntriesFromDictionaryOverwritingKeys()
	{
		$anotherDict = RTDictionary::dictionaryWithObjects_andKeys(
			array("42", 42, YES, NO),
			array("one", "two", "three", "five")
		);

		$this->assertEquals(4, $anotherDict->count());
		$this->dictionary->addEntriesFromDictionary($anotherDict);
		$this->assertEquals(5, $this->dictionary->count());
		$expectedKeys = RTArray::arrayWithObjects(
			"one", "two", "three", "four", "five"
		);
		$this->assertTrue($expectedKeys->isEqualToArray($this->dictionary->allKeys()));
	}




	public function testRemoveAllObjects()
	{
		$this->assertGreaterThan(0, $this->dictionary->count());
		$this->dictionary->removeAllObjects();
		$this->assertEquals(0, $this->dictionary->count());
	}




	public function testRemoveObjectForKey()
	{
		$key = $this->dictionary->allKeys()->firstObject();
		$obj = $this->dictionary->objectForKey($key);
		$this->dictionary->removeObjectForKey($key);
		$this->assertNull($this->dictionary->keyForObject($obj));
	}




	public function testRemoveObjectForKeyThatDoesNotExist()
	{
		$expectedCount = $this->dictionary->count();
		$this->assertGreaterThan(0, $expectedCount);
		$this->dictionary->removeObjectForKey("EA7838A9-28CE-42E1-9510-B425E0CAB1F5");
		$this->assertSame($expectedCount, $this->dictionary->count());
	}




	public function testRemoveObjectsForKeys()
	{
		$dict = $this->dictionary;
		$keys = $dict->allKeys();
		$keysToRemove = RTArray::arrayWithObjects(
			$keys->firstObject(),
			$keys->lastObject()
		);
		$dict->removeObjectsForKeys($keysToRemove);
		$this->assertNull($dict->objectForKey($keysToRemove->firstObject()));
		$this->assertNull($dict->objectForKey($keysToRemove->lastObject()));
	}




	public function testRemoveObjectsWithPHPArrayOfKeys()
	{
		$dict = $this->dictionary;
		$keys = $dict->allKeys();
		$keysToRemove = RTArray::arrayWithObjects(
			$keys->firstObject(),
			$keys->lastObject()
		);
		$dict->removeObjectsForKeys($keysToRemove->phpArray());
		$this->assertNull($dict->objectForKey($keysToRemove->firstObject()));
		$this->assertNull($dict->objectForKey($keysToRemove->lastObject()));
	}




	public function testSetDictionary()
	{
		$dict = RTDictionary::dictionaryWithObjects_andKeys(
			array("once there was a story"),
			array("one")
		);
		$this->assertFalse($this->dictionary->isEqualToDictionary($dict));
		$this->dictionary->setDictionary($dict);
		$this->assertTrue($this->dictionary->isEqualToDictionary($dict));
	}




	public function testSetObject_forKey()
	{
		$obj = "this is an object";
		$key = "and this is a key";
		$this->dictionary->setObject_forKey($obj, $key);
		$this->assertEquals($key, $this->dictionary->keyForObject($obj));
		$this->assertEquals($obj, $this->dictionary->objectForKey($key));
	}




	public function testSetObject_forKeyWithInvalidObject()
	{
		$obj = new self();
		$key = "and this is a key";
		try
		{
			$this->dictionary->setObject_forKey($obj, $key);
		}
		catch(InvalidArgumentException $e)
		{
			return;
		}
		$this->fail(
			"RTMutableDictionary::setObject_forKey should have thrown an "
			. "InvalidArgumentException when given an object that doesn't inherit "
			. "from RTObject. Was given an instance of '" . get_class($obj) . "'"
		);
	}





	public function testSetObject_forKeyWithNullKey()
	{
		$obj = "this is an object";
		$key = null;
		try
		{
			$this->dictionary->setObject_forKey($obj, $key);
		}
		catch(InvalidArgumentException $e)
		{
			return;
		}
		$this->fail(
			"RTMutableDictionary::setObject_forKey should have thrown an "
			. "InvalidArgumentException when given a null key"
		);
	}




	public function testOffsetSet()
	{
		$this->dictionary["testKey"] = "Test Value";
		$this->assertEquals("Test Value",
			$this->dictionary->objectForKey("testKey"));
	}




	public function testoffsetUnset()
	{
		$key = $this->dictionary->allKeys()->lastObject();
		$this->assertNotNull($key);
		$this->assertNotNull($this->dictionary->objectForKey($key));
		unset($this->dictionary[$key]);
		$this->assertNull($this->dictionary->objectForKey($key));
	}
}
