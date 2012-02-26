<?php


/**
	Adds the ability to recursively scan a directory for contents, which is what
	most of the models in the project are doing anyway.
 */
abstract class AbstractModel extends RTObject
{
	protected static $_munkiDir;



	public function munkiDir()
	{
		if (self::$_munkiDir == null)
		{
			self::$_munkiDir = Settings::sharedSettings()->objectForKey("munki-repo");
		}
		return self::$_munkiDir;
	}



	/**
		Returns an array of dictionaries, each containing a 'path' and 'file' key.
		If relativePaths is set to YES, then the munki-path will be striped from the
		beginning of the path. It is set to YES by default.
		\param $aDirectory
		\param $relativePaths
		\returns RTArray
	 */
	protected function recursivelyScanDirectory_relativePaths($aDirectory,
	$relativePaths = YES)
	{
		$results = RTMutableArray::anArray();
		
		$this->_globDir($aDirectory, $results, $relativePaths);

		return $results;
	}




	protected function _globDir($aDir, &$array, $useRelativePaths)
	{
		if (!is_dir($aDir))
		{
			return;
		}

		$contents = RTArray::arrayWithArray(scandir($aDir));

		for($i = 0; $i < $contents->count(); $i++)
		{
			$file = $contents->objectAtIndex($i);
			if ($file->hasPrefix("."))
			{
				continue;
			}
			
			$fullPath = $aDir . $file;
			if (is_dir($fullPath))
			{
				$this->_globDir($fullPath . "/", $array, $useRelativePaths);
			}
			else
			{
				$path = $aDir;
				if ($useRelativePaths == YES)
				{
					$copy = RTString::stringWithString($path);
					$path = $copy->stringByReplacingOccurrencesOfString_withString(
						$this->munkiDir(), RTString::stringWithString(""));
				}
				$dict = RTDictionary::dictionaryWithObjects_andKeys(
					array($path, $file),
					array("path", "file")
				);
				$array->addObject($dict);
			}
		}
	}
}
