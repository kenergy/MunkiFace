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
		\returns RTDictionary
	 */
	protected function recursivelyScanDirectory($aDirectory)
	{
		$results = array();
		
		$this->_globDir($aDirectory, $results, $relativePaths);

		return json_encode($results);
	}




	protected function _globDir($aDir, &$results, $useRelativePaths)
	{
		if (!is_dir($aDir))
		{
			return;
		}
		if (strrpos($aDir, "/") != strlen($aDir)-1)
		{
			$aDir .= "/";
		}

		// Make a working copy of the full path that doesn't have the leading and
		// trailing "/" characters.
		$trimmedPath = $aDir;
		if (strpos($trimmedPath, "/") === 0)
		{
			$trimmedPath = substr($trimmedPath, 1);
		}
		if (strrpos($trimmedPath, "/") === strlen($trimmedPath)-1)
		{
			$trimmedPath = substr($trimmedPath, 0, -1);
		}

		// Find the current working directory.
		$pathParts = explode("/", $trimmedPath);
		$currentDirectory = $pathParts[count($pathParts)-1];

		$results[$currentDirectory] = array();

		$contents = scandir($aDir);
		foreach($contents as $node)
		{
			// skip hidden nodes
			if (strpos($node, ".") === 0)
			{
				continue;
			}


			$fullPathToNode = $aDir . $node;
			if (is_dir($fullPathToNode))
			{
				$this->_globDir($fullPathToNode . "/", $results[$currentDirectory][], $useRelativePaths);
			}
			else
			{
				$results[$currentDirectory][] = $node;
			}
		}
	}
}
