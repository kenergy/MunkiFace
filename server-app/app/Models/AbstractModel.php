<?php


/**
	Adds the ability to recursively scan a directory for contents, which is what
	most of the models in the project are doing anyway.
 */
abstract class AbstractModel extends RTObject
{
	protected static $_munkiDir;
	protected static $_plistExtensions;
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
	public function plistExtensions()
	{
		if (self::$_plistExtensions == null)
		{
			self::$_plistExtensions =
			Settings::sharedSettings()->objectForKey("plist_extensions");
		}
		return self::$_plistExtensions;
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




	protected function _fixUpPath($aPath)
	{
		$path = RTString::stringWithString($aPath);
		if ($path->hasSuffix("/") == NO)
		{
			$path = $path->stringByAppendingString("/");
		}

		if ($path->hasPrefix("/") == NO)
		{
			$path = RTString::stringWithFormat("/%s", $path);
		}
		return $path;
	}




	protected function _globDir($aDir, &$results)
	{
		if (!is_dir($aDir))
		{
			return;
		}
		$aDir = $this->_fixUpPath($aDir);

		$aRange = RTMakeRange(1, $aDir->length() - 2);
		$trimmedPath = $aDir->subStringWithRange($aRange);

		// Find the current working directory.
		$pathParts = $trimmedPath->componentsSeparatedByString("/");

		$currentDirectory = $pathParts->lastObject();
		$currentIndex = $currentDirectory->description();
		$results[$currentIndex] = array();

		$contents = scandir($aDir);
		$validator = FileNameValidator::alloc()->init();
		foreach($contents as $node)
		{
			$fullPathToNode = $aDir . $node;
			if (is_dir($fullPathToNode) && strpos($node, ".") !== 0)
			{
				$this->_globDir(
					$fullPathToNode . "/",
					$results[$currentIndex][]
				);
			}

			else if ($validator->isValidFileName($node) == YES)
			{
				try
				{
					$dict = RTDictionary::dictionaryWithContentsOfFile(
						RTString::stringWithString($fullPathToNode));
					if ($dict->count() !== 0)
					{
						$results[$currentIndex][] = $node;
					}
				}
				catch(Exception $e)
				{
					$results[$currentIndex][] = "(PARSE_ERROR) " . $node;
				}
			}
		}
	}
}
