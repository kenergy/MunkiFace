<?php
require_once dirname(__FILE__) . "/AbstractModel.php";

class SetAction extends AbstractModel
{
	public function set()
	{
		if ($this->targetIsDirectory())
		{
			throw new Exception("Class 'SetAction' cannot treat directories as files '"
				. $this->fullPathToTarget() . "'", MFInvalidTargetForActionError);
		}


		$parentDir = $this->fullPathToTarget()->stringByDeletingLastPathComponent();
		if (!is_dir($parentDir))
		{
			$components = $parentDir->pathComponents();
			$tmpPath = "";
			for($i = 0; $i < $components->count(); $i++)
			{
				$component = $components->objectAtIndex($i);
				if ($component == "/") continue;
				$tmpPath .= "/" . $components->objectAtIndex($i);
				if (!is_dir($tmpPath))
				{
					if (@mkdir($tmpPath) === NO)
					{
						throw new Exception("Insufficient permissions to mkdir '"
							. $tmpPath . "'",
							MFPermissionsError);
					}
				}
			}
		}

		$json = json_decode(
			HTTPRequest::sharedRequest()->objectForKey("set")->description(),
			YES
		);
		$dict = RTDictionary::dictionaryWithPHPArray($json);
		try
		{
			$dict->writeToFile($this->fullPathToTarget());
			return YES;
		}
		catch(Exception $e)
		{
			throw new Exception("Insufficient permissions to write to file '"
				. $this->fullPathToTarget() . "'", MFPermissionsError);
		}
	}
}
