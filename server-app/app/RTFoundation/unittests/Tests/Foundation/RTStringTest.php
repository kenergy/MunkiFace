<?php
require_once(dirname(__FILE__) . "/RTObjectTest.php");




class RTStringTest extends RTObjectTest
{
	public function setUp()
	{
		$this->string = RTString::alloc()->init();
	}




	public function testStaticString()
	{
		$string = RTString::string();
		$this->assertEquals($string, $this->string);
	}




	public function testStringWithFormat()
	{
		$string = RTString::stringWithFormat("This is %s %d", "test", 4);
		$this->assertEquals("This is test 4", $string);
		$string = RTString::stringWithFormat("This is %s %d", "test", "5");
		$this->assertEquals("This is test 5", $string);
	}




	public function testInitWithString()
	{
		$string = RTString::alloc()->initWithString("Lorem ipsum");
		$this->assertEquals("Lorem ipsum", $string);
	}




	public function testInitWithFormat()
	{
		$str = RTString::alloc()->initWithFormat("This is %s %d", "test", 4);
		$this->assertEquals("This is test 4", $str);
		$str = RTString::alloc()->initWithFormat("This is %s %d", "test", 5);
		$this->assertEquals("This is test 5", $str);
	}




	public function testBoolValue()
	{
		$Y = RTString::stringWithString("Yonkers");
		$y = RTString::stringWithString("yikes");
		$T = RTString::stringWithString("Towel");
		$t = RTString::stringWithString("tike");

		$this->assertFalse(RTString::stringWithString("0123456")->boolValue());
		$this->assertTrue($Y->boolValue());
		$this->assertTrue($y->boolValue());
		$this->assertTrue($T->boolValue());
		$this->assertTrue($t->boolValue());
		for($i = 1; $i < 10; $i++)
		{
			$string = RTString::stringWithString($i);
			$this->assertTrue($string->boolValue());
		}
	}




	public function testCapitalizedString()
	{
		$string = RTString::stringWithString("lorem ipsum");
		$this->assertEquals("LOREM IPSUM", $string->capitalizedString());
	}




	public function testCaseInsensitiveCompareSame()
	{
		$lhs = RTString::stringWithString("abc");
		$rhs = RTString::stringWithString("aBc");
		$this->assertEquals(RTOrderedSame, $rhs->caseInsensitiveCompare($lhs));
	}




	public function testCaseInsensitiveCompareAsending()
	{
		$lhs = RTString::stringWithString("bca");
		$rhs = RTString::stringWithString("aBc");
		$this->assertEquals(RTOrderedAscending, $rhs->caseInsensitiveCompare($lhs));
	}




	public function testCaseInsensitiveCompareDescending()
	{
		$lhs = RTString::stringWithString("aBc");
		$rhs = RTString::stringWithString("bca");
		$this->assertEquals(RTOrderedDescending, $rhs->caseInsensitiveCompare($lhs));
	}




	public function testLength()
	{
		$this->assertEquals(strlen($this->string), $this->string->length());
	}




	public function testCharacterAtIndex()
	{
		$idx = 1;
		$char = substr($this->string, $idx, 1);
		$this->assertEquals($char, $this->string->characterAtIndex($idx));
	}




	public function testCharacterAtIndexWithNonEmptyString()
	{
		$string = RTString::stringWithString("Lorem ipsum");
		$this->assertEquals($string->characterAtIndex(2), "r");
	}




	public function testStringByAppendingFormat()
	{
		$str = $this->string->stringByAppendingFormat("%d", 42);
		$this->assertEquals($this->string . "42", $str);
	}




	public function testStringByAppendingString()
	{
		$this->assertEquals(
			$this->string . "42",
			$this->string->stringByAppendingString("42")
		);
	}




	public function testComponentsSeparatedByString()
	{
		$raw = RTArray::arrayWithObjects("this", "is", "a", "csv", "string");
		$str = RTString::stringWithString($raw->componentsJoinedByString(","));
		$components = $str->componentsSeparatedByString(",");
		$this->assertEquals(5, $components->count());
		for($i = 0; $i < $components->count(); $i++)
		{
			$this->assertEquals(
				$raw->objectAtIndex($i),
				$components->objectAtIndex($i)
			);
		}
	}




	public function testRangeOfString()
	{
		$haystack = RTString::stringWithString("This is a test string");
		$needle = RTString::stringWithString("is a");
		$range = $haystack->rangeOfString($needle);
		$this->assertTrue(is_a($range, "RTRange"));
		$this->assertEquals(5, $range->location);
		$this->assertEquals(4, $range->length);
	}




	public function testRangeOfStringThatIsNotPresent()
	{
		$haystack = RTString::stringWithString("This is a test string");
		$needle = RTString::stringWithString("qwerty");
		$range = $haystack->rangeOfString($needle);
		$this->assertTrue(RTEmptyRange($range));
	}




	public function testHasPrefix()
	{
		$prefix = "qwerty";
		$string = RTString::stringWithString($prefix);
		$this->assertTrue($string->hasPrefix($prefix),
			"Matching strings should match prefix tests");
		$string = $string->stringByAppendingString("something else");
		$this->assertTrue($string->hasPrefix($prefix),
			"Valid prefix should be found");
		$this->assertFalse($string->hasPrefix(""),
			"Empty prefix should not be found");
		$this->assertFalse($string->hasPrefix("wertyu"),
			"Invalid prefix should not be found");
	}




	public function testHasSuffix()
	{
		$suffix = "qwerty";
		$string = RTString::stringWithString($suffix);
		$this->assertTrue($string->hasSuffix($suffix),
			"Matching strings should match suffix tests");
		$string = RTString::stringWithString("sdfas df" . $suffix);
		$this->assertTrue($string->hasSuffix($suffix),
			"Valid suffix should be found");
		$this->assertFalse($string->hasSuffix(""),
			"Empty suffix should not be found");
		$this->assertFalse($string->hasSuffix("asdfasdvsfvsfv"),
			"Invalid suffix should not be found");
	}




	public function testSubstringWithRangeThrowsExceptionWithInvalidLocation()
	{
		$string = RTString::stringWithString("This is a test");
		$range = RTMakeRange($string->length()+1, $string->length());
		try
		{
			$anotherString = $string->substringWithRange($range);
		}
		catch (RTRangeException $e)
		{
			return;
		}
		$this->fail("Should have thrown exception when range's location is beyond the end of the string");
	}




	public function testSubstringWithRangeThrowsExceptionWithInvalidLength()
	{
		$string = RTString::stringWithString("This is a test");
		$range = RTMakeRange(0, $string->length()+1);
		try
		{
			$anotherString = $string->substringWithRange($range);
		}
		catch (RTRangeException $e)
		{
			return;
		}
		$this->fail("Should have thrown exception when range's length is beyond the end of the string");
	}
}
