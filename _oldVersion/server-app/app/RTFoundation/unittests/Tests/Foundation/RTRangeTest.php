<?php


require_once(dirname(__FILE__) . "/RTObjectTest.php");



class RTRangeTest extends RTObjectTest
{

	protected $range;

	public function setUp()
	{
		$this->range = RTMakeRange(0, 1024);
	}
	
	
	
	
	public function testMakeRange()
	{
		$this->assertTrue(is_object($this->range));
		$this->assertEquals("RTRange", $this->range->className());
	}




	public function testMakeRangeWithRTObjectsAsArguments()
	{
		$location = RTString::stringWithString("100");
		$length = RTString::stringWithString("10");
		$range = RTMakeRange($location, $length);
		$this->assertSame($range->location, 100.0);
		$this->assertSame($range->length, 10.0);
	}




	public function testCopyRange()
	{
		$copy = RTCopyRange($this->range);
		$this->assertNotSame($copy, $this->range);
		$this->assertEquals($copy, $this->range);
	}




	public function testMakeRangeCopy()
	{
		$copy = RTMakeRangeCopy($this->range);
		$this->assertNotSame($copy, $this->range);
		$this->assertEquals($copy, $this->range);
	}




	public function testEmptyRange()
	{
		$this->assertFalse(RTEmptyRange($this->range));
		$emptyRange = RTMakeRange(4, 0);
		$this->assertTrue(RTEmptyRange($emptyRange));
	}




	public function testMaxRange()
	{
		$max = $this->range->location + $this->range->length;
		$this->assertEquals($max, RTMaxRange($this->range));
	}




	public function testEqualRanges()
	{
		$range = RTCopyRange($this->range);
		$this->assertTrue(RTEqualRanges($range, $this->range));
		$differentRange = RTMakeRange(40, 4);
		$this->assertFalse(RTEqualRanges($differentRange, $this->range));
	}




	public function testLocationInRange()
	{
		$location = $this->range->location;
		$this->assertTrue(RTLocationInRange($location, $this->range),
			"location = location should be true");
		$location++;
		$this->assertTrue(RTLocationInRange($location, $this->range),
			"location = location + 1 should be true");
		$location = $this->range->location - 1;
		$this->assertFalse(RTLocationInRange($location, $this->range),
			"location = location - 1 should be false");
		$location = $this->range->location + $this->range->length;
		$this->assertTrue(RTLocationInRange($location, $this->range),
			"location = location + length should be true");
		$location = $this->range->location + $this->range->length + 1;
		$this->assertFalse(RTLocationInRange($location, $this->range),
			"location = location + length + 1 should be false.");
	}




	public function testUnionRange()
	{
		$altRange = RTMakeRange(0, 1);
		$minLocation = min($altRange->location, $this->range->location);
		$maxLength = max(RTMaxRange($altRange), RTMaxRange($this->range)) - $minLocation;

		$unionedRange = RTUnionRange($altRange, $this->range);

		$this->assertEquals($minLocation, $unionedRange->location);
		$this->assertEquals($maxLength, $unionedRange->length);

	}




	public function testIntersectionRange()
	{
		$lhsLocation = RTMaxRange($this->range) - $this->range->length/2;
		$lhsLength = $this->range->length * 2;

		$lhsRange = RTMakeRange($lhsLocation, $lhsLength);
		$rhsRange = $this->range;

		$intersectedRange = RTIntersectionRange($lhsRange, $rhsRange);

		$this->assertEquals($lhsLocation, $intersectedRange->location);
		$this->assertEquals($this->range->length, $intersectedRange->length);
	}




	public function testNonintersectingRange()
	{
		$lhsLocation = RTMaxRange($this->range) + 1;
		$lhsLength = 1;
		$lhsRange = RTMakeRange($lhsLocation, $lhsLength);
		$rhsRange = $this->range;

		$intersectedRange = RTIntersectionRange($lhsRange, $rhsRange);
		$this->assertSame(0, $intersectedRange->location);
		$this->assertSame(0, $intersectedRange->length);
	}




	public function testRangeInRange()
	{
		$lhsRange = RTMakeRange(0, 0);
		$rhsRange = $this->range;

		$this->assertFalse(RTRangeInRange($lhsRange, $rhsRange));

		$lhsRange = RTCopyRange($rhsRange);
		$this->assertTrue(RTRangeInRange($lhsRange, $rhsRange));
		
		$rhsRange->location--;
		$rhsRange->length++;
		$this->assertFalse(RTRangeInRange($lhsRange, $rhsRange));
	}




	public function testStringFromRange()
	{
		$string = json_encode($this->range);
		$this->assertEquals($string, RTStringFromRange($this->range));
	}




	public function testRangeFromString()
	{
		$aRange = RTRangeFromString(RTStringFromRange($this->range));
		$this->assertEquals($aRange, $this->range);
	}
}
