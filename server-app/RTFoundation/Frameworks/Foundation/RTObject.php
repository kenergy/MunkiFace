<?php

/**
	The base class for all other objects within the RT framework.
	\ingroup Foundation
 */
class RTObject
{

	/**
		Constructs a new instance of the class and returns it. This instance should
		not be considered ready to use until the init method has been called. In
		most cases, you'll create a new instance of any class in the following way:
		<code>$obj = RTObject::alloc()->init();</code>
		\returns object
	 */
	public static function alloc()
	{
		eval("\$o = new " . get_called_class() . "();");
		return $o;
	}




	/**
		This is used to initialize all of the fields and properties of an instance.
		This method only returns $this in the RTObject class, but subclasses will
		use it to initialize arrays, dictionarys and so on.
		\returns object
	 */
	public function init()
	{
		return $this;
	}




	/**
		Returns the class name of the sender.
		\returns RTString
	 */
	public function className()
	{
		return RTString::stringWithString(get_class($this));
	}




	/**
		Returns the printable representation of this object.
		\returns RTString
	 */
	public function description()
	{
		return RTString::stringWithString(json_encode($this));
	}




	public function __tostring()
	{
		return $this->description();
	}
}
