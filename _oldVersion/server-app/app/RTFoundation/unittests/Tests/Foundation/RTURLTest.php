<?php

require_once(dirname(__FILE__) . "/RTObjectTest.php");

class RTURLTest_subclass
{
	public function __tostring()
	{
		return RTURLTest::URL_STRING;
	}
}

class RTURLTest extends RTObjectTest
{
	protected $url;
	const URL_STRING =
	"http://username:password@www.google.com:80/index.html?test=testing#para1";

	public function setUp()
	{
		$this->url = RTURL::URLWithString(self::URL_STRING);
	}




	public function testURLWithString()
	{
		$this->assertSame($this->url->description(), self::URL_STRING);
	}




	public function testInitWithString()
	{
		$url = RTURL::alloc()->initWithString(self::URL_STRING);
		$this->assertSame($url->description(), self::URL_STRING);
	}




	public function testInitWithStringWithCustomObject()
	{
		$obj = new RTURLTest_subclass();
		$url = RTURL::alloc()->initWithString($obj);
		$this->assertEquals($url->description(), self::URL_STRING);
	}




	public function testHost()
	{
		$this->assertEquals($this->url->host(), "www.google.com");
	}




	public function testHostIsNull()
	{
		$url = RTURL::URLWithString("file:///tmp");
		$this->assertNull($url->host());
	}




	public function testFragment()
	{
		$this->assertEquals($this->url->fragment(), "para1");
	}




	public function testFragmentIsNull()
	{
		$url = RTURL::URLWithString("http://www.google.com");
		$this->assertNull($url->fragment());
	}




	public function testLastPathComponent()
	{
		$url = RTURL::URLWithString("http://wwww.google.com/index.html?test#para1");
		$this->assertEquals($url->lastPathComponent(), "index.html");
	}




	public function testLastPathComponentIsEmpty()
	{
		$url = RTURL::URLWithString("http://www.google.com");
		$this->assertEquals($url->lastPathComponent(), "");
	}




	public function testParamterString()
	{
		$this->assertEquals($this->url->parameterString(), "test=testing");
	}




	public function testParameterStringIsNull()
	{
		$url = RTURL::URLWithString("http://www.google.com#para1");
		$this->assertNull($url->parameterString());
	}




	public function testPassword()
	{
		$this->assertEquals($this->url->password(), "password");
	}




	public function testPasswordIsNull()
	{
		$url = RTURL::URLWithString("http://www.google.com");
		$this->assertNull($url->password());
	}




	public function testPath()
	{
		$this->assertEquals($this->url->path(), "/index.html");
	}




	public function testPathDefaultsToForwardSlash()
	{
		$url = RTURL::URLWithString("http://www.google.com");
		$this->assertEquals("/", $url->path());
	}




	public function testPathComponents()
	{
		$this->assertEquals(1, $this->url->pathComponents()->count());
		$this->assertEquals(
			"index.html",
			$this->url->pathComponents()->objectAtIndex(0)
		);
	}




	public function testPathComponentsIsEmpty()
	{
		$url = RTURL::URLWithString("http://www.google.com");
		$this->assertEquals(1, $url->pathComponents()->count());
		$this->assertEquals("", $url->pathComponents()->objectAtIndex(0));
	}




	public function testPathExtension()
	{
		$this->assertEquals($this->url->pathExtension(), "html");
	}




	public function testPathExtensionIsEmpty()
	{
		$url = RTURL::URLWithString("http://www.google.com");
		$this->assertEquals($url->pathExtension(), "");
	}




	public function testPort()
	{
		$this->assertSame($this->url->port(), 80);
	}




	public function testPortIsNull()
	{
		$url = RTURL::URLWithString("http://www.google.com");
		$this->assertNull($url->port());
	}




	public function testQuery()
	{
		$this->assertEquals($this->url->query(), "test=testing");
	}




	public function testScheme()
	{
		$this->assertEquals($this->url->scheme(), "http");
	}




	public function testSchemeDefaultsToFile()
	{
		$url = RTURL::URLWithString("www.google.com");
		$this->assertEquals("file", $url->scheme());
	}




	public function testUser()
	{
		$this->assertEquals($this->url->user(), "username");
	}




	public function testUserIsEmpty()
	{
		$url = RTURL::URLWithString("http://www.google.com");
		$this->assertEquals($url->user(), "");
	}




	public function testIsFileURLWithAmbiguousSchema()
	{
		$url = RTURL::URLWithString("/tmp");
		$this->assertTrue($url->isFileURL());
	}




	public function testIsFileURL()
	{
		$url = RTURL::URLWithString("/tmp");
		$this->assertTrue($url->isFileURL());
	}




	public function testIsNotFileURL()
	{
		$this->assertFalse($this->url->isFileURL());
	}
}
