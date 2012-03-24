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
			$dict = RTDictionary::dictionaryWithContentsOfFile(
				$this->fullPathToTarget()
			);
			if ($dict->allKeys()->count() == 0)
			{
				throw new Exception(
					"Invalid plist specified in '" . $this->fullPathToTarget() . "'",
					MFParseError);
			}
			echo $dict->asJSON();
		}
		catch(Exception $e)
		{
			throw new Exception("Unable to parse plist at '"
				. $this->fullPathToTarget() . "'", MFParseError);
		}
	}
}
