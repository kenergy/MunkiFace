<?php


/**
	Adds the ability to recursively scan a directory for contents, which is what
	most of the models in the project are doing anyway.
 */
abstract class AbstractModel extends RTObject
{
	protected static $_munkiDir;
	protected static $_plistExtension;
	protected static $_excludeExtensions;
	protected $fullPathToModelRepo;




	public function munkiDir()
	{
		if (self::$_munkiDir == null)
		{
			self::$_munkiDir = Settings::sharedSettings()->objectForKey("munki-repo");
		}
		return self::$_munkiDir;
	}




	/**
		Returns the file extension for valid plists that are to be included when
		scanning a directory.
		\returns RTString
	 */
	public function plistExtension()
	{
		if (self::$_plistExtension == null)
		{
			self::$_plistExtension =
			Settings::sharedSettings()->objectForKey("plist_extension");
		}
		return self::$_plistExtension;
	}




	/**
		Returns the array of file extensions that are to be ignored during a
		directory scan.
		\returns RTArray
	 */
	public function excludeExtensions()
	{
		if (self::$_excludeExtensions == null)
		{
			self::$_excludeExtensions =
				Settings::sharedSettings()->objectForKey("exclude_extensions");
		}
		return self::$_excludeExtensions;
	}




	public function fullPathToModelRepo()
	{
		if ($this->fullPathToModelRepo == null)
		{
			return $this->munkiDir();
		}
		return $this->fullPathToModelRepo;
	}



	/**
		Allows the models that implement this class to append to the exising munki
		repo path in order to specify a specific folder within that repo. For
		example, you would pass 'pkgsinfo' to this method if you were calling it
		from the PkgsInfoModel.
	 */
	protected function buildFullPathToModelRepo($aPath)
	{
		$aPath = RTString::stringWithString($aPath);
		$munkiPath = RTString::stringWithString($this->munkiDir());
		if ($aPath->hasSuffix("/") == NO)
		{
			$aPath = $aPath->stringByAppendingString("/");
		}

		if ($this->munkiDir()->hasSuffix("/") == NO && $aPath->hasPrefix("/") == NO)
		{
			$munkiPath = $munkiPath->stringByAppendingString("/");
		}

		$this->fullPathToModelRepo = $munkiPath . $aPath;
	}



	/**
		Returns an array of dictionaries, each containing a 'path' and 'file' key.
		\param $aDirectory
		\returns RTDictionary
	 */
	protected function recursivelyScanDirectory($aDirectory)
	{
		$results = array();
		
		$this->_globDir($aDirectory, $results);

		return json_encode($results);
	}




	protected function _globDir($aDir, &$results)
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
				$this->_globDir($fullPathToNode . "/", $results[$currentDirectory][]);
			}
			else
			{
				$fileName = RTString::stringWithString($node);
				// if Settings.plist specifies a valid plist extension and it's not an
				// empty string, make sure the current file has that extension.
				if ($this->plistExtension() != "" &&
					$fileName->hasSuffix($this->plistExtension()) == NO)
				{
					continue;
				}

				// If Settings.plist specifies an array of file extensions that should
				// be exclued, make sure the current file doesn't have any of those
				// extensions.
				for($i = 0; $i < $this->excludeExtensions()->count(); $i++)
				{
					if (
						YES == $fileName->hasSuffix($this->excludeExtensions()->objectAtIndex($i))
					)
					{
						continue 2;
					}
				}

				try
				{
					$dict = RTDictionary::dictionaryWithContentsOfFile(
						RTString::stringWithString($fullPathToNode));
					if ($dict->count() !== 0)
					{
						$results[$currentDirectory][] = $node;
					}
				}
				catch(Exception $e)
				{
					$results[$currentDirectory][] = "(PARSE_ERROR) " . $node;
				}
			}
		}
	}
}
