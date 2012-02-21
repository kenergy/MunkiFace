<?php


class RTObjectTest extends PHPUnit_Framework_TestCase
{
	public function testCanAlloc()
	{
		$obj = RTObject::alloc();
		$this->assertTrue(is_object($obj));
	}
	
	
	
	
	public function testCanInit()
	{
		$obj = RTObject::alloc()->init();
		$this->assertTrue(is_object($obj));
	}




	public function testCanSeeClassName()
	{
		if (get_class() == "RTObjectTest")
		{
			$obj = RTObject::alloc()->init();
			$this->assertEquals("RTObject", $obj->className());
		}
	}




	public function testDescription()
	{
		$obj = RTObject::alloc()->init();
		$tmp = json_encode($obj);
		$this->assertEquals($tmp, $obj->description());
	}
}
