<?php


/**
	Adds the ability to recursively scan a directory for contents, which is what
	most of the models in the project are doing anyway.
 */
abstract class AbstractModel extends RTObject
{




	/**
		Returns an array of dictionaries, each containing a 'path' and 'file' key.
		\returns RTArray
	 */
	protected function recursivelyScanDirectory($aDirectory)
	{
		$results = RTMutableArray::anArray();
		
		$this->_globDir($aDirectory, $results);

		return $results;
	}




	protected function _globDir($aDir, &$array)
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
				$this->_globDir($fullPath . "/", $array);
			}
			else
			{
				$dict = RTDictionary::dictionaryWithObjects_andKeys(
					array($aDir, $file),
					array("path", "file")
				);
				$array->addObject($dict);
			}
		}
	}
}
