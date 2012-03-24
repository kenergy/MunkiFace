<?php
require_once dirname(__FILE__) . "/AbstractModel.php";

class ReadAction extends AbstractModel
{
	public function read()
	{
		if ($this->targetIsDirectory())
		{
			throw new Exception("Class 'Read' cannot parse a directory '"
				. $this->fullPathToTarget() . "'", 1);
		}
		try
		{
			return RTDictionary::dictionaryWithContentsOfFile(
				$this->fullPathToTarget()
			)->asJSON();
		}
		catch(Exception $e)
		{
			throw new Exception("ReadError", "Unable to parse plist at '"
				. $this->fullPathToTarget() . "'");
		}
	}
}
