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
	protected $fullPathToTarget;
	protected $target;




	public function munkiDir()
	{
		if (self::$_munkiDir == null)
		{
			self::$_munkiDir = Settings::sharedSettings()->objectForKey("munki-repo");
		}
		return self::$_munkiDir;
	}




	/**
		Sets the target file or path on which the receiver will act.
	 */
	public function setTarget(RTString $aTarget)
	{
		while($aTarget->hasPrefix("../"))
		{
			$aTarget = $aTarget->substringFromIndex(3);
		}
		$this->target = $aTarget;
	}




	/**
		Returns the target upon which the receiver will act. This is a path that is
		relative to the value of AbstractModel::munkiRepo.
		\return RTString
	 */
	public function target()
	{
		if ($this->target == null)
		{
			return RTString::stringWithString("");
		}
		return $this->target;
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




	/**
		Calculates the full path to the target upon which the receiver will act by
		prepending the value of AbstractModel::target.
		\returns RTString
	 */
	public function fullPathToTarget()
	{
		$path = $this->munkiDir()->stringByAppendingPathComponent($this->target());
		if ($path->hasPrefix($this->munkiDir()) == NO)
		{
			throw new Exception("Blocked attempt to read files above the munki repo.",
				MSecurityError);
		}
		return $path;
	}




	/**
		Returns a Boolean value indicating that the target is a directory or not.
		\returns BOOL
	 */
	public function targetIsDirectory()
	{
		return is_dir($this->fullPathToTarget());
	}




	/**
		Returns a Boolean value indicating that the target is a file or not.
	 */
	public function targetIsFile()
	{
		return !$this->targetIsDirectory();
	}



	/**
		Returns an array of dictionaries, each containing a 'path' and 'file' key.
		\returns RTDictionary
	 */
	public function recursivelyScanTarget()
	{
		if ($this->targetIsFile())
		{
			throw new InvalidArgumentException("Target '" . $this->fullPathToTarget()
				. "' is a file and cannot be recursively scanned");
		}

		$arr = RTMutableArray::anArray();
		$this->_globDir($this->fullPathToTarget(), $arr);
		$results = RTMutableDictionary::dictionaryWithObject_forKey(
			$arr,
			$this->fullPathToTarget()->lastPathComponent()
		);
		

		return $results;
	}




	protected function _globDir($aDir, RTArray &$results)
	{
		if (!is_dir($aDir))
		{
			return;
		}

		$contents = scandir($aDir);
		$validator = FileNameValidator::alloc()->init();
		$fullPathToNode = "";
		foreach($contents as $node)
		{
			$fullPathToNode = $aDir->stringByAppendingPathComponent(
				RTString::stringWithString($node));

			// If the node represents a directory but does not start with a "."
			// character...
			if (is_dir($fullPathToNode) && strpos($node, ".") !== 0)
			{
				$arr = RTMutableArray::anArray();
				$this->_globDir($fullPathToNode, $arr);
				$results->addObject(
					RTDictionary::dictionaryWithObject_forKey($arr, $node)
				);
			}

			else if ($validator->isValidFileName($node) == YES)
			{
				try
				{
					// See if we can parse the plist file
					$dict = RTDictionary::dictionaryWithContentsOfFile(
						RTString::stringWithString($fullPathToNode));

					// $node is a valid plist
					if ($dict->count() !== 0)
					{
						$results->addObject($node);
					}
				}
				catch(Exception $e)
				{
					// $node is not a valid plist
					$results->addObject("(PARSE_ERROR) " . $node);
				}
			}
		}
	}
}
